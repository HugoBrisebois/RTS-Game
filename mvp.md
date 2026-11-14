# RTS Game MVP

## Goal

Deliver a small, playable RTS match in which the player gathers resources, trains
workers, builds defenses, fights an enemy, and reaches a clear win or loss
condition.

## Implemented

- [x] RTS camera movement, panning, zoom, and map bounds
- [x] Click-select and drag-select player units
- [x] Move selected units with right-click
- [x] Start a match with a player castle, two workers, resource nodes, an enemy
  castle, and an enemy unit
- [x] Select a building and show its available menu
- [x] Train workers from the selected castle with a resource cost
- [x] Display gold, wood, and meat totals
- [x] Worker resource gathering, carrying, delivery, and depletion
- [x] Place a defensive barracks with a preview, placement checks, and cost
- [x] Unit attacks, enemy response, health, death, and castle-based win/loss
- [x] Restart, quit, controls help, and action feedback
- [x] Remove the `B` and `E` development spawn shortcuts

## Remaining work

### Playability and release checks

- [ ] Play through a complete match from startup through win and loss.
- [ ] Check in-game that units navigate around terrain and do not get stuck.
- [x] Confirm the exported Linux build starts correctly.
- [ ] Investigate the existing 8-bit music add-on's empty-track runtime error.

## MVP acceptance checklist

- [x] A new match starts with a usable base, workers, and resources.
- [x] The player can select workers, move them, gather resources, and see totals
  change.
- [x] The player can spend resources to train workers and place the barracks.
- [x] The player can command units to fight an enemy.
- [x] The match ends with an understandable win or loss result.
- [x] The complete loop no longer relies on development-only spawn shortcuts.

## Out of scope for the MVP

- Multiplayer
- Campaign or multiple maps
- Multiple factions or an extensive unit roster
- Advanced AI, upgrades, or tech trees
- Save/load support
- Fully polished art, effects, and audio
