@tool
extends Control

@onready var lista_partituras: ItemList = $VBoxContainer/HSplitContainer/ItemList
@onready var btn_recargar: Button = $VBoxContainer/HBoxContainer/BtnRecargar # Un botón opcional para refrescar la lista
@onready var btn_catalogo: Button = $VBoxContainer/HBoxContainer/BtnCatalogo
@onready var btn_play: Button = $VBoxContainer/HBoxContainer/BtnPlay
@onready var btn_stop: Button = $VBoxContainer/HBoxContainer/BtnStop
@onready var btn_nuevo: Button = $VBoxContainer/HBoxContainer/BtnNuevo
@onready var btn_editar: Button = $VBoxContainer/HBoxContainer/BtnEditarPartitura
@onready var btn_eliminar: Button = $VBoxContainer/HBoxContainer/BtnBorrarPartitura
@onready var btn_donar: Button = $VBoxContainer/HBoxContainer/BtnDonar
@onready var spnb_tiempo_preview: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/SpnB_Duracion
@onready var reproductor_preview: AudioStreamPlayer = $ReproductorPreview
@onready var btn_preview: Button = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/BtnPreview

@onready var tracker_tree: Tree = $VBoxContainer/HSplitContainer/VBoxContainer/TrackerTree
@onready var btn_cortarnota: Button = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/Btn_CortarNota
@onready var lbl_canal: Label = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/Lbl_Canal
@onready var btn_guardar: Button = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/Btn_Guardar
@onready var chkbtn_guardar_toda_fila: Button = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/ChkBtn_TodasLasCeldas
@onready var lbl_editando: Label = $VBoxContainer/HSplitContainer/VBoxContainer/Lbl_Editando

@onready var nota_c: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasBlancas/C
@onready var nota_d: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasBlancas/D
@onready var nota_e: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasBlancas/E
@onready var nota_f: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasBlancas/F
@onready var nota_g: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasBlancas/G
@onready var nota_a: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasBlancas/A
@onready var nota_b: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasBlancas/B

@onready var nota_csostenido: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasNegras/C_Sostenido
@onready var nota_dsostenido: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasNegras/D_Sostenido
@onready var nota_fsostenido: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasNegras/F_Sostenido
@onready var nota_gsostenido: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasNegras/G_Sostenido
@onready var nota_asostenido: Button = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasNegras/A_Sostenido

#Referencias a ajsute de chiptune player visual
@onready var opt_trackid: OptionButton = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Opt_TrackID
@onready var opt_btntipo: OptionButton = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/OptBtn_Tipo
@onready var txt_busdestino: LineEdit = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Txt_BusDestino
@onready var chb_loop: CheckBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Chb_Loop
@onready var spnb_ticks: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Spnb_Ticks
@onready var spnb_fps: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Spnb_FPS
@onready var spnb_octavabase: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Spnb_OctavaBase
@onready var spnb_decay_dpcm: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Spnb_DecayDPCM
@onready var spnb_decay_p1: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Spnb_DecayP1
@onready var spnb_decay_p2: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Spnb_DecayP2
@onready var spnb_decay_triangle: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Spnb_DecayTriangle
@onready var spnb_decay_noise: SpinBox = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/ScrollContainer/Interfaz_Resource_ChiptuneScore/Spnb_DecayNoise

# --- VARIABLE ANCLA PARA EL EDITOR ---
# Esta variable guarda la ruta exacta del archivo que hicimos doble clic.
var archivo_en_edicion: String = ""
# --- VARIABLE MENÚ CONTEXTUAL ---
var menu_contextual: PopupMenu

var chptnscore: ChiptuneScore = ChiptuneScore.new()
var urldonacion = ChiptuneConfig.Donacion_PayPal

# La carpeta donde el usuario guardará sus archivos .tres
@export var ruta_partituras: String = ChiptuneConfig.PARTITURAS_PATH

# Referencia al plugin principal para acceder a la interfaz (Solución definitiva para Godot 4.0 que genera conflictos al intentar usar EditorPlugin)
var editor_plugin_ref: EditorPlugin

# Instancia temporal para usar las matemáticas de horneado (sin agregarlo a la escena)
var motor_temporal: Node

# Esto servirá para saber qué celda estamos seleccionando en el tracker tree para identificar el canal en el que estamos trabajando
var celda_actual_item: TreeItem = null
var celda_actual_columna: int = -1

