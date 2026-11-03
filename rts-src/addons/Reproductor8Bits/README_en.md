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
