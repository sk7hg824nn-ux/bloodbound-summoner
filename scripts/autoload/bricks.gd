extends Node
## Lego order. Each brick snaps onto the last.

signal brick_unlocked(id: String)

const ORDER := ["player","combat","kitsune","pact","bond","academy","dialogue","tournament","dragoness","bunny","world","bosses","endgame"]

const TITLE := {
	"player": "Player", "combat": "Combat", "kitsune": "Kitsune", "pact": "Pact",
	"bond": "Bond", "academy": "Academy", "dialogue": "Dialogue", "tournament": "Tournament",
	"dragoness": "Dragoness", "bunny": "Bunny", "world": "World", "bosses": "Bosses", "endgame": "Endgame",
}

var unlocked: Dictionary = {}

func _ready() -> void:
	reset()

func reset() -> void:
	unlocked.clear()
	for id in ["player", "combat", "academy", "dialogue"]:
		unlocked[id] = true

func is_on(id: String) -> bool:
	return bool(unlocked.get(id, false))

func unlock(id: String) -> void:
	if unlocked.get(id, false):
		return
	unlocked[id] = true
	brick_unlocked.emit(id)
	EventBus.toast.emit("Brick: %s" % TITLE.get(id, id))

func sync_from_state() -> void:
	if GameState.has_flag("met_kitsune") or PactSystem.is_pacted("kitsune"):
		unlock("kitsune")
	if PactSystem.is_pacted("kitsune"):
		unlock("pact"); unlock("bond"); unlock("tournament")
	if GameState.has_flag("first_tournament_done"):
		unlock("dragoness")
	if PactSystem.is_pacted("dragoness"):
		unlock("bunny")
	if PactSystem.is_pacted("bunny"):
		unlock("world")
	if GameState.has_flag("world_opened"):
		unlock("bosses")
	if GameState.has_flag("warden_survived") or GameState.has_flag("first_king_seen"):
		unlock("endgame")

func next_locked() -> String:
	for id in ORDER:
		if not is_on(id):
			return id
	return ""

func debug_line() -> String:
	var bits: PackedStringArray = []
	for id in ORDER:
		bits.append(("●" if is_on(id) else "○") + TITLE[id].substr(0, 3))
	return " ".join(bits)