# Llamado cuando los nodos entran al árbol de escenas por primera vez
func _ready():
	
	# --- CONFIGURACIÓN DEL MENÚ CONTEXTUAL --- Esto al presioanr clic derecho en el TrackerTree
	menu_contextual = PopupMenu.new()
	menu_contextual.add_item("Insertar Fila Arriba", 0)
	menu_contextual.add_item("Insertar Fila Abajo", 1)
	menu_contextual.add_separator()
	menu_contextual.add_item("Eliminar Fila(s)", 2)
	menu_contextual.add_separator()
	menu_contextual.add_item("Mutear Fila Completa (OFF)", 3)
	add_child(menu_contextual)
		
	# 1. Cargamos el script del motor solo para usar sus fórmulas matemáticas, de esta manera el motor del reproductor de Chiptune Player se reutiliza y el audio que se escucha en ese momento es como se escuchará en el juego al ejecutarse
	var ScriptMotor = preload(ChiptuneConfig.MOTOR_PATH)
	motor_temporal = ScriptMotor.new()
	
	if btn_recargar and not btn_recargar.pressed.is_connected(actualizar_lista):
		btn_recargar.pressed.connect(actualizar_lista)
	if btn_catalogo and not btn_catalogo.pressed.is_connected(_on_editar_catalogo_pressed):
		btn_catalogo.pressed.connect(_on_editar_catalogo_pressed)
	if btn_play and not btn_play.pressed.is_connected(_on_play_pressed):
		btn_play.pressed.connect(_on_play_pressed)
	if btn_stop and not btn_stop.pressed.is_connected(_on_stop_pressed):
		btn_stop.pressed.connect(_on_stop_pressed)
	if btn_nuevo and not btn_nuevo.pressed.is_connected(_on_nuevo_pressed):
		btn_nuevo.pressed.connect(_on_nuevo_pressed)
	if btn_editar and not btn_editar.pressed.is_connected(_on_editar_pressed):
		btn_editar.pressed.connect(_on_editar_pressed)
	if btn_eliminar and not btn_eliminar.pressed.is_connected(_on_eliminar_pressed):
		btn_eliminar.pressed.connect(_on_eliminar_pressed)
	if btn_donar and not btn_donar.pressed.is_connected(_on_donar_pressed):
		btn_donar.pressed.connect(_on_donar_pressed)
	if btn_cortarnota and not btn_cortarnota.pressed.is_connected(_on_btn_cortar_nota_pressed):
		btn_cortarnota.pressed.connect(_on_btn_cortar_nota_pressed)
	if btn_preview and not btn_preview.pressed.is_connected(_on_preview_pressed):
		btn_preview.pressed.connect(_on_preview_pressed)
	if btn_guardar and not btn_guardar.pressed.is_connected(_on_guardar_pressed):
		btn_guardar.pressed.connect(_on_guardar_pressed)
	if lista_partituras and not lista_partituras.item_activated.is_connected(_on_item_doble_click):
		lista_partituras.item_activated.connect(_on_item_doble_click)
	if tracker_tree and not tracker_tree.cell_selected.is_connected(_on_tracker_tree_cell_selected):
		tracker_tree.cell_selected.connect(_on_tracker_tree_cell_selected)

	# Conectamos el clic del mouse en el Tree (incluyendo el clic derecho)
	menu_contextual.id_pressed.connect(_on_menu_contextual_id_pressed)
	if tracker_tree and not tracker_tree.item_mouse_selected.is_connected(_on_tracker_tree_item_mouse_selected):
		tracker_tree.item_mouse_selected.connect(_on_tracker_tree_item_mouse_selected)

	#Inicializamos el tracker para la visualización de canales de chiptune player
	_inicializar_tracker()
	# Llenamos la lista al cargar el plugin
	actualizar_lista()
	
	_conectar_teclado_virtual()
	_poblar_dropdown_tracks()
	_poblar_dropdown_tipos_tracks()


func actualizar_lista() -> void:
	if not lista_partituras: return
	
	lista_partituras.clear()
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(ruta_partituras):
		dir.make_dir(ruta_partituras)
		return

	dir = DirAccess.open(ruta_partituras)
	if dir:
		dir.list_dir_begin()
		var nombre_archivo = dir.get_next()
		while nombre_archivo != "":
			if not dir.current_is_dir() and nombre_archivo.ends_with(".tres"):
				# Cargamos genéricamente y usamos .get() para evitar bugs de caché del editor
				var recurso = load(ruta_partituras + nombre_archivo)
				if recurso:
					var track_val = recurso.get("track_id")
					var texto_mostrar = track_val if (track_val != null and str(track_val) != "") else nombre_archivo
					var item_index = lista_partituras.item_count
					lista_partituras.add_item(str(texto_mostrar))
					
					# TRUCO: Guardamos la ruta del archivo dentro del item de la lista para leerlo después
					lista_partituras.set_item_metadata(item_index, ruta_partituras + nombre_archivo)
			nombre_archivo = dir.get_next()

func _inicializar_tracker() -> void:
	# 1. Configurar los títulos de las columnas
	tracker_tree.set_column_title(0, "Paso")
	tracker_tree.set_column_title(1, "Pulse 1")
	tracker_tree.set_column_title(2, "Pulse 2")
	tracker_tree.set_column_title(3, "Triangle")
	tracker_tree.set_column_title(4, "Noise")
	tracker_tree.set_column_title(5, "DPCM")
	
	# Hacer que la columna "Paso" sea más delgada que las demás
	tracker_tree.set_column_expand(0, false)
	tracker_tree.set_column_custom_minimum_width(0, 50)

	# 2. Crear la raíz oculta (necesaria en Godot)
	tracker_tree.clear()
	var root = tracker_tree.create_item()
	
	# 3. Llenar la tabla con 16 filas de prueba (como un patrón de Furnace)
	for i in range(16):
		var fila = tracker_tree.create_item(root)
		
		# Columna 0: El número de paso (00, 01, 02...)
		fila.set_text(0, str(i).pad_zeros(2))
		fila.set_text_alignment(0, HORIZONTAL_ALIGNMENT_CENTER)
		
		# Columnas 1 a 5: Rellenar con los puntos por defecto
		for col in range(1, 6):
			fila.set_text(col, "...")
			fila.set_text_alignment(col, HORIZONTAL_ALIGNMENT_CENTER)

func _poblar_dropdown_tracks() -> void:
	ChiptuneConfig.asegurar_catalogo()
	chptnscore = ChiptuneScore.new()
	print(chptnscore._get_property_list())

	if not opt_trackid: return
	opt_trackid.clear()
	for lista in chptnscore._get_property_list(): #Únicamente reutilizo la propiedad de leer los tracks en mi lista de tracks disponibles como si se tratara de mi resource ChiptuneScore
		for nombretrack in lista.hint_string.split(","):
			opt_trackid.add_item(str(nombretrack))

func _poblar_dropdown_tipos_tracks() -> void:
	if not opt_btntipo: return
	opt_btntipo.clear()
	
	# Accedemos al enum TrackType directamente desde tu script principal
	var script_motor = preload(ChiptuneConfig.MOTOR_PATH)
	if "TrackType" in script_motor:
		for tipo_nombre in script_motor.TrackType.keys():
			opt_btntipo.add_item(str(tipo_nombre))

