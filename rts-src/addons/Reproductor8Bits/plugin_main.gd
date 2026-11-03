@tool
extends EditorPlugin

var panel_instancia: Control

func _enter_tree() -> void:
	# Obtenemos los íconos nativos del tema del editor de Godot (tamaño perfecto 16x16)
	var gui = get_editor_interface().get_base_control()
	var icono_nodo = gui.get_theme_icon("Node", "EditorIcons")
	var icono_audio = gui.get_theme_icon("AudioStreamPlayer", "EditorIcons")
	
	# 1. Registrar Clases personalizadas
	add_custom_type("ChiptunePlayer", "Node", preload("res://addons/Reproductor8Bits/Scripts/chiptune_player.gd"), icono_nodo)
	add_custom_type("SynthChannel", "AudioStreamPlayer", preload("res://addons/Reproductor8Bits/Scripts/synth_channel.gd"), icono_audio)

	# 2. Registrar el Autoload (IMPORTANTE: cargamos el .tscn, no el .gd para que podamos usar de manera visual todas las características de nuestro core)
	add_autoload_singleton("ChiptuneCore", "res://addons/Reproductor8Bits/Escenas/ChiptunePlayer.tscn")
	
	# 3. Instanciar y añadir el Panel de Control al panel inferior del editor, de esta manera no será necesario depurar o ejecutar la escena dentro del juego, lo que simplificará el cambiar de escenas cada vez que se requiera probar tracks, adicionalmente lo manejaremos como si se tratara de la consola de depuración en lugar de un Tab superior después de AssetLib y será menos invasivo el probar tracks cada vez
	panel_instancia = preload("res://addons/Reproductor8Bits/Escenas/ChiptunePanel.tscn").instantiate()
	
	# <-- INYECTAMOS LA REFERENCIA AQUÍ DE FORMA SEGURA -->
	panel_instancia.set("editor_plugin_ref", self)
	
	#Forma inicial de desplegar el control en la parte inferior del editor
	#add_control_to_bottom_panel(panel_instancia, "Chiptune Manager")
	
	
	# Agregamos el panel al área principal del editor
	get_editor_interface().get_editor_main_screen().add_child(panel_instancia)

	# Inicialmente oculto
	panel_instancia.visible = false

	print("✅ Plugin Reproductor 8-Bits (v2.0) cargado con Autoload y Panel.")


func _exit_tree() -> void:
	# Limpieza general al desactivar el plugin
	remove_custom_type("ChiptunePlayer")
	remove_custom_type("SynthChannel")
	
	remove_autoload_singleton("ChiptuneCore")
	
	if is_instance_valid(panel_instancia):
		panel_instancia.queue_free()
		panel_instancia = null
		
		'''
	if panel_instancia:
		#remove_control_from_bottom_panel(panel_instancia)
		panel_instancia.queue_free()
		'''


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if is_instance_valid(panel_instancia):
		panel_instancia.visible = visible


func _get_plugin_name() -> String:
	return "Chiptune Manager"


func _get_plugin_icon() -> Texture2D:
	#return preload("res://icon.svg")
	var gui = get_editor_interface().get_base_control()
	return gui.get_theme_icon("AudioStreamPlayer", "EditorIcons")

# Formato inicial de cómo se registrba inicialmente el catálogo de tracks, ahora que se realiza de manera visual solamente queda como ejemplo de la versión 0.2 mucho antes de considerar volver Chiptune Manager como un plugin
'''
func _registrar_catalogo() -> void:
	# Esta es una ruta de ejemplo, ajustar según donde guardes tus archivos .tres
	var ruta = "res://Partituras/" 
	var dir = DirAccess.open(ruta)
	dir.list_dir_begin()
	var nombre_archivo = dir.get_next()
	
	while nombre_archivo != "":
		if nombre_archivo.ends_with(".tres"):
			var score = load(ruta + nombre_archivo)
			_chiptune_core.register_score(score)
		nombre_archivo = dir.get_next()
	
	_chiptune_core.generar_sonidos()
'''
