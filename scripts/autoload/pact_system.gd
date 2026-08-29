extends Node
const COMPANIONS := {
	"kitsune": {"display_name": "Akari", "color": Color(0.91, 0.48, 0.22)},
	"dragoness": {"display_name": "Sera", "color": Color(0.22, 0.62, 0.48)},
	"bunny": {"display_name": "Mimi", "color": Color(0.86, 0.42, 0.58)},
}
var bonds := {"kitsune": 0, "dragoness": 0, "bunny": 0}
var pacted := {"kitsune": false, "dragoness": false, "bunny": false}
func is_pacted(id: String) -> bool:
	return bool(pacted.get(id, false))
func active_ids() -> Array[String]:
	var out: Array[String] = []
	for id in pacted.keys():
		if pacted[id]:
			out.append(id)
	return out
func bond_of(id: String) -> int:
	return int(bonds.get(id, 0))
func tails_for(id: String) -> int:
	if id != "kitsune":
		return 0
	return 1 if pacted.get(id, false) else 1
