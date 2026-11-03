extends Node
class_name ChiptunePlayer

enum TrackType {
	BGM,
	SFX,
	Track_01,
	Track_02,
	Track_03,
	}

const Synth = preload("synth_channel.gd")

# Referencias a los sintetizadores individuales
@onready var pulse1: Synth = $Pulse1
@onready var pulse2: Synth = $Pulse2
@onready var triangle: Synth = $Triangle
@onready var noise: Synth = $Noise
@onready var dpcm: Synth = $DPCM

var pattern_data: Array = []
var current_step: int = 0
var step_timer: float = 0.0
var time_per_step: float = 0.0
var is_playing: bool = false

# Estructura: { "nombre_sonido": { "pattern": Array, "loop": bool } }
var sound_library: Dictionary = {}
var reproductores_nativos: Dictionary = {}
var is_current_track_looping: bool = false

# Velocidad de reproducción (Ajustar según la configuración en Furnace)
@export var ticks_per_row: int = 7 #cantidad de ticks similar a Furnace de modo default
@export var base_fps: float = 60.0 
# Variable para compensar la diferencia de octavas entre Furnace y Godot.
# Un valor de 1 sube una octava, 2 sube dos octavas.
@export var octave_offset: int = 1

@export_group("Configuración de Decay")
@export var pulse1_decay: float = 0
@export var pulse2_decay: float = 0
@export var triangle_decay: float = 0.0 # El bajo suele ser continuo (0.0)
@export var noise_decay: float = 0 # El ruido necesita caer muy rápido, puede ser 8

@export_group("Configuración de Textura (Duty Cycle)")
@export var pulse1_duty: float = 0.5   # 50% (Sonido de pitido estándar)
@export var pulse2_duty: float = 0.25  # 25% (Sonido más rasposo/nasal)


func _ready() -> void:
	# Asignar los tipos de onda correctos a cada canal
	pulse1.wave_type = Synth.WaveType.PULSE
	pulse2.wave_type = Synth.WaveType.PULSE
	triangle.wave_type = Synth.WaveType.TRIANGLE
	noise.wave_type = Synth.WaveType.NOISE
	dpcm.wave_type = Synth.WaveType.DPCM
	
	# 1. Asignar Decays
	pulse1.decay_speed = pulse1_decay
	pulse2.decay_speed = pulse2_decay
	triangle.decay_speed = triangle_decay
	noise.decay_speed = noise_decay
	dpcm.decay_speed = 0.0
	
	# 2. Asignar Duty Cycles (Textura)
	pulse1.duty_cycle = pulse1_duty
	pulse2.duty_cycle = pulse2_duty
	
	time_per_step = float(ticks_per_row) / base_fps
	
	# Solo queremos auto-cargar las pistas si estamos corriendo el juego real
	# (Evitamos que se ejecute en el editor si le pusiste @tool)
	if not Engine.is_editor_hint():
		_auto_cargar_catalogo()
		
	# AÑADE ESTO PARA FORZAR EL SONIDO SI NO PUEDES ESCUCHAR EL SONIDO, ESTO SIRVE PARA SABER SI ESTÁ TODO CORRECTAMENTE CONFIGURADO:
	'''
	print("Forzando nota La (440Hz) en Pulse 1")
	pulse1.play_note(440.0, 0.5)
	'''

