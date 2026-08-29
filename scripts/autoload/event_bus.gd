extends Node
## Global signals so UI, companions, and world scripts stay decoupled.

signal dialogue_requested(speaker: String, lines: Array, choices: Array)
signal dialogue_finished(choice_id: String)
signal toast(message: String)
signal pact_formed(companion_id: String)
signal bond_changed(companion_id: String, bond: int, tails: int)
signal combat_started(arena_id: String)
signal combat_ended(victory: bool)
signal location_changed(location_id: String)
signal relationship_changed(character_id: String, stat: String, value: int)
signal player_damaged(amount: int, hp: int, max_hp: int)
signal player_healed(amount: int, hp: int, max_hp: int)
