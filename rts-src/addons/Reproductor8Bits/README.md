------------------------------------------------------------------------------------------------

# ChiptunePlayer English
An 8-Bit Chiptune Player for Godot 4 🎵👾
An advanced, native plugin for Godot 4 that lets you play 8-bit style music and sound effects using procedural synthesis, without relying on large `.wav` or `.ogg` files or external tools.
Convert tracker-style sheet music (Tracker/Furnace format) into audio in real time or pre-bake it into memory for optimal performance.

## ✨ Key Features

-> 100% Native Godot: Built entirely in GDScript. No DLLs or external compilation required.
-> Built-in Manager (Editor Tool): Includes an editor panel to create, manage, and preview your tracks without running the game.
-> Classic Sound Channels: Supports Pulse (1 & 2), Triangle, Noise, and DPCM channels, emulating the capabilities of classic retro consoles.
-> Smart Mobile/Web Cache: Automatically detects the target platform and pre-bakes audio for browsers and mobile devices, where pure procedural synthesis may not be available, ensuring full cross-platform compatibility.
-> Error-Proof Workflow (QoL): Create song IDs once, and the plugin automatically generates Inspector drop-down menus to eliminate typos and simplify development.

## 🚀 Installation

-> Download the plugin from the Godot Asset Library or the Releases section of this repository.
-> Extract the `addons/Reproductor8Bits` folder into your project's `addons/` directory.
-> Go to Project → Project Settings → Plugins and enable "Chiptune Player 8-Bits" or "ChiptuneCore".
-> The Chiptune Manager panel will appear at the bottom of the Godot editor.

## 📖 Basic Usage (Quick Start)
-> Open the Chiptune Manager tab at the bottom of the editor.
-> Click "New Track" to create your first score.
-> Double-click the new track in the list to open it in the Inspector.
-> Paste your sheet music into the Score field and configure its tempo (FPS, Ticks).
-> Play your music or sound effects from code using the Autoload:

# Play a sound effect or background music
ChiptuneCore.play_sound(ChiptuneTracks.MyNewSong)

# Stop playback
ChiptuneCore.stop()

## 🤝 Credits & Acknowledgments
This chiptune synthesis plugin was developed with the spirit of open source in mind. While any music you create with this engine is entirely yours and may be used however you wish, **it is highly recommended that you credit Kx Studios in your game's credits.**
Their contributions to the open-source audio ecosystem, along with tools such as Furnace, have been a tremendous source of technical inspiration for this project.

## 💖 Support
If this plugin has saved you time, reduced your project size, or helped you during a Game Jam, please consider supporting its continued development.

PayPal Donation: https://www.paypal.com/donate/?hosted_button_id=RCPSRAX4R5EVJ

## 📜 License
This project is licensed under the MIT License.
Feel free to use it in both commercial and non-commercial games!

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
