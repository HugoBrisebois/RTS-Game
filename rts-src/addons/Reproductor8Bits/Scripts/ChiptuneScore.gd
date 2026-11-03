@tool
extends Resource
class_name ChiptuneScore

## Título descriptivo para identificar la partitura en tu gestor
var track_id: String = ""

## Pega aquí el formato de texto plano tipo Furnace
@export_multiline var partitura: String = ""

## Configuración específica de la pista
@export var es_loop: bool = false
@export var ticks: int = 6
@export var fps: float = 60.0
@export var octava: int = 1

## Los valores de Decay para [Pulse1, Pulse2, Triangle, Noise, DPCM]
@export var decays: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0]

## Bus de audio destino
@export var bus_destino: String = "SFX"

## Tipo de pista para el motor de audio
@export var tipo_pista: ChiptunePlayer.TrackType = ChiptunePlayer.TrackType.SFX

# Esta función es llamada por Godot cada vez que haces clic en el archivo .tres
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var opciones_dropdown = "Escribe_ID_Manual" 
	
	ChiptuneConfig.asegurar_catalogo()
	var ruta_script = ChiptuneConfig.CATALOG_PATH

	if FileAccess.file_exists(ruta_script):
		var file = FileAccess.open(ruta_script, FileAccess.READ)
		if file:
			var texto = file.get_as_text()
			file.close()

			var regex = RegEx.new()
			regex.compile('const\\s+\\w+\\s*(?::\\s*\\w+)?\\s*=\\s*["\']([^"\']+)["\']')
			var resultados = regex.search_all(texto)

			if resultados.size() > 0:
				var lista_valores = []
				for res in resultados:
					lista_valores.append(res.get_string(1)) 
				opciones_dropdown = ",".join(lista_valores)

	properties.append({
		"name": "track_id",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT, 
		"hint": PROPERTY_HINT_ENUM, 
		"hint_string": opciones_dropdown 
	})

	return properties
