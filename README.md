# RTS-Game

A small real-time strategy game built with Godot 4 using the Tiny Swords asset
pack by Pixel Frog.

## Current playable prototype

The match starts with a player castle, two workers, resource nodes, an enemy
castle, and an enemy barracks. The enemy earns resources over time and sends
capped warrior raids from its barracks; the barracks also attacks nearby
opponents. Gather resources, train workers, build defenses, and destroy the
enemy castle to win. Losing the player castle ends the match in defeat.

## Controls

- **Left-click** a unit or building to select it.
- **Left-click and drag** to select multiple units.
- **Right-click** open ground to move selected units.
- **Right-click** a resource node with selected workers to gather and return
  resources.
- **Right-click** an enemy unit or building with selected units to attack.
- Use the **Gather** and **Attack** buttons to show command prompts for the
  selected units.
- Select your castle and press **Train Worker** to train a worker (50 gold, 25
  wood, 10 food).
- Select a player barracks and press **Train Warrior** to train a warrior
  (100 gold, 50 wood, 20 food).
- Select a unit, choose **Build Barracks**, then left-click a clear walkable
  location to place it (25 gold, 80 wood). Right-click or press **Esc** to
  cancel placement. Barracks automatically attack nearby enemies.
- Use **Place Gold**, **Place Wood**, or **Place Food** at the top-left to add
  500-unit resource deposits anywhere on clear walkable ground. Left-click to
  place more deposits; right-click or **Esc** ends placement. This map-making
  tool does not spend resources.
- **WASD** or screen-edge scrolling moves the camera; middle-mouse drag pans;
  the mouse wheel zooms.
- Use **Restart** or **Quit** in the top-right corner.

Workers gather 5 resources per trip, up to 10 at a time, and automatically
return to the castle to deposit gold, wood, or food. Deposits are finite and
disappear when exhausted. The HUD shows all three resource totals. The match
starts with 150 gold, 250 wood, and 100 food. In addition to the starter
deposits near your castle, 64 more are distributed across walkable areas of the
map, with closer spacing and larger reserves. Adjust **Additional Resource
Deposits** on the main scene's game-state node to change that number.

## Project

Open `rts-src/project.godot` with Godot 4.7 or newer. The configured main scene
is `rts-src/scenes/rts-play.tscn`.