func _auto_cargar_catalogo() -> void:
	# Ajusta esta ruta a donde sea que tu panel esté guardando los .tres
	var ruta_partituras = ChiptuneConfig.PARTITURAS_PATH
	
	var dir = DirAccess.open(ruta_partituras)
	if dir:
		print("✅ Directorio abierto: ", ruta_partituras)
	else:
		print("❌ ERROR CRÍTICO: No se pudo acceder a: ", ruta_partituras)
	if dir:
		dir.list_dir_begin()
		var nombre_archivo = dir.get_next()
		
		while nombre_archivo != "":
			print("DEBUG: Archivo encontrado en carpeta: ", nombre_archivo)
			# Ignoramos carpetas y aseguramos que sean archivos .tres
			if not dir.current_is_dir():
				if nombre_archivo.ends_with(".tres") or nombre_archivo.ends_with(".tres.remap"):
					# Limpiamos el nombre para obtener la ruta real sin el .remap
					var ruta_real = ruta_partituras + nombre_archivo.replace(".remap", "")
					#var ruta_completa = ruta_partituras + nombre_archivo
					var ruta_completa =  ruta_real
					var score = load(ruta_completa)
					#var score = ResourceLoader.load(ruta_completa, "Resource", ResourceLoader.CACHE_MODE_REPLACE)
					
					# Registramos el recurso en la memoria del ChiptunePlayer
					if score:
						register_score(score)
						print("🎵 Track cargado en runtime: ", nombre_archivo)
					
			nombre_archivo = dir.get_next()
			
		# Una vez registrados todos, generamos los buffers/buses necesarios
		generar_sonidos()
		print("✅ Autoload ChiptuneCore listo con ", sound_library.size(), " tracks.")
	else:
		push_error("❌ ChiptuneCore: No se pudo abrir la carpeta de partituras en ", ruta_partituras)

func register_score(score: ChiptuneScore) -> void:
	register_sound(score.track_id, score.partitura, score.bus_destino, score.tipo_pista, score.es_loop, score.ticks, score.fps, score.octava, score.decays)

# Se expande la función para recibir la "receta" artística completa de la canción
func register_sound(
	track_id: String, 
	raw_text: String, 
	bus_name: String = "Master", # <--- Define a qué bus de Godot irá (Music, SFX, etc.)
	track_type: TrackType = TrackType.SFX, # <--- Define el tipo de pista que se está usando
	loop: bool = false, 
	ticks: int = 6, 
	fps: float = 60.0, 
	octave: int = 1, 
	decays: Array[float] = [0, 0, 0, 0, 0] # Array para [Pulse1, Pulse2, Triangle, Noise, DPCM]
) -> void:
	if raw_text == "" or raw_text == null:
		push_error("La partitura está vacía para la pista: " + track_id)
		return

	# 1. Obtenemos el hash MD5 del texto de esta partitura
	# Hacemos que el MD5 dependa tanto del texto como de los ajustes de velocidad y ticks
	var raw_signature = raw_text + str(ticks) + str(fps) + str(octave)
	var md5_hash = raw_signature.md5_text()

	# 2. Parseamos el texto directamente
	var data = _parse_furnace_text(raw_text)

	if data.size() > 0:
		sound_library[track_id] = {
			"pattern": data,
			"loop": loop,
			"ticks": ticks,
			"fps": fps,
			"octave": octave,
			"decays": decays,
			"md5": md5_hash, # <--- Guardamos la huella digital para validar cambios en la partitura
			"bus": bus_name, # <--- Guardamos el bus deseado
			"type": track_type # <--- GUARDAMOS EL TIPO INDEPENDIENTEMENTE DEL BUS
		}
		print("Pista registrada en memoria: ", track_id, " -> Bus: ", bus_name, " | Tipo: ", track_type)
	else:
		push_error("No se pudo registrar la pista: " + track_id)

#--- CREADOR DE BUSES CON FILTRO RETRO ---
func get_or_create_chiptune_bus(target_bus: String) -> String:
	# Crea un sub-bus dinámico (ej. "Chip_SFX") para mantener el filtro retro
	var chiptune_bus = "Chip" + target_bus
	var bus_index = AudioServer.get_bus_index(chiptune_bus)

	if bus_index == -1:
		AudioServer.add_bus()
		bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(bus_index, chiptune_bus)
		AudioServer.set_bus_send(bus_index, target_bus)
		
		#Se mantiene todos los audios de manera exacta a todos los tipos de Track hasta definir una nueva forma de hacer estos cambios
		'''
		# Solo filtramos los SFX, la música debe conservar sus bajos limpios
		if ((target_bus != "Musica") || (target_bus != "Music")):
			var filtro = AudioEffectHighPassFilter.new()
			filtro.cutoff_hz = 600.0 
			AudioServer.add_bus_effect(bus_index, filtro)
		'''

	return chiptune_bus