func _conectar_teclado_virtual() -> void:
	# Buscamos referencia a los contenedores de las teclas
	var blancas = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasBlancas
	var negras = $VBoxContainer/HSplitContainer/VBoxContainer/Interfaz_Ajustes_Musica/PianoUI/TeclasNegras
	
	# Bucle para las teclas blancas (C, D, E...)
	if blancas:
		for boton in blancas.get_children():
			if boton is Button:
				# Tomamos el texto del botón (ej: "C-"), ya tienen el "-" en el texto que requiere la partitura
				var nota = boton.text.strip_edges()
				
				if not boton.pressed.is_connected(_on_tecla_piano_presionada):
					# Usamos .bind(nota) para pasarle el parámetro a la función
					boton.pressed.connect(_on_tecla_piano_presionada.bind(nota))
	
	# Bucle para las teclas negras (C#, D#...)
	if negras:
		for boton in negras.get_children():
			if boton is Button:
				# Las negras en su texto dicen "C#", "D#", etc.
				var nota = boton.text.strip_edges() 
				
				if not boton.pressed.is_connected(_on_tecla_piano_presionada):
					boton.pressed.connect(_on_tecla_piano_presionada.bind(nota))

func _on_preview_pressed() -> void:
	# 1. Detener si ya estaba sonando algo
	if reproductor_preview.playing:
		reproductor_preview.stop()

	print("🎵 Construyendo previsualización desde el Tracker visual y Ajustes...")
	
	# 2. Leer la tabla completa (Tree) y convertirla al formato de array
	var pattern_actual = _leer_tracker_a_array()
	
	# Validar que no esté vacía
	if pattern_actual.size() == 0:
		print("⚠️ El tracker está vacío. No hay nada que reproducir.")
		return

	# 3. Leemos los parámetros directamente desde los nodos SpinBox/CheckBox de la interfaz
	# (Usamos valores genéricos por defecto para la preview si no existieran valores)
	var config_preview = {
		"pattern": pattern_actual,
		"loop": chb_loop.button_pressed if chb_loop else false,
		"ticks": int(spnb_ticks.value) if spnb_ticks else 6,
		"fps": spnb_fps.value if spnb_fps else 60.0,
		"octave": int(spnb_octavabase.value) if spnb_octavabase else 0,
		"decays": [
			spnb_decay_p1.value if spnb_decay_p1 else 0.0,
			spnb_decay_p2.value if spnb_decay_p2 else 0.0,
			spnb_decay_triangle.value if spnb_decay_triangle else 0.0,
			spnb_decay_noise.value if spnb_decay_noise else 0.0,
			spnb_decay_dpcm.value if spnb_decay_dpcm else 0.0
		]
	}
	
	# 4. Hornear directamente a RAM (sin tocar el disco)
	var stream_wav = motor_temporal._hornear_matematica_a_stream_wav(config_preview)
	
	# 5. Reproducir
	reproductor_preview.stream = stream_wav
	reproductor_preview.play()
	print("▶️ Reproduciendo previsualización en vivo (Ticks: ", config_preview["ticks"], " FPS: ", config_preview["fps"], ").")

func _on_guardar_pressed() -> void:
	# 1. Validamos que tengamos un archivo anclado
	if archivo_en_edicion == "" or not FileAccess.file_exists(archivo_en_edicion):
		push_error("⚠️ No hay ninguna partitura cargada en el editor para guardar.")
		print("⚠️ No hay ninguna partitura cargada en el editor para guardar.")
		return
		
	# 2. Cargamos el recurso original del disco
	var recurso = load(archivo_en_edicion) as ChiptuneScore
	if not recurso:
		push_error("❌ Error al acceder al archivo original para sobreescribirlo.")
		return
		
	# 3. Extraemos todos los valores actuales de la interfaz
	if opt_trackid: recurso.track_id = opt_trackid.get_item_text(opt_trackid.selected)
	if txt_busdestino: recurso.bus_destino = txt_busdestino.text
	if opt_btntipo: recurso.tipo_pista = opt_btntipo.selected
	if chb_loop: recurso.es_loop = chb_loop.button_pressed
	if spnb_ticks: recurso.ticks = int(spnb_ticks.value)
	if spnb_fps: recurso.fps = spnb_fps.value
	if spnb_octavabase: recurso.octava = int(spnb_octavabase.value)
	
	if spnb_decay_p1 and spnb_decay_p2 and spnb_decay_triangle and spnb_decay_noise and spnb_decay_dpcm:
			# Declaramos explícitamente que es un Array de floats para cumplir con el tipado estricto del Resource
			var nuevos_decays: Array[float] = [
				float(spnb_decay_p1.value),
				float(spnb_decay_p2.value),
				float(spnb_decay_triangle.value),
				float(spnb_decay_noise.value),
				float(spnb_decay_dpcm.value)
			]
			recurso.decays = nuevos_decays
	# 4. Reconstruimos la partitura visual a texto
	recurso.partitura = _leer_tracker_a_texto_furnace()
	
	# 5. Guardamos en el disco
	var err = ResourceSaver.save(recurso, archivo_en_edicion)
	if err == OK:
		print("💾 ¡Guardado exitoso! Archivo actualizado: ", archivo_en_edicion.get_file())
		# Opcional: Actualizar la lista por si se cambia el Track ID, escenario que creo que será más usual de lo que me imagino
		actualizar_lista() 
	else:
		push_error("❌ Falló el guardado del recurso. Código de error: ", err)

func _leer_tracker_a_texto_furnace() -> String:
	var texto_final = ""
	var root = tracker_tree.get_root()
	if not root: 
		return texto_final
		
	var fila_actual = root.get_first_child()
	
	while fila_actual != null:
		var txt_p1 = fila_actual.get_text(1).strip_edges()
		var txt_p2 = fila_actual.get_text(2).strip_edges()
		var txt_tri = fila_actual.get_text(3).strip_edges()
		var txt_noi = fila_actual.get_text(4).strip_edges()
		var txt_dpcm = fila_actual.get_text(5).strip_edges()
		
		# Construimos la línea estilo Furnace: C-4 | --- | --- | --- | ---
		var linea = "%s | %s | %s | %s | %s\n" % [txt_p1, txt_p2, txt_tri, txt_noi, txt_dpcm]
		texto_final += linea
		
		fila_actual = fila_actual.get_next()
		
	return texto_final

