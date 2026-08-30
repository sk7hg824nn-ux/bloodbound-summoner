extends Node
## Slots 0..2 at user://bloodbound_slot_N.json  schema v1
const VERSION := 1
const SLOT_COUNT := 3
const LEGACY := "user://bloodbound_save.json"
const INDEX := "user://bloodbound_index.json"

var current_slot: int = 0

func _ready() -> void:
	_migrate_legacy()
	current_slot = _read_index()
	EventBus.pact_formed.connect(func(_id): write())
	EventBus.combat_ended.connect(func(_w): write())

func slot_path(slot: int) -> String:
	return "user://bloodbound_slot_%d.json" % slot

func has_slot(slot: int) -> bool:
	return FileAccess.file_exists(slot_path(slot))

func has_save() -> bool:
	for i in SLOT_COUNT:
		if has_slot(i):
			return true
	return false

func peek(slot: int) -> Dictionary:
	if not has_slot(slot):
		return {}
	var f := FileAccess.open(slot_path(slot), FileAccess.READ)
	if f == null:
		return {}
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed as Dictionary

func write() -> void:
	var blob := {
		"v": VERSION,
		"slot": current_slot,
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
	var f := FileAccess.open(slot_path(current_slot), FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify(blob))
	_write_index(current_slot)

func load_slot(slot: int) -> bool:
	if slot < 0 or slot >= SLOT_COUNT:
		return false
	if not has_slot(slot):
		return false
	current_slot = slot
	_write_index(slot)
	return _apply(peek(slot))

func load_save() -> bool:
	return load_slot(current_slot) or load_slot(_first_used())

func clear() -> void:
	clear_slot(current_slot)

func clear_slot(slot: int) -> void:
	var p := slot_path(slot)
	if FileAccess.file_exists(p):
		DirAccess.remove_absolute(p)

func continue_scene() -> String:
	if GameState.has_flag("prologue_done") or GameState.era == "academy":
		return "res://scenes/world/Academy.tscn"
	return "res://scenes/world/Prologue.tscn"

func _apply(blob: Dictionary) -> bool:
	if blob.is_empty():
		return false
	GameState.player_name = str(blob.get("player_name", "Ash"))
	GameState.player_sex = blob.get("player_sex", 0) as GameState.Sex
	GameState.era = str(blob.get("era", "academy"))
	GameState.location = str(blob.get("location", "hall"))
	GameState.hp = int(blob.get("hp", GameState.hp))
	GameState.max_hp = int(blob.get("max_hp", GameState.max_hp))
	GameState.flags = blob.get("flags", {}) as Dictionary
	GameState.inventory.clear()
	for item in blob.get("inventory", []):
		GameState.inventory.append(str(item))
	PactSystem.pacted = blob.get("pacted", PactSystem.pacted) as Dictionary
	PactSystem.bonds = blob.get("bonds", PactSystem.bonds) as Dictionary
	PactSystem.tails = blob.get("tails", PactSystem.tails) as Dictionary
	Campaign.chapter_id = str(blob.get("chapter_id", Campaign.chapter_id))
	Campaign.objective = str(blob.get("objective", Campaign.objective))
	return true

func _first_used() -> int:
	for i in SLOT_COUNT:
		if has_slot(i):
			return i
	return 0

func _migrate_legacy() -> void:
	if not FileAccess.file_exists(LEGACY):
		return
	if has_slot(0):
		return
	var src := FileAccess.open(LEGACY, FileAccess.READ)
	var dst := FileAccess.open(slot_path(0), FileAccess.WRITE)
	if src and dst:
		dst.store_string(src.get_as_text())

func _read_index() -> int:
	if not FileAccess.file_exists(INDEX):
		return 0
	var f := FileAccess.open(INDEX, FileAccess.READ)
	if f == null:
		return 0
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return 0
	return clampi(int((parsed as Dictionary).get("last", 0)), 0, SLOT_COUNT - 1)

func _write_index(slot: int) -> void:
	var f := FileAccess.open(INDEX, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"v": VERSION, "last": slot}))