func generar_sonidos() -> void:
	for track_id in sound_library.keys():
		var config = sound_library[track_id]

		# === RUTA A: EXPORTACIÓN WEB (Memoria RAM Efímera) ===
		if OS.has_feature("web"):
			print("🖥️ WEB detectada: Horneando audio a RAM: ", track_id)
			var stream_wav = _hornear_matematica_a_stream_wav(config)
			_cargar_reproductor_desde_ram(track_id, stream_wav, config)
			
		# === RUTA B: MÓVILES (Caché en disco con MD5) ===
		elif OS.has_feature("mobile"):
			var ruta_cache = "user://" + track_id + ".dat" 
			var ruta_md5 = "user://" + track_id + ".md5"
			var requiere_horneado = true
			
			if FileAccess.file_exists(ruta_cache) and FileAccess.file_exists(ruta_md5):
				var file_md5 = FileAccess.open(ruta_md5, FileAccess.READ)
				var saved_md5 = file_md5.get_as_text().strip_edges()
				file_md5.close()
				
				if saved_md5 == config["md5"]:
					requiere_horneado = false
					print("✅ USANDO CACHÉ EXISTENTE: ", track_id)
			
			if requiere_horneado:
				print("🔥 HORNEANDO AUDIO MÓVIL: ", track_id)
				_hornear_matematica_a_bytes(track_id, config, ruta_cache)
				var file_md5 = FileAccess.open(ruta_md5, FileAccess.WRITE)
				file_md5.store_string(config["md5"])
				file_md5.close()
			
			_cargar_reproductor_desde_cache(track_id, ruta_cache, config)
			
		# === RUTA C: PC (Escritorio) ===
		else:
			# EN PC: Horneamos a RAM SOLAMENTE los Efectos (SFX) para que no interrumpan a la Música
			if config.get("type", TrackType.SFX) == TrackType.SFX:
				print("💻 PC: Horneando SFX a RAM para permitir polifonía: ", track_id)
				var stream_wav = _hornear_matematica_a_stream_wav(config)
				_cargar_reproductor_desde_ram(track_id, stream_wav, config)


func _generar_buffer_audio(config: Dictionary) -> PackedByteArray:
	octave_offset = config["octave"]
	var mix_rate = 44100.0
	var local_time_per_step = float(config["ticks"]) / config["fps"]
	var frames_per_step = int(local_time_per_step * mix_rate)
	var total_frames = config["pattern"].size() * frames_per_step

	var byte_data = PackedByteArray()
	byte_data.resize(total_frames * 4) 
	var current_byte = 0

	var phase_p1 = 0.0; var vol_p1 = 0.0; var freq_p1 = 0.0
	var phase_p2 = 0.0; var vol_p2 = 0.0; var freq_p2 = 0.0
	var phase_tri = 0.0; var vol_tri = 0.0; var freq_tri = 0.0
	var phase_noi = 0.0; var vol_noi = 0.0

	var dec_p1 = config["decays"][0] / mix_rate
	var dec_p2 = config["decays"][1] / mix_rate
	var dec_tri = config["decays"][2] / mix_rate
	var dec_noi = config["decays"][3] / mix_rate

	for step_idx in range(config["pattern"].size()):
		var row = config["pattern"][step_idx]
		
		if row["pulse1"].has("note"):
			if row["pulse1"]["note"] == "OFF": vol_p1 = 0.0
			else: freq_p1 = _note_to_frequency(row["pulse1"]["note"]); vol_p1 = 0.5
			
		if row["pulse2"].has("note"):
			if row["pulse2"]["note"] == "OFF": vol_p2 = 0.0
			else: freq_p2 = _note_to_frequency(row["pulse2"]["note"]); vol_p2 = 0.5
			
		if row["triangle"].has("note"):
			if row["triangle"]["note"] == "OFF": vol_tri = 0.0
			else: freq_tri = _note_to_frequency(row["triangle"]["note"]); vol_tri = 0.5
			
		if row["noise"].has("note"):
			if row["noise"]["note"] == "OFF": vol_noi = 0.0
			else: vol_noi = 0.4
			
		var inc_p1 = freq_p1 / mix_rate
		var inc_p2 = freq_p2 / mix_rate
		var inc_tri = freq_tri / mix_rate
		
		for i in range(frames_per_step):
			var sample_final = 0.0
			
			if vol_p1 > 0:
				var s = 0.5 if fmod(phase_p1, 1.0) < pulse1_duty else -0.5
				sample_final += s * vol_p1
				phase_p1 += inc_p1
				vol_p1 = max(0.0, vol_p1 - dec_p1)
				
			if vol_p2 > 0:
				var s = 0.5 if fmod(phase_p2, 1.0) < pulse2_duty else -0.5
				sample_final += s * vol_p2
				phase_p2 += inc_p2
				vol_p2 = max(0.0, vol_p2 - dec_p2)
				
			if vol_tri > 0:
				var p = fmod(phase_tri, 1.0)
				var s = 2.0 * abs(2.0 * p - 1.0) - 1.0
				sample_final += s * vol_tri
				phase_tri += inc_tri
				vol_tri = max(0.0, vol_tri - dec_tri)
				
			if vol_noi > 0:
				var s = randf_range(-0.5, 0.5)
				sample_final += s * vol_noi
				vol_noi = max(0.0, vol_noi - dec_noi)
			
			# Aplicamos el multiplicador para evitar clipping (estática)
			var int_sample = int(clamp(sample_final * 0.35, -1.0, 1.0) * 32767.0)
			
			byte_data.encode_s16(current_byte, int_sample)
			byte_data.encode_s16(current_byte + 2, int_sample)
			current_byte += 4

	return byte_data