func _leer_tracker_a_array() -> Array:
	var rows_data = []
	
	# Empezamos desde el primer elemento real (hijo de la raíz invisible)
	var root = tracker_tree.get_root()
	if not root:
		return rows_data
		
	var fila_actual = root.get_first_child()
	
	while fila_actual != null:
		# Obtenemos los textos de cada columna visual
		var txt_p1 = fila_actual.get_text(1).strip_edges()
		var txt_p2 = fila_actual.get_text(2).strip_edges()
		var txt_tri = fila_actual.get_text(3).strip_edges()
		var txt_noi = fila_actual.get_text(4).strip_edges()
		var txt_dpcm = fila_actual.get_text(5).strip_edges()
		
		# Parseamos cada celda usando la misma lógica del motor temporal
		var row_data = {
			"pulse1": motor_temporal._parse_cell(txt_p1),
			"pulse2": motor_temporal._parse_cell(txt_p2),
			"triangle": motor_temporal._parse_cell(txt_tri),
			"noise": motor_temporal._parse_cell(txt_noi),
			"dpcm": motor_temporal._parse_cell(txt_dpcm)
		}
		
		# Validar si toda la fila está vacía (opcional, para optimizar)
		# Por ahora, añadimos la fila tal cual para respetar los silencios
		rows_data.append(row_data)
		
		# Pasamos a la siguiente fila del Tree
		fila_actual = fila_actual.get_next()
		
	return rows_data

func _on_tecla_piano_presionada(nota: String) -> void:
	# 1. Armamos el string completo (ej. "C-4" o "C#4")
	var octava = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/SpB_Octava.value # Ajustar la ruta al SpinBox
	var nota_completa = nota + str(octava)
	
	print("🎹 Tecla presionada: ", nota_completa)
	
	# 2. Verificamos si el modo grabar está activo
	var modo_grabar = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/ChkBtn_Grabar.button_pressed # Ajustar la ruta al CheckButton
	
	#Inicialmente solo se reproducía el audio si no estaba activo el modo grabar, pero, he decidido que se reproduzca aunque se esté grabando, de esta manera podremos escuchar el audio conforme lo voy registrando
	_reproducir_nota_prueba(nota_completa)
	if modo_grabar:
		_registrar_nota_en_tracker(nota_completa)


# --- FUNCIONES DEL TRACKER Y PIANO ---
func _reproducir_nota_prueba(nota_str: String) -> void:
	var nombres_canales = ["pulse1", "pulse2", "triangle", "noise", "dpcm"]
	var fila_nota = {
		"pulse1": {}, "pulse2": {}, "triangle": {}, "noise": {}, "dpcm": {}
	}

	# 1. Si hay una fila seleccionada, LEEMOS TODAS LAS CELDAS ACTUALES de esa fila
	if celda_actual_item != null:
		for col in range(1, 6):
			var txt = celda_actual_item.get_text(col).strip_edges()
			fila_nota[nombres_canales[col - 1]] = motor_temporal._parse_cell(txt)

	# 2. Inyectamos la nota nueva que acabas de presionar
	# Esto asegura que escuches la nota nueva combinada con las que ya estaban escritas
	var guardar_en_toda_fila = chkbtn_guardar_toda_fila.button_pressed if chkbtn_guardar_toda_fila else false

	if guardar_en_toda_fila:
		for canal in nombres_canales:
			fila_nota[canal] = {"note": nota_str}
	else:
		var idx_canal = max(0, celda_actual_columna - 1)
		# Sobrescribimos SOLO el canal actual con la nota que tocaste
		fila_nota[nombres_canales[idx_canal]] = {"note": nota_str}

	# 3. Leer los ajustes reales de tu interfaz para que el sonido sea idéntico al final
	var fps_actual = spnb_fps.value if spnb_fps else 60.0
	var ticks_reales = int(spnb_ticks.value) if spnb_ticks else 6
	var octava_actual = int(spnb_octavabase.value) if spnb_octavabase else 0
	var decays_actuales = [
		spnb_decay_p1.value if spnb_decay_p1 else 0.0,
		spnb_decay_p2.value if spnb_decay_p2 else 0.0,
		spnb_decay_triangle.value if spnb_decay_triangle else 0.0,
		spnb_decay_noise.value if spnb_decay_noise else 0.0,
		spnb_decay_dpcm.value if spnb_decay_dpcm else 0.0
	]

	# 4. TRUCO DE TRACKER: No alteramos la velocidad (ticks).
	# Calculamos cuántas filas vacías (sustain) necesitamos agregar para alcanzar los segundos deseados.
	# Usamos el nuevo SpinBox, o 2.0 segundos si algo falla
	var segundos_prueba = spnb_tiempo_preview.value if spnb_tiempo_preview else 2.0
	var total_frames_deseados = segundos_prueba * fps_actual
	var ticks_totales = int(segundos_prueba * fps_actual)

	var filas_necesarias = int(ceil(total_frames_deseados / float(ticks_reales)))
	if filas_necesarias < 1:
		filas_necesarias = 1
		
	var pattern_falso = [fila_nota]
	
	# Agregamos las filas de silencio para que los canales resuenen y el decay trabaje
	for i in range(filas_necesarias - 1):
		pattern_falso.append({
			"pulse1": {}, "pulse2": {}, "triangle": {}, "noise": {}, "dpcm": {}
		})
		
	# 5. Empaquetar y Hornear la fila completa
	var config_falsa = {
		"pattern": [fila_nota],
		"loop": false,
		#"ticks": ticks_reales,
		"ticks": ticks_totales,
		"fps": fps_actual,
		"octave": octava_actual,
		"decays": decays_actuales
	}

	var stream_wav = motor_temporal._hornear_matematica_a_stream_wav(config_falsa)
	reproductor_preview.stream = stream_wav
	reproductor_preview.play()

	print("🔊 Sonando Fila Completa | Nota nueva: ", nota_str, " | Duración: ", segundos_prueba, "s")


