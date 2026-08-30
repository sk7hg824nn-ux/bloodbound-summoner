# ARCHITECTURE.md

Godot 4.6 / Xogot. Mobile renderer. Autoloads: GameState, Dice, PactSystem, Relationships, EventBus, StoryDB, Campaign, Bricks, SaveSystem.

## Exists
- Player brick (locked). Touch kit. Dodge. Facing.
- Figure2D layered polygons as fallback. FieldPresenter for illustrated frames.
- Camera2DDirector modes + named shots from the TRUE 2.5D board.
- CutsceneDirector (reusable beats, freeze parallax, cam_named).
- LayerStack 7-band Parallax2D (board Z values).
- Dialogue HUD + field chrome (minimap / quest card).
- Multi-slot save.
- PactSystem + Year 1 ring (lie then cut).
- Academy hub: exam cutscene, woods ambush, first ring.
- Prologue runner (cinematic, then academy).

## Missing (structure only)
- Painted plates that match the TRUE 2.5D board
- Six-view production clips for Ash / summons
- Data-driven quests
- Inventory UI / equipment slots
- Race asset library
- NPC memory / factions / shops
- Story Director above CutsceneDirector
- Persistent world beyond one hub

## Conflicts to respect, not paper over
Locked presentation is illustrated 2.5D + Parallax2D. Characters stay layered 2D. Do not introduce MeshInstance heroes.
Locked rule: no empty-hand fight. Ash's "attack" clip is UNDEFINED until canon gives him a weapon that is not a summon.

## Slice that should run today
Boot → create → prologue lines → academy hall exam → week later → woods → Akari → ring.
Player brick must not be rewritten to stand this up.
