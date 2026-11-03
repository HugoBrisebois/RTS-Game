------------------------------------------------------------------------------------------------

# ChiptunePlayer Español
Chiptune Player 8-Bits para Godot 4 🎵👾
Un plugin avanzado y nativo para Godot 4 que te permite reproducir música estilo 8-bits y efectos de sonido utilizando síntesis procedural, sin necesidad de usar pesados archivos .wav o .ogg ni herramientas externas.
Convierte texto de partituras (estilo Tracker/Furnace) en audio en tiempo real o rebosado (baked) a memoria.

✨ Características Principales
-> 100% Nativo de Godot: Creado enteramente en GDScript. No requiere librerías DLL ni compilación externa.
-> Manager Integrado (Editor Tool): Incluye un panel en el editor para crear, gestionar y previsualizar tus partituras sin iniciar el juego.
-> Canales Clásicos: Soporte para Pulse (1 y 2), Triangle, Noise y DPCM, emulando las capacidades de las consolas retro.
-> Caché Inteligente Móvil/Web: Detecta la plataforma y "hornea" el audio automáticamente para navegadores o móviles donde la síntesis procedural pura no está disponible, garantizando 100% de compatibilidad cross-platform.
-> Flujo de Trabajo Blindado (QoL): Crea tus ID de canciones, y el plugin genera automáticamente menús desplegables en el Inspector para evitar errores tipográficos.

🚀 Instalación
-> Descarga el plugin desde la Asset Library o desde los Releases de este repositorio.
-> Extrae la carpeta addons/Reproductor8Bits dentro del directorio addons/ de tu proyecto.
-> Ve a Proyecto -> Configuración del proyecto -> Plugins y activa "Chiptune Player 8-Bits" o "ChiptuneCore".
-> ¡El panel "Chiptune Manager" aparecerá en la parte inferior de tu editor!

📖 Uso Básico (Inicio Rápido)
-> Abre la pestaña Chiptune Manager en la parte inferior del editor.
-> Haz clic en "Nuevo Track" para crear tu primera partitura.
-> Haz doble clic en el nuevo track en la lista para abrirlo en el Inspector.
-> Pega el texto de tu partitura en el campo Partitura y ajusta su tempo (FPS, Ticks).
-> En código, llama a tu audio fácilmente usando el Autoload:

# Reproduce un efecto de sonido o música de fondo
ChiptuneCore.play_sound(ChiptuneTracks.MiNuevaCancion)

# Detiene el reproductor
ChiptuneCore.stop()

## 🤝 Créditos y Reconocimientos
Este plugin de síntesis chiptune fue desarrollado siguiendo la filosofía de código abierto. Si decides utilizar este motor en tus proyectos, aunque la música que crees con él es enteramente tuya y puedes usarla como desees, **se recomienda encarecidamente incluir créditos a Kx Studios** en los créditos de tu juego. 

Su trabajo en el ecosistema de audio de código abierto y herramientas como Furnace ha sido una fuente inmensa de inspiración técnica para este proyecto.

💖 Soporte
* Si este plugin te ahorró tiempo, espacio en disco o te ayudó en tu Game Jam, considera apoyar el desarrollo continuo:
Donación PayPal: https://www.paypal.com/donate/?hosted_button_id=RCPSRAX4R5EVJ

📜 Licencia
Este proyecto está bajo la Licencia MIT. ¡Úsalo libremente en tus juegos comerciales o gratuitos!

------------------------------------------------------------------------------------------------
