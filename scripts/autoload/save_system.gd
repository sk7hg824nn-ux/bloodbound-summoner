extends Node
## user://bloodbound_save.json  schema v1
const PATH := "user://bloodbound_save.json"
const VERSION := 1

func _ready() -> void:
	EventBus.pact_formed.connect(func(_id): write())
	EventBus.combat_ended.connect(func(_w): write())

func has_save() -> bool:
	return FileAccess.file_exists(PATH)

func write() -> void:
	var blob := {
		"v": VERSION,
		"player_name": GameState.player_name,
		"player_sex": int(GameState.player_sex),
		"era": GameState.era,
		"location": GameState.location,
		"hp": GameState.hp,
		"max_hp": GameState.max_hp,
		"flags": GameState.flags.duplicate(true),
		"inventory": GameState.inventory.duplicate(),
		"pacted": PactSystem.pacted.duplicate(true),
		"bonds": PactSystem.bonds.duplicate(true),
		"tails": PactSystem.tails.duplicate(true),
		"chapter_id": Campaign.chapter_id,
		"objective": Campaign.objective,
	}
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify(blob))

func load_save() -> bool:
	if not has_save():
		return false
	var f := FileAccess.open(PATH, FileAccess.READ)
	if f == null:
		return false
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var blob: Dictionary = parsed
	GameState.player_name = str(blob.get("player_name", "Ash"))
	GameState.player_sex = blob.get("player_sex", 0) as GameState.Sex
	GameState.era = str(blob.get("era", "academy"))
	GameState.location = str(blob.get("location", "hall"))
	GameState.hp = int(blob.get("hp", GameState.hp))
	GameState.max_hp = int(blob.get("max_hp", GameState.max_hp))
	GameState.flags = blob.get("flags", {}) as Dictionary
	var inv: Variant = blob.get("inventory", [])
	GameState.inventory.clear()
	for item in inv:
		GameState.inventory.append(str(item))
	PactSystem.pacted = blob.get("pacted", PactSystem.pacted) as Dictionary
	PactSystem.bonds = blob.get("bonds", PactSystem.bonds) as Dictionary
	PactSystem.tails = blob.get("tails", PactSystem.tails) as Dictionary
	Campaign.chapter_id = str(blob.get("chapter_id", Campaign.chapter_id))
	Campaign.objective = str(blob.get("objective", Campaign.objective))
	return true

func clear() -> void:
	if has_save():
		DirAccess.remove_absolute(PATH)

func continue_scene() -> String:
	if GameState.has_flag("prologue_done") or GameState.era == "academy":
		return "res://scenes/world/Academy.tscn"
	return "res://scenes/world/Prologue.tscn"
