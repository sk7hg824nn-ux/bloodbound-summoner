extends Node
## Persistent run state. The player and the protagonist learn the truth together.

enum Sex { MALE, FEMALE }

const STARTING_STATS := {
	"str": 10,
	"dex": 12,
	"con": 11,
	"int": 13,
	"wis": 11,
	"cha": 14,
}

var player_name: String = "Ash"
var player_sex: Sex = Sex.MALE
var level: int = 1
var xp: int = 0
var xp_to_next: int = 100
var stats: Dictionary = STARTING_STATS.duplicate()
var hp: int = 24
var max_hp: int = 24
var location: String = "courtyard"
var day: int = 1
var time_block: String = "morning"
var flags: Dictionary = {}
var inventory: Array[String] = ["Academy Uniform", "Empty Summoning Focus"]
var in_dialogue: bool = false
var in_combat: bool = false


func _ready() -> void:
	reset_combat_vitals()


func reset_run() -> void:
	player_name = "Ash"
	player_sex = Sex.MALE
	level = 1
	xp = 0
	xp_to_next = 100
	stats = STARTING_STATS.duplicate()
	flags.clear()
	inventory = ["Academy Uniform", "Empty Summoning Focus"]
	location = "courtyard"
	day = 1
	time_block = "morning"
	reset_combat_vitals()


func reset_combat_vitals() -> void:
	max_hp = 16 + stats.get("con", 10) + (level - 1) * 4
	hp = max_hp


func set_identity(new_name: String, sex: Sex) -> void:
	player_name = new_name.strip_edges()
	if player_name.is_empty():
		player_name = "Ash"
	player_sex = sex
	if not flags.get("identity_set", false):
		flags["identity_set"] = true


func pronoun_they() -> String:
	return "he" if player_sex == Sex.MALE else "she"


func pronoun_them() -> String:
	return "him" if player_sex == Sex.MALE else "her"


func pronoun_their() -> String:
	return "his" if player_sex == Sex.MALE else "her"


func ability(stat_key: String) -> int:
	return int(stats.get(stat_key, 10))


func take_damage(amount: int) -> void:
	hp = max(0, hp - amount)
	EventBus.player_damaged.emit(amount, hp, max_hp)
	if hp <= 0:
		hp = 1
		EventBus.toast.emit("You drop to one knee... but the pact holds you up.")


func heal(amount: int) -> void:
	var before := hp
	hp = min(max_hp, hp + amount)
	EventBus.player_healed.emit(hp - before, hp, max_hp)


func add_xp(amount: int) -> void:
	xp += amount
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = int(xp_to_next * 1.35)
		max_hp += 4
		hp = max_hp
		EventBus.toast.emit("Level %d. The bloodline stirs." % level)


func set_flag(key: String, value: Variant = true) -> void:
	flags[key] = value


func has_flag(key: String) -> bool:
	return bool(flags.get(key, false))


func change_location(id: String) -> void:
	location = id
	EventBus.location_changed.emit(id)
