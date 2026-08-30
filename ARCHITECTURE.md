# ARCHITECTURE.md

Godot 4.6 / Xogot. Mobile renderer. Autoloads: GameState, Dice, PactSystem, Relationships, EventBus, StoryDB, Campaign, Bricks.

## Exists
- Player brick (locked). Touch kit. Dodge. Facing.
- Figure2D layered polygons. Academy silhouette for Ash.
- Camera2DDirector modes + bounds.
- CutsceneDirector (reusable beats, freeze parallax).
- LayerStack Parallax2D.
- Dialogue HUD + EventBus.
- PactSystem + Year 1 ring (lie then cut).
- Academy hub: exam cutscene, woods ambush, first ring.
- Prologue runner (black, then academy).

## Missing (structure only)
- Save/load migration
- Data-driven quests
- Inventory UI / equipment slots
- Race asset library
- NPC memory / factions / shops
- Story Director above CutsceneDirector
- Persistent world beyond one hub

## Conflicts to respect, not paper over
This directive asked for 3D environments. Locked presentation is illustrated 2.5D + Parallax2D. Characters stay layered 2D. Do not introduce MeshInstance heroes.
This directive listed player combat animations. Locked rule: no empty-hand fight. Ash's "attack" clip is UNDEFINED until canon gives him a weapon that is not a summon.

## Slice that should run today
Boot → create → prologue lines → academy hall exam → week later → woods → Akari → ring.
Player brick must not be rewritten to stand this up.