func _hornear_matematica_a_stream_wav(config: Dictionary) -> AudioStreamWAV:
	var byte_data = _generar_buffer_audio(config)
	var stream = AudioStreamWAV.new()
	# CORRECCIÓN WEB 1: El formato DEBE declararse ANTES de pasar los datos
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 44100
	stream.stereo = true
	stream.data = byte_data # Los datos se asignan al final
	return stream

func _hornear_matematica_a_bytes(track_id: String, config: Dictionary, ruta_cache: String) -> void:
	var byte_data = _generar_buffer_audio(config)
	var file = FileAccess.open(ruta_cache, FileAccess.WRITE)
	file.store_buffer(byte_data)
	file.close()

func _cargar_reproductor_desde_ram(track_id: String, stream: AudioStreamWAV, config: Dictionary) -> void:
	_asignar_reproductor(track_id, stream, config)

func _cargar_reproductor_desde_cache(track_id: String, ruta_cache: String, config: Dictionary) -> void:
	var file = FileAccess.open(ruta_cache, FileAccess.READ)
	if file == null:
		return
	var buffer = file.get_buffer(file.get_length())
	file.close()

	var stream = AudioStreamWAV.new()
	# CORRECCIÓN WEB 1: Formato antes que datos
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 44100
	stream.stereo = true
	stream.data = buffer

	_asignar_reproductor(track_id, stream, config)


func _asignar_reproductor(track_id: String, stream: AudioStreamWAV, config: Dictionary) -> void:
	# IMPORTANTE: Desactivamos el loop interno para evitar el crash de Android
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	
	var reproductor = AudioStreamPlayer.new()
	reproductor.stream = stream
	reproductor.volume_db = 0.0 
	
	# CONECTAMOS LA SEÑAL: Cuando termine, llamamos a nuestra propia lógica
	# Esto es mucho más seguro que dejar que el motor de audio gestione el loop solo
	reproductor.finished.connect(_on_audio_finished.bind(track_id))

	var target_bus = config.get("bus", "Master")
	reproductor.bus = get_or_create_chiptune_bus(target_bus)
	reproductor.process_mode = Node.PROCESS_MODE_ALWAYS 

	add_child(reproductor)
	reproductores_nativos[track_id] = reproductor
	print("✅ Reproductor nativo (WAV) listo para: ", track_id)

# --- EL ROUTER PRINCIPAL ---
func play_sound(track_id: String) -> void:
	print("▶️ SOLICITUD DE AUDIO RECIBIDA: ", track_id) # DEBUG VISUAL
	if not sound_library.has(track_id):
		push_warning("Pista no encontrada en el registro: " + track_id)
		return

	var config = sound_library[track_id]

	if OS.has_feature("mobile") or OS.has_feature("web"):
		# Móvil y Web siempre usan audio horneado para todo
		play_sound_bake(track_id)
	else:
		# PC toma decisiones basadas en el TIPO de pista (BGM o SFX)
		if config.get("type", TrackType.SFX) == TrackType.BGM:
			play_sound_realtime(track_id)
		else:
			play_sound_bake(track_id)

