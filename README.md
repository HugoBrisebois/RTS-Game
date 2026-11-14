# RTS-Game

A small real-time strategy game built with Godot 4 using the Tiny Swords asset
pack by Pixel Frog.

## Current playable prototype

The match starts with a player castle, two workers, resource nodes, an enemy
castle, and an enemy unit. Gather resources, train workers, build a defensive
barracks, and destroy the enemy castle to win. Losing the player castle ends the
match in defeat.

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
  wood).
- Select a unit, choose **Build Barracks**, then left-click a clear walkable
  location to place it (25 gold, 80 wood). Right-click or press **Esc** to
  cancel placement. Barracks automatically attack nearby enemies.
- **WASD** or screen-edge scrolling moves the camera; middle-mouse drag pans;
  the mouse wheel zooms.
- Use **Restart** or **Quit** in the top-right corner.

Workers gather 5 resources per trip, up to 10 at a time, and automatically
return to the castle to deposit them. Gold and wood totals are shown in the HUD.

## Project

Open `rts-src/project.godot` with Godot 4.7 or newer. The configured main scene
is `rts-src/scenes/rts-play.tscn`.
