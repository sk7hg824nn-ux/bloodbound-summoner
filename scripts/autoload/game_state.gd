extends Node

enum Sex { MALE, FEMALE }

const STARTING_STATS := {"str": 10, "dex": 12, "con": 11, "int": 13, "wis": 11, "cha": 14}

var player_name: String = "Ash"
var player_sex: Sex = Sex.MALE
var level: int = 1
var xp: int = 0
var xp_to_next: int = 100
var stats: Dictionary = STARTING_STATS.duplicate()
var hp: int = 24
var max_hp: int = 24
var era: String = "child"
var location: String = "home"
var day: int = 1
var time_block: String = "morning"
var flags: Dictionary = {}
var inventory: Array[String] = ["Home Clothes"]
var in_dialogue: bool = false
var in_combat: bool = false

func reset_run() -> void:
	player_name = "Ash"
	player_sex = Sex.MALE
	level = 1
	xp = 0
	xp_to_next = 100
	stats = STARTING_STATS.duplicate()
	flags.clear()
	era = "child"
	inventory = ["Home Clothes"]
	location = "home"
	day = 1
	time_block = "morning"
	reset_combat_vitals()

func reset_combat_vitals() -> void:
	max_hp = 16 + int(stats.get("con", 10)) + (level - 1) * 4
	hp = max_hp

func set_identity(new_name: String, sex: Sex) -> void:
	player_name = new_name.strip_edges()
	if player_name.is_empty():
		player_name = "Ash"
	player_sex = sex
	flags["identity_set"] = true

func ability(stat_key: String) -> int:
	return int(stats.get(stat_key, 10))

func take_damage(amount: int) -> void:
	hp = max(0, hp - amount)
	EventBus.player_damaged.emit(amount, hp, max_hp)

func heal(amount: int) -> void:
	var before := hp
	hp = min(max_hp, hp + amount)
	EventBus.player_healed.emit(hp - before, hp, max_hp)

func set_flag(key: String, value: Variant = true) -> void:
	flags[key] = value

func has_flag(key: String) -> bool:
	return bool(flags.get(key, false))

func change_location(id: String) -> void:
	location = id
	EventBus.location_changed.emit(id)