func _registrar_nota_en_tracker(nota_str: String) -> void:
	# 1. Validar que tengamos una celda válida seleccionada (columnas 1 a 5)
	if celda_actual_item == null or celda_actual_columna < 1:
		print("⚠️ Selecciona una celda en los canales (Pulse1, Triangle, etc.) para grabar.")
		return
	
	var guardar_en_toda_fila = chkbtn_guardar_toda_fila.button_pressed if chkbtn_guardar_toda_fila else false
	
	# 2. Asignar el texto a la celda seleccionada en la vista o en la fila completa
	if guardar_en_toda_fila:
		# Llenar las 5 columnas (del índice 1 al 5)
		for col in range(1,6):
			celda_actual_item.set_text(col, nota_str)
		print("✏️ Nota '", nota_str, "' grabada en TODA LA FILA ", celda_actual_item.get_text(0))
	else:
		# Comportamiento normal: solo en la columna seleccionada
		celda_actual_item.set_text(celda_actual_columna, nota_str)
		print("✏️ Nota '", nota_str, "' grabada en columna ", celda_actual_columna)
	
	# 3. Mover la selección automáticamente a la fila de abajo (como en Furnace!)
	var fila_siguiente = celda_actual_item.get_next()
	if fila_siguiente != null:
		tracker_tree.deselect_all() # <--- Limpia las selecciones previas
		# Godot limpia la selección vieja y selecciona la nueva en la misma columna
		fila_siguiente.select(celda_actual_columna)
		# Actualizamos nuestras variables de control
		celda_actual_item = fila_siguiente
		# Aseguramos que la tabla haga scroll hacia abajo si nos pasamos del borde
		tracker_tree.ensure_cursor_is_visible()
		
	

func _on_btn_cortar_nota_pressed() -> void:
	# Verificamos si estamos listos para grabar
	var modo_grabar = $VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/ChkBtn_Grabar.button_pressed
	if modo_grabar and celda_actual_item != null and celda_actual_columna >= 1:
		
		var guardar_en_toda_fila = chkbtn_guardar_toda_fila.button_pressed if chkbtn_guardar_toda_fila else false
		
		if (guardar_en_toda_fila):
			for col in range(1,6):
				celda_actual_item.set_text(col, "OFF")
				print("✂️ Silencio (OFF) insertado en TODA LA FILA.")
		else:
			celda_actual_item.set_text(celda_actual_columna, "OFF")
			print("✂️ Silencio (OFF) insertado.")
	
		
		# Avanzar una fila abajo
		var fila_siguiente = celda_actual_item.get_next()
		if fila_siguiente:
			tracker_tree.deselect_all()
			fila_siguiente.select(celda_actual_columna)
			celda_actual_item = fila_siguiente
			tracker_tree.ensure_cursor_is_visible()
			
	else:
		print("⚠️ Activa 'Grabar' y selecciona una celda para insertar un OFF.")

func _on_tracker_tree_cell_selected() -> void:
	celda_actual_item = tracker_tree.get_selected()
	celda_actual_columna = tracker_tree.get_selected_column()
	
	
	# DEBUG: Para comprobar que funciona
	if celda_actual_item and celda_actual_columna > 0:
		print("Celda seleccionada lista para editar -> Paso: ", celda_actual_item.get_text(0), " | Columna: ", celda_actual_columna)
		lbl_canal.text = celda_actual_item.get_text(0) + "->" +  tracker_tree.get_column_title(celda_actual_columna) + ":" + tracker_tree.get_selected().get_text(celda_actual_columna)

# --- FUNCIONES DE PREVISUALIZACIÓN Y HERRAMIENTAS ---
func _on_play_pressed() -> void:
	var items_seleccionados = lista_partituras.get_selected_items()
	
	if items_seleccionados.size() == 0:
		print("⚠️ Selecciona una partitura de la lista primero.")
		return
		
	var indice = items_seleccionados[0]
	var ruta_archivo = lista_partituras.get_item_metadata(indice)
	var recurso = load(ruta_archivo)
	
	var partitura_val = recurso.get("partitura")
	if not recurso or partitura_val == null or partitura_val == "":
		print("❌ La partitura está vacía o es inválida.")
		return
		
	print("🎵 Horneando previsualización para: ", recurso.get("track_id"), "...")
	
	# 1. Parseamos el texto usando el motor temporal
	var data_parseada = motor_temporal._parse_furnace_text(partitura_val)
	
	# 2. Creamos un diccionario falso que imita lo que pide la función generadora
	var config_falsa = {
		"pattern": data_parseada,
		"loop": recurso.get("es_loop"),
		"ticks": recurso.get("ticks"),
		"fps": recurso.get("fps"),
		"octave": recurso.get("octava"),
		"decays": recurso.get("decays")
	}
	
	# 3. ¡Magia! Horneamos el texto directamente a un archivo de audio WAV en RAM
	var stream_wav = motor_temporal._hornear_matematica_a_stream_wav(config_falsa)
	
	# 4. Se lo pasamos al reproductor del panel y le damos play
	reproductor_preview.stream = stream_wav
	reproductor_preview.play()

func _on_stop_pressed() -> void:
	if reproductor_preview.playing:
		reproductor_preview.stop()
		print("⏹ Reproducción detenida.")

