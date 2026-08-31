extends Node
## Persistent relationship state for Bloodbound.
## Hidden axes. SaveSystem serializes snapshot() / restore().

const STAT_MIN := -100
const STAT_MAX := 100

const DEFAULT_STATS := {
	"affection": 0,
	"trust": 0,
	"respect": 0,
	"tension": 0,
}

## Starting values for known ids. Unknown ids still get DEFAULT_STATS.
const SEEDS := {
	"mother": {"affection": 40, "trust": 50, "respect": 30, "tension": 0},
	"kitsune": {"affection": 12, "trust": 6, "respect": 8, "tension": 10},
	"akari": {"affection": 12, "trust": 6, "respect": 8, "tension": 10},
	"dragoness": {"affection": 8, "trust": 10, "respect": 14, "tension": 4},
	"bunny": {"affection": 16, "trust": 14, "respect": 7, "tension": 6},
	"best_friend": {"affection": 18, "trust": 16, "respect": 10, "tension": 20},
	"rival": {"affection": 2, "trust": 4, "respect": 12, "tension": 8},
}

const REACTIONS := {
	"kitsune": {
		"compliment": {"affection": 2, "respect": 1, "tension": -1},
		"tease": {"affection": 1, "trust": -1, "tension": 2},
		"gift": {"affection": 3, "trust": 1},
		"train": {"respect": 3, "affection": 1},
		"ignore": {"affection": -2, "tension": 3, "trust": -1},
		"defend": {"trust": 3, "affection": 2},
		"flirt_other": {"tension": 5, "affection": -1},
		"beg_pact": {"respect": -1, "trust": 2, "affection": 2},
	},
	"akari": {
		"compliment": {"affection": 2, "respect": 1, "tension": -1},
		"tease": {"affection": 1, "trust": -1, "tension": 2},
		"train": {"respect": 3, "affection": 1},
		"beg_pact": {"respect": -1, "trust": 2, "affection": 2},
	},
	"dragoness": {
		"compliment": {"affection": 3, "trust": -1},
		"tease": {"affection": 2, "respect": -1},
		"ask_lore": {"respect": 3, "affection": 2, "trust": 1},
		"train": {"respect": 2, "trust": 1},
	},
	"bunny": {
		"compliment": {"affection": 3},
		"spend_time": {"affection": 3, "tension": -2},
		"ignore": {"tension": 6, "affection": -2, "trust": -2},
	},
	"best_friend": {
		"hang_out": {"affection": 2, "tension": -3, "trust": 1},
		"choose_companions": {"tension": 4, "affection": -1},
	},
	"mother": {
		"obey": {"trust": 2, "respect": 1},
		"defy": {"tension": 3, "trust": -1},
		"farewell": {"affection": 2, "trust": 1},
	},
}

var relationships: Dictionary = {}


func _ready() -> void:
	if relationships.is_empty():
		reset()


func reset() -> void:
	relationships.clear()
	for character_id in SEEDS.keys():
		relationships[character_id] = _blank_with(SEEDS[character_id])


func ensure_character(character_id: String) -> void:
	if character_id.is_empty():
		return
	if relationships.has(character_id):
		_fill_missing(relationships[character_id])
		return
	if SEEDS.has(character_id):
		relationships[character_id] = _blank_with(SEEDS[character_id])
	else:
		relationships[character_id] = DEFAULT_STATS.duplicate()


func has_character(character_id: String) -> bool:
	return relationships.has(character_id)


func value(character_id: String, stat: String) -> int:
	return get_stat(character_id, stat)


func get_stat(character_id: String, stat: String) -> int:
	ensure_character(character_id)
	if not DEFAULT_STATS.has(stat):
		return 0
	return int(relationships[character_id].get(stat, 0))


func set_value(character_id: String, stat: String, amount: int) -> int:
	ensure_character(character_id)
	if not DEFAULT_STATS.has(stat):
		return 0
	var next: int = clampi(amount, STAT_MIN, STAT_MAX)
	relationships[character_id][stat] = next
	_emit_changed(character_id, stat, next)
	return next


func change(character_id: String, stat: String, amount: int) -> int:
	return set_value(character_id, stat, get_stat(character_id, stat) + amount)


func _add(character_id: String, stat: String, amount: int) -> int:
	return change(character_id, stat, amount)


func apply_action(character_id: String, action: String) -> Dictionary:
	ensure_character(character_id)
	var table: Dictionary = REACTIONS.get(character_id, {})
	if table.is_empty() and character_id == "akari":
		table = REACTIONS.get("kitsune", {})
	var delta: Dictionary = table.get(action, {})
	var applied := {}
	for stat in delta.keys():
		change(character_id, str(stat), int(delta[stat]))
		applied[stat] = int(delta[stat])
	return applied


func affection(character_id: String) -> int:
	return get_stat(character_id, "affection")


func trust(character_id: String) -> int:
	return get_stat(character_id, "trust")


func respect(character_id: String) -> int:
	return get_stat(character_id, "respect")


func tension(character_id: String) -> int:
	return get_stat(character_id, "tension")


func snapshot() -> Dictionary:
	return relationships.duplicate(true)


func restore(snapshot_data: Dictionary) -> void:
	relationships.clear()
	if snapshot_data.is_empty():
		reset()
		return
	for character_id in snapshot_data.keys():
		var raw: Variant = snapshot_data[character_id]
		if typeof(raw) != TYPE_DICTIONARY:
			continue
		relationships[str(character_id)] = _blank_with(raw as Dictionary)


func relationship_state(character_id: String) -> String:
	return mood_label(character_id)


func mood_label(character_id: String) -> String:
	var trust_score: int = trust(character_id)
	var affection_score: int = affection(character_id)
	var tension_score: int = tension(character_id)
	if tension_score >= 60:
		return "hostile"
	if trust_score >= 60 and affection_score >= 60:
		return "devoted"
	if trust_score >= 40:
		return "trusted"
	if affection_score >= 40:
		return "close"
	if trust_score <= -40:
		return "distrustful"
	if tension_score >= 40:
		return "tense"
	return "neutral"


func kitsune_line_for_mood() -> String:
	var mood := mood_label("kitsune")
	match mood:
		"distrustful", "hostile":
			return "Don't get the wrong idea. This pact is... temporary."
		"close", "trusted":
			return "Hmph. You're less hopeless than you look."
		"devoted":
			return "...I would answer you again. Even if you didn't beg."
		"tense":
			return "Those other two can wait. Look at me when I'm talking."
		_:
			return "Tch. Keep up, summoner."


func _blank_with(raw: Dictionary) -> Dictionary:
	var stats: Dictionary = DEFAULT_STATS.duplicate()
	for stat in stats.keys():
		stats[stat] = clampi(int(raw.get(stat, stats[stat])), STAT_MIN, STAT_MAX)
	return stats


func _fill_missing(stats: Dictionary) -> void:
	for stat in DEFAULT_STATS.keys():
		if not stats.has(stat):
			stats[stat] = DEFAULT_STATS[stat]


func _emit_changed(character_id: String, stat: String, next: int) -> void:
	var bus := get_node_or_null("/root/EventBus")
	if bus != null:
		bus.relationship_changed.emit(character_id, stat, next)
