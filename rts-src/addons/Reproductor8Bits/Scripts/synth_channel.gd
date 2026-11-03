extends AudioStreamPlayer
class_name SynthChannel

# Tipos de onda basados en el hardware original
enum WaveType { PULSE, TRIANGLE, NOISE, DPCM }
@export var wave_type: WaveType = WaveType.PULSE
# Controla qué tan rápido se apaga naturalmente la nota (mayor número = más rápido)
var decay_speed: float = 0
var duty_cycle: float = 0.5 # 0.5 = 50%, 0.25 = 25%, 0.125 = 12.5%

var playback: AudioStreamGeneratorPlayback
var sample_rate: float
var phase: float = 0.0
var current_frequency: float = 0.0
var is_playing_note: bool = false
var volume_level: float = 0.5 

func _ready() -> void:
	# --- INICIO DE CREACIÓN AUTOMÁTICA DEL BUS ---
	var nombre_bus = "ChiptuneMaster"
	
	# Revisamos si el bus ya existe (para que los 5 canales no lo creen 5 veces)
	var bus_index = AudioServer.get_bus_index(nombre_bus)
	
	if bus_index == -1:
		# 1. Crear el nuevo bus al final de la lista
		AudioServer.add_bus()
		bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(bus_index, nombre_bus)
		
		# 2. Enrutarlo para que su salida vaya al bus "Master"
		AudioServer.set_bus_send(bus_index, "Master")
		
		# 3. Crear el efecto de "estática delgada" (HighPassFilter)
		var filtro_alto = AudioEffectHighPassFilter.new()
		# Ajustar este valor en Hz al gusto (400.0 a 1000.0 suele dar ese tono retro), actualmente 600 como una forma personal de crear la propia firma digital de la creación del plugin
		filtro_alto.cutoff_hz = 600.0 
		
		# 4. Añadir el filtro al bus creado
		AudioServer.add_bus_effect(bus_index, filtro_alto)
	
	# 5. Asignar ESTE nodo de audio al bus configurado
	bus = nombre_bus
	# --- FIN DE CREACIÓN AUTOMÁTICA DEL BUS ---

	# --- CANDADO BLINDADO (IF / ELSE) ---
	if OS.has_feature("mobile") or OS.has_feature("web"):
		# Apagado total: Destruimos cualquier intento de generar sonido en vivo
		set_process(false)
		stop()
		stream = null 
	else:
		# SOLO PARA PC
		var generator = AudioStreamGenerator.new()
		generator.buffer_length = 0.1
		stream = generator
		play()
		
		playback = get_stream_playback()
		
		sample_rate = generator.mix_rate
		if sample_rate <= 0.0:
			sample_rate = AudioServer.get_mix_rate()
			if sample_rate <= 0.0:
				sample_rate = 44100.0


func _process(_delta: float) -> void:
	if OS.has_feature("mobile") or OS.has_feature("web"):
		return
	# 1. Si el reproductor se detuvo por un micro-corte de Android, lo revivimos
	if not playing:
		play()
		playback = get_stream_playback()
		
	# 2. Si perdimos la referencia al generador, la recuperamos
	if playback == null:
		playback = get_stream_playback()
	_generate_wave()

func _generate_wave() -> void:
	if playback == null:
		return
	
	var frames_available: int = playback.get_frames_available()
	if frames_available <= 0:
		return

	frames_available = min(frames_available, 1024)

	var buffer := PackedVector2Array()
	buffer.resize(frames_available)

	if not is_playing_note or current_frequency <= 0.0:
		buffer.fill(Vector2.ZERO)
		playback.push_buffer(buffer)
		return

	var increment: float = current_frequency / sample_rate

	var local_phase: float = phase
	var local_vol: float = volume_level
	var local_decay: float = decay_speed / sample_rate
	var local_duty: float = duty_cycle

	if wave_type == WaveType.PULSE:
		for i in range(frames_available):
			var sample: float = 0.5 if fmod(local_phase, 1.0) < local_duty else -0.5
			if local_vol > 0: 
				local_vol -= local_decay
			else: 
				local_vol = 0.0
			var f_sample = sample * local_vol
			buffer[i] = Vector2(f_sample, f_sample)
			local_phase += increment
			
	elif wave_type == WaveType.TRIANGLE:
		for i in range(frames_available):
			var p: float = fmod(local_phase, 1.0)
			var sample: float = 2.0 * abs(2.0 * p - 1.0) - 1.0
			if local_vol > 0: 
				local_vol -= local_decay
			else: 
				local_vol = 0.0
			var f_sample = sample * local_vol
			buffer[i] = Vector2(f_sample, f_sample)
			local_phase += increment
			
	elif wave_type == WaveType.NOISE:
		for i in range(frames_available):
			var sample: float = randf_range(-0.5, 0.5)
			if local_vol > 0: 
				local_vol -= local_decay
			else: 
				local_vol = 0.0
			var f_sample = sample * local_vol
			buffer[i] = Vector2(f_sample, f_sample)
			local_phase += increment
			
	else:
		buffer.fill(Vector2.ZERO)

	phase = fmod(local_phase, 1.0)
	volume_level = local_vol
	playback.push_buffer(buffer)
	
func play_note(freq: float, vol: float = 0.5) -> void:
	current_frequency = freq
	volume_level = vol
	is_playing_note = true

func stop_note() -> void:
	is_playing_note = false
