extends Node

const COMPANIONS := {
	"kitsune": {"display_name": "Akari", "color": Color(0.91, 0.48, 0.22), "rank": "E"},
	"dragoness": {"display_name": "Lithanya", "color": Color(0.22, 0.62, 0.48), "rank": "E"},
	"bunny": {"display_name": "Breana", "color": Color(0.86, 0.42, 0.58), "rank": "E"},
}

var bonds := {"kitsune": 0, "dragoness": 0, "bunny": 0}
var pacted := {"kitsune": false, "dragoness": false, "bunny": false}
var tails := {"kitsune": 0}

func reset() -> void:
	bonds = {"kitsune": 0, "dragoness": 0, "bunny": 0}
	pacted = {"kitsune": false, "dragoness": false, "bunny": false}
	tails = {"kitsune": 0}

func is_pacted(id: String) -> bool:
	return bool(pacted.get(id, false))

func has_any() -> bool:
	return is_pacted("kitsune")

func seal_akari() -> void:
	pacted["kitsune"] = true
	tails["kitsune"] = 1
	bonds["kitsune"] = max(bond_of("kitsune"), 1)
	EventBus.pact_formed.emit("kitsune")
	EventBus.bond_changed.emit("kitsune", bond_of("kitsune"), tails_for("kitsune"))

func bond_of(id: String) -> int:
	return int(bonds.get(id, 0))

func tails_for(id: String) -> int:
	if id != "kitsune" or not is_pacted("kitsune"):
		return 0
	return max(1, int(tails.get("kitsune", 1)))