func _on_editar_catalogo_pressed() -> void:
	ChiptuneConfig.asegurar_catalogo()
	var ruta_script = ChiptuneConfig.CATALOG_PATH
	if FileAccess.file_exists(ruta_script):
		var recurso = load(ruta_script)
		
		# Usamos la referencia legítima que nos pasó el plugin
		if editor_plugin_ref:
			var interfaz = editor_plugin_ref.get_editor_interface()
			interfaz.edit_resource(recurso)
			interfaz.set_main_screen_editor("Script")
			print("📝 Abriendo catálogo de IDs...")
		else:
			push_error("⚠️ Error: Referencia al plugin no encontrada. Desactiva y activa el plugin de nuevo.")
	else:
		print("⚠️ El catálogo aún no existe. Crea un archivo .tres primero para que se genere de forma automática.")

# --- APARTADO: EDICIÓN Y CREACIÓN ---
func _on_editar_pressed() -> void:
	var items_seleccionados = lista_partituras.get_selected_items()
	
	if items_seleccionados.size() == 0:
		print("⚠️ Selecciona una partitura de la lista primero para editarla.")
		return
		
	var indice = items_seleccionados[0]
	_on_item_doble_click(indice) # Reutilizamos la lógica que ya teníamos en el doble clic

# --- FUNCIÓN PARA ABRIR Y CARGAR LA PARTITURA EN EL EDITOR VISUAL ---
func _on_item_doble_click(index: int) -> void:
	var ruta_archivo = lista_partituras.get_item_metadata(index)
	
	if FileAccess.file_exists(ruta_archivo):
		var recurso = load(ruta_archivo)
		if not recurso: return
		
		# ---> Fijamos el ancla al archivo cargado
		archivo_en_edicion = ruta_archivo
		print("📌 Archivo anclado para edición: ", archivo_en_edicion)
		# Extraemos el Track ID guardado en el recurso (el valor, ej: "SFX_ejemplo")
		var track_id_asignado = recurso.get("track_id")
		var texto_track_id = str(track_id_asignado) if track_id_asignado != null and str(track_id_asignado) != "" else "Sin asignar"
		var nombre_constante = ""
		
		# Buscamos dinámicamente el nombre de la constante (ej: "Track_Ejemplo") en tu script
		if texto_track_id != "Sin asignar":
			var script_tracks = load(ChiptuneConfig.CATALOG_PATH)
			if script_tracks:
				var mapa_constantes = script_tracks.get_script_constant_map()
				for llave in mapa_constantes.keys():
					if str(mapa_constantes[llave]) == texto_track_id:
						nombre_constante = llave
						break
		
		# Formateamos cómo se verá en el Label
		var texto_display_track = texto_track_id
		if nombre_constante != "":
			texto_display_track = nombre_constante + " (" + texto_track_id + ")"
			
		# Actualizamos el Label visual
		lbl_editando.text = "✏ On Edit: " + archivo_en_edicion.get_file() + " | Track: " + texto_display_track
		
		# 1. Llenamos los parámetros visuales en el Inspector
		_cargar_propiedades_en_ui(recurso)
		
		# 2. Llenamos el Tracker Visual con las notas guardadas
		var partitura_val = recurso.get("partitura")
		if partitura_val != null and partitura_val != "":
			var pattern_cargado = motor_temporal._parse_furnace_text(partitura_val)
			_escribir_array_a_tracker(pattern_cargado)
		else:
			_inicializar_tracker() # Si está vacía, la limpia
		
		if editor_plugin_ref:
			# Extraemos la interfaz y le pedimos a Godot que edite nuestro recurso
			var interfaz = editor_plugin_ref.get_editor_interface()
			interfaz.edit_resource(recurso)
			print("🔍 Pista cargada en el Tracker Visual: ", ruta_archivo)
		else:
			push_error("⚠️ Error: Referencia al plugin no encontrada.")

# --- FUNCIONES AUXILIARES PARA CARGAR AL UI ---
func _cargar_propiedades_en_ui(recurso: Resource) -> void:
	# Seleccionar Track ID en el dropdown
	var track_guardado = recurso.get("track_id")
	if opt_trackid and track_guardado != null:
		for i in range(opt_trackid.item_count):
			if opt_trackid.get_item_text(i) == track_guardado:
				opt_trackid.select(i)
				break
	
	if txt_busdestino: txt_busdestino.text = recurso.get("bus_destino") if recurso.get("bus_destino") else "Master"
	if opt_btntipo:
		var tipo_guardado = recurso.get("tipo_pista")
		if tipo_guardado != null and tipo_guardado >= 0 and tipo_guardado < opt_btntipo.item_count:
			opt_btntipo.select(tipo_guardado)
	if chb_loop: chb_loop.button_pressed = recurso.get("es_loop")
	if spnb_ticks: spnb_ticks.value = recurso.get("ticks")
	if spnb_fps: spnb_fps.value = recurso.get("fps")
	if spnb_octavabase: spnb_octavabase.value = recurso.get("octava")
	
	var decays = recurso.get("decays")
	if decays and decays.size() == 5:
		if spnb_decay_p1: spnb_decay_p1.value = decays[0]
		if spnb_decay_p2: spnb_decay_p2.value = decays[1]
		if spnb_decay_triangle: spnb_decay_triangle.value = decays[2]
		if spnb_decay_noise: spnb_decay_noise.value = decays[3]
		if spnb_decay_dpcm: spnb_decay_dpcm.value = decays[4]