func stop() -> void:
	if OS.has_feature("mobile") or OS.has_feature("web"):
		stop_bake()
	else:
		stop_realtime()

# --- FUNCIONES NATIVAS (ANDROID) ---
func play_sound_bake(track_id: String) -> void:
	if reproductores_nativos.has(track_id):
		reproductores_nativos[track_id].play()
		print("🔊 REPRODUCIENDO EN WEB/MÓVIL: ", track_id) # DEBUG VISUAL
	else:
		push_warning("Audio horneado no encontrado: " + track_id)

func stop_bake() -> void:
	for rep in reproductores_nativos.values():
		rep.stop()

func play_sound_realtime(track_id: String) -> void:
	if not sound_library.has(track_id):
		push_warning("Pista no encontrada en el registro: " + track_id)
		return

	var config = sound_library[track_id]
	pattern_data = config["pattern"]
	is_current_track_looping = config["loop"]
	ticks_per_row = config["ticks"]
	base_fps = config["fps"]
	time_per_step = float(ticks_per_row) / base_fps

	var decays = config["decays"]
	pulse1.decay_speed = decays[0]
	pulse2.decay_speed = decays[1]
	triangle.decay_speed = decays[2]
	noise.decay_speed = decays[3]
	dpcm.decay_speed = decays[4]

	# ENRUTAMIENTO DINÁMICO DE SINTETIZADORES PC
	var target_bus = config.get("bus", "Master")
	var chiptune_bus = get_or_create_chiptune_bus(target_bus)
	pulse1.bus = chiptune_bus
	pulse2.bus = chiptune_bus
	triangle.bus = chiptune_bus
	noise.bus = chiptune_bus
	dpcm.bus = chiptune_bus

	time_per_step = float(ticks_per_row) / base_fps
	current_step = 0
	step_timer = time_per_step 
	is_playing = true
	print("🔊 REPRODUCIENDO EN PC (Tiempo Real): ", track_id)

#Versión inicial de reproducción de sonido
func play_score_realtime(file_path: String) -> void:
	pattern_data = _parse_furnace_text(file_path)
	print("Cantidad de pasos de partitura leídos: ", pattern_data.size())
	current_step = 0
	
	# MODIFICACIÓN: Iniciar el timer lleno para que el primer paso suene de inmediato
	step_timer = time_per_step 
	is_playing = true


func stop_realtime() -> void:
	is_playing = false
	pulse1.stop_note()
	pulse2.stop_note()
	triangle.stop_note()
	noise.stop_note()
	dpcm.stop_note()

# Esta función es la que "revive" el sonido de forma segura
func _on_audio_finished(track_id: String) -> void:
	# Solo hacemos loop si la configuración original lo pedía
	if sound_library.has(track_id) and sound_library[track_id]["loop"]:
		# Verificamos que el reproductor exista
		await get_tree().create_timer(0.05).timeout
		if reproductores_nativos.has(track_id):
			reproductores_nativos[track_id].play()
			print("🔄 Loop seguro activado para: ", track_id)

func _process(delta: float) -> void:
	# En móvil/web, la matemática en vivo no se procesa
	if OS.has_feature("mobile") or OS.has_feature("web"):
		return
		
	if not is_playing or pattern_data.size() == 0:
		return

	# Sumamos el tiempo transcurrido al reloj
	step_timer += delta

	# Procesamos los pasos necesarios según el tiempo acumulado
	while step_timer >= time_per_step:
		step_timer -= time_per_step
		
		if current_step < pattern_data.size():
			_play_current_step()
		
		current_step += 1
		
		if current_step >= pattern_data.size():
			if is_current_track_looping:
				current_step = 0
			else:
				stop_realtime()
				break

