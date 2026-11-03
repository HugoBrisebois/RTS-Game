@tool
class_name ChiptuneConfig
extends RefCounted

# Cambiar esta rutas aquí y variables fijas y se actualizará en todo el plugin.
const MOTOR_PATH: String = "res://addons/Reproductor8Bits/Scripts/chiptune_player.gd"
const CATALOG_PATH: String = "res://ChiptuneTracks.gd"
const PARTITURAS_PATH: String = "res://Partituras/"
const Donacion_PayPal: String = "https://www.paypal.com/donate/?hosted_button_id=RCPSRAX4R5EVJ"

# Función global para garantizar que el archivo exista
static func asegurar_catalogo() -> void:
	if not FileAccess.file_exists(CATALOG_PATH):
		var archivo = FileAccess.open(CATALOG_PATH, FileAccess.WRITE)
		if archivo:
			var plantilla = """class_name ChiptuneTracks

# Catálogo generado automáticamente por ChiptunePlayer.
# Añade tus propias constantes aquí para que aparezcan en el Inspector de las partituras.

const Track_Ejemplo = "SFX_ejemplo"
const Track_Menu = "BGM_musica_menu"
const Track_Salto = "SFX_salto"
"""
			archivo.store_string(plantilla)
			archivo.close()
			print("✨ Catálogo ChiptuneTracks.gd creado automáticamente en: ", CATALOG_PATH)