func _escribir_array_a_tracker(pattern_data: Array) -> void:
	tracker_tree.clear()
	var root = tracker_tree.create_item()
	
	# Aseguramos mínimo 1 fila visual para que no se vea vacío
	var total_filas = pattern_data.size()
	if total_filas == 0: 
		total_filas = 1 # Si el track está vacío, garantizamos al menos 1 fila
	
	for i in range(total_filas):
		var fila = tracker_tree.create_item(root)
		fila.set_text(0, str(i).pad_zeros(2))
		fila.set_text_alignment(0, HORIZONTAL_ALIGNMENT_CENTER)
		
		if i < pattern_data.size():
			var row_dict = pattern_data[i]
			fila.set_text(1, row_dict["pulse1"].get("note", "...") if row_dict["pulse1"].has("note") else "...")
			fila.set_text(2, row_dict["pulse2"].get("note", "...") if row_dict["pulse2"].has("note") else "...")
			fila.set_text(3, row_dict["triangle"].get("note", "...") if row_dict["triangle"].has("note") else "...")
			fila.set_text(4, row_dict["noise"].get("note", "...") if row_dict["noise"].has("note") else "...")
			fila.set_text(5, row_dict["dpcm"].get("note", "...") if row_dict["dpcm"].has("note") else "...")
		else:
			for col in range(1, 6):
				fila.set_text(col, "...")
				
		for col in range(1, 6):
			fila.set_text_alignment(col, HORIZONTAL_ALIGNMENT_CENTER)

# --- LÓGICA DE EDICIÓN DEL TRACKER (MENÚ CONTEXTUAL) ---

func _on_tracker_tree_item_mouse_selected(posicion: Vector2, boton_mouse: int) -> void:
	if boton_mouse == MOUSE_BUTTON_RIGHT:
		var item_clickeado = tracker_tree.get_item_at_position(posicion)
		var columna_clickeada = tracker_tree.get_column_at_position(posicion)

		if item_clickeado:
			# Si el item clickeado no estaba seleccionado, lo seleccionamos nosotros
			if not item_clickeado.is_selected(columna_clickeada):
				tracker_tree.deselect_all()
				item_clickeado.select(columna_clickeada)

			celda_actual_item = item_clickeado
			celda_actual_columna = max(1, columna_clickeada)

			# Mostramos el menú contextual exactamente en la posición del mouse en la pantalla
			menu_contextual.position = Vector2i(DisplayServer.mouse_get_position())
			menu_contextual.popup()

func _on_menu_contextual_id_pressed(id: int) -> void:
	match id:
		0: _pedir_cantidad_filas(-1) # Insertar Arriba
		1: _pedir_cantidad_filas(1)  # Insertar Abajo
		2: _eliminar_filas_seleccionadas()
		3: _mutear_fila_completa()

func _pedir_cantidad_filas(offset: int) -> void:
	if not celda_actual_item: return
	
	# Creamos un popup de diálogo al vuelo
	var dialog = ConfirmationDialog.new()
	dialog.title = "Insertar Filas"
	#dialog.dialog_text = "¿Cuántas filas deseas insertar?"
	
	# Creamos un contenedor vertical para ordenar los elementos
	var vbox = VBoxContainer.new()
	
	# Añadimos un label si en dado caso no aparece el dialog_text
	var label_filas = Label.new()
	label_filas.text = "¿Cuántas filas deseas insertar?"
	
	# Añadimos un selector numérico
	var spinbox = SpinBox.new()
	spinbox.min_value = 1
	spinbox.max_value = 500 # Un límite seguro para evitar congelamientos
	spinbox.value = 1
	
	vbox.add_child(label_filas)
	vbox.add_child(spinbox)
	dialog.add_child(vbox)
	
	
	# Conectamos las señales pasando el Spinbox y el Offset como parámetros
	dialog.confirmed.connect(_on_dialogo_insertar_confirmado.bind(spinbox, offset, dialog))
	dialog.canceled.connect(dialog.queue_free)
	
	add_child(dialog)
	dialog.popup_centered(Vector2(300, 100))

func _on_dialogo_insertar_confirmado(spin_node: SpinBox, offset: int, dialog_node: ConfirmationDialog) -> void:
	var cantidad = int(spin_node.value)
	_insertar_filas_multiples(offset, cantidad)
	dialog_node.queue_free()

func _insertar_filas_multiples(offset: int, cantidad: int) -> void:
	if not celda_actual_item: return
	
	var root = tracker_tree.get_root()
	var index_actual = celda_actual_item.get_index()
	
	var nuevo_index = index_actual
	if offset > 0:
		nuevo_index += 1 # Insertamos debajo de la celda actual
		
	# Bucle para insertar la cantidad exacta que pedimos
	for i in range(cantidad):
		# En cada vuelta, el índice de creación se desplaza hacia abajo para mantener el orden
		var nueva_fila = tracker_tree.create_item(root, nuevo_index + i)
		
		# Rellenamos con silencios visuales ("...")
		for col in range(1, 6):
			nueva_fila.set_text(col, "...")
			nueva_fila.set_text_alignment(col, HORIZONTAL_ALIGNMENT_CENTER)
		nueva_fila.set_text_alignment(0, HORIZONTAL_ALIGNMENT_CENTER)
	
	_renumerar_filas()
	print("➕ Se insertaron ", cantidad, " fila(s).")


# Versión inicial de insertar filas, este solo ingresaba de una en una, ahora fue reemplazada por _pedir_cantidad_filas con tal de que sea mucho más práctico poder registrar el audio con más líneas hacia arriba o hacia abajo
func _insertar_fila(offset: int) -> void:
	if not celda_actual_item: return
	
	var root = tracker_tree.get_root()
	var index_actual = celda_actual_item.get_index()
	
	var nuevo_index = index_actual
	if offset > 0:
		nuevo_index += 1 # Insertamos debajo
		
	# Creamos la nueva fila
	var nueva_fila = tracker_tree.create_item(root, nuevo_index)
	
	# Rellenamos con silencios visuales ("...")
	for col in range(1, 6):
		nueva_fila.set_text(col, "...")
		nueva_fila.set_text_alignment(col, HORIZONTAL_ALIGNMENT_CENTER)
	nueva_fila.set_text_alignment(0, HORIZONTAL_ALIGNMENT_CENTER)
	
	_renumerar_filas()
	print("➕ Fila insertada.")