func _play_current_step() -> void:
	var row = pattern_data[current_step]
	_apply_channel_data(pulse1, row["pulse1"])
	_apply_channel_data(pulse2, row["pulse2"])
	_apply_channel_data(triangle, row["triangle"])
	
	# El ruido usa la frecuencia para variar su aspereza, un valor fijo funciona bien como base
	if row["noise"].has("note") and row["noise"]["note"] != "OFF":
		noise.play_note(800.0, 0.4) 
	elif row["noise"].has("note") and row["noise"]["note"] == "OFF":
		noise.stop_note()

func _apply_channel_data(channel: Synth, data: Dictionary) -> void:
	if data.has("note"):
		if data["note"] == "OFF":
			channel.stop_note()
		else:
			var freq = _note_to_frequency(data["note"])
			channel.play_note(freq)

# --- SISTEMA DE PARSEO DEL TEXTO ---
func _parse_furnace_text(raw_text: String) -> Array:
	var rows = []
	# OJO AQUÍ: Ya no usamos FileAccess. Separamos el String directo en líneas.
	# Inicialmente se usaba un FileAccess para leer los tracks en .txt, ahora se guarda el track en un .tres
	var lines = raw_text.split("\n", false)

	for line in lines:
		line = line.strip_edges()
		
		# Filtro: Si la línea no tiene al menos 4 separadores, es texto basura
		if line.count("|") < 4:
			continue
			
		# Limpieza: Si el copiado directo dejó un '|' suelto al final, lo quitamos
		line = line.trim_suffix("|")
		
		# Dividimos la línea en columnas usando el separador
		var cols = line.split("|", false)
		
		# Truco maestro del offset
		if cols.size() >= 5:
			var offset = cols.size() - 5
			
			var row_data = {
				"pulse1": _parse_cell(cols[offset + 0]),
				"pulse2": _parse_cell(cols[offset + 1]),
				"triangle": _parse_cell(cols[offset + 2]),
				"noise": _parse_cell(cols[offset + 3]),
				"dpcm": _parse_cell(cols[offset + 4])
			}
			rows.append(row_data)
			
	return rows

func _parse_cell(cell_text: String) -> Dictionary:
	var txt = cell_text.strip_edges()
	var result = {}
	if txt.length() >= 3:
		var note_str = txt.substr(0, 3)
		if note_str == "---" or note_str == "...":
			pass # Celda vacía, mantener la nota anterior
		elif note_str == "OFF" or note_str == "===":
			result["note"] = "OFF"
		else:
			result["note"] = note_str
	return result

func _note_to_frequency(note_str: String) -> float:
	# Extrae el formato "C-3", "D#4"
	'''
	Explicación básica de partituras:
		C: DO
		D: RE
		E: MI
		F: FA
		G: SOL
		A: LA
		B: SI
		#: Sostenido
		-: Bemol
		1, 2, 3, 4, etc... Octava en la que se encuentra la nota
	'''
	var notes = ["C-", "C#", "D-", "D#", "E-", "F-", "F#", "G-", "G#", "A-", "A#", "B-"]
	var pitch_class = note_str.substr(0, 2)
	
	# Sumamos el offset a la octava leída del texto
	var octave = note_str.substr(2, 1).to_int() + octave_offset 
	
	var note_index = notes.find(pitch_class)
	if note_index == -1: return 0.0
	
	# Cálculo estándar de frecuencia relativa a A4 (440Hz)
	var semitones_from_a4 = (octave - 4) * 12 + (note_index - 9)
	return 440.0 * pow(2.0, semitones_from_a4 / 12.0)

# --- AUTO-CARGA DE RECURSOS ---
func auto_cargar_directorio(ruta_carpeta: String = "res://Partituras/") -> void:
	var dir = DirAccess.open(ruta_carpeta)
	if dir:
		dir.list_dir_begin()
		var archivo = dir.get_next()
		while archivo != "":
			if not dir.current_is_dir() and archivo.ends_with(".tres"):
				var score = load(ruta_carpeta + archivo) as ChiptuneScore
				if score:
					register_score(score)
			archivo = dir.get_next()
		
		# Una vez registradas todas, horneamos las necesarias
		generar_sonidos()
		print("✅ Catálogo Chiptune cargado automáticamente.")