func _eliminar_filas_seleccionadas() -> void:
	var root = tracker_tree.get_root()
	if not root: return
	
	var items_a_eliminar = []
	# Iteramos sobre todos los ítems seleccionados (útil si el usuario usó Shift+Clic, un escenario bastante común como en Excel)
	var item = tracker_tree.get_next_selected(null)
	
	while item != null:
		items_a_eliminar.append(item)
		item = tracker_tree.get_next_selected(item)
		
	# Si por alguna razón la lista falló, aseguramos borrar la celda actual
	if items_a_eliminar.is_empty() and celda_actual_item:
		items_a_eliminar.append(celda_actual_item)
		
	# Validación de seguridad: no dejar el tracker a 0 filas
	if items_a_eliminar.size() == root.get_child_count():
		print("⚠️ No puedes eliminar todas las filas. Debe quedar al menos una.")
		items_a_eliminar.pop_back() # Removemos la última de la lista de eliminación para que sobreviva
		
	# Procedemos a eliminar
	for item_del in items_a_eliminar:
		if celda_actual_item == item_del:
			celda_actual_item = null # Limpiamos la referencia para evitar errores
		item_del.free()
		
	_renumerar_filas()
	print("🗑️ Filas eliminadas.")

func _renumerar_filas() -> void:
	var root = tracker_tree.get_root()
	if not root: return
	
	var item = root.get_first_child()
	var idx = 0
	
	# Recorremos todas las filas de arriba a abajo y re-asignamos el "Paso"
	while item != null:
		item.set_text(0, str(idx).pad_zeros(2))
		item = item.get_next()
		idx += 1

func _mutear_fila_completa() -> void:
	if not celda_actual_item:
		print("⚠️ Selecciona una fila para mutear.")
		return
		
	# Recorremos desde la columna 1 hasta la 5 (Pulse1 hasta DPCM)
	for col in range(1, 6):
		celda_actual_item.set_text(col, "OFF")
		
	print("🔇 Fila ", celda_actual_item.get_text(0), " completamente muteada (OFF).")

func _on_nuevo_pressed() -> void:
	# Creamos un popup de diálogo al vuelo de forma nativa
	var dialog = ConfirmationDialog.new()
	dialog.title = "Nueva Partitura"
	dialog.dialog_text = "Escribe el nombre del nuevo archivo (ej: musica_nivel_1):"
	
	var input = LineEdit.new()
	input.placeholder_text = "nombre_del_track"
	input.text = "8bits_"
	dialog.add_child(input)
	
	# Usamos bind para pasar los nodos al método de confirmación
	dialog.confirmed.connect(_on_dialog_nuevo_confirmado.bind(input, dialog))
	dialog.canceled.connect(dialog.queue_free)
	
	add_child(dialog)
	dialog.popup_centered(Vector2(350, 120))
	#input.grab_focus() # Pone el cursor directamente en la caja de texto

func _on_dialog_nuevo_confirmado(input_node: LineEdit, dialog_node: ConfirmationDialog) -> void:
	var nombre = input_node.text.strip_edges()
	
	if nombre != "":
		_crear_nuevo_recurso(nombre)
		
	dialog_node.queue_free() # Destruimos el diálogo al terminar

func _crear_nuevo_recurso(nombre: String) -> void:
	if not nombre.ends_with(".tres"):
		nombre += ".tres"
		
	# Nos aseguramos de que el directorio base exista
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(ruta_partituras):
		dir.make_dir_recursive(ruta_partituras)
		
	var ruta_completa = ruta_partituras + nombre
	
	if FileAccess.file_exists(ruta_completa):
		push_error("⚠️ Ya existe un archivo con ese nombre.")
		return
		
	# Creamos e instanciamos la partitura
	var nuevo_score = ChiptuneScore.new()
	var err = ResourceSaver.save(nuevo_score, ruta_completa)
	
	if err == OK:
		print("✅ Nueva partitura creada exitosamente en: ", ruta_completa)
		actualizar_lista()
		
		# Seleccionamos y abrimos automáticamente el nuevo archivo recién creado
		for i in range(lista_partituras.item_count):
			if lista_partituras.get_item_metadata(i) == ruta_completa:
				lista_partituras.select(i)
				_on_item_doble_click(i)
				break
	else:
		push_error("❌ Error interno al guardar la partitura en el disco.")

func _on_eliminar_pressed() -> void:
	var items_seleccionados = lista_partituras.get_selected_items()
	
	if items_seleccionados.size() == 0:
		print("⚠️ Selecciona un track para eliminar.")
		return
		
	var indice = items_seleccionados[0]
	var ruta_archivo = lista_partituras.get_item_metadata(indice)
	
	# Crear ventana de confirmación (siempre es bueno prevenir errores, esto es clásico que presione eliminar sin querer y me ha pasado bastante en otros programas que no piden confirmación)
	var confirm_dialog = ConfirmationDialog.new()
	confirm_dialog.title = "Confirmar eliminación"
	confirm_dialog.dialog_text = "¿Estás seguro de eliminar el archivo: " + ruta_archivo.get_file() + "?"
	
	confirm_dialog.confirmed.connect(_ejecutar_eliminacion.bind(ruta_archivo, confirm_dialog))
	confirm_dialog.canceled.connect(confirm_dialog.queue_free)
	
	add_child(confirm_dialog)
	confirm_dialog.popup_centered()

func _ejecutar_eliminacion(ruta: String, dialog: ConfirmationDialog) -> void:
	var dir = DirAccess.open(ruta.get_base_dir())
	if dir:
		var err = dir.remove(ruta.get_file())
		if err == OK:
			print("🗑️ Archivo eliminado: ", ruta)
			actualizar_lista()
		else:
			push_error("❌ Error al eliminar el archivo.")
	dialog.queue_free()

# --- APARTADO: DONACION ---
func _on_donar_pressed() -> void:
	OS.shell_open(urldonacion)

