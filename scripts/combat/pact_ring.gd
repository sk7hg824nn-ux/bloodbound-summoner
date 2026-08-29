extends Node
class_name PactRing

var player: Player
var akari: Akari
var wolf: WolfSummon
var window := 0.0

func bind(p: Player, a: Akari, w: WolfSummon) -> void:
	player = p
	akari = a
	wolf = w
	if wolf and not wolf.lunged.is_connected(_on_lunge):
		wolf.lunged.connect(_on_lunge)

func tick(_delta: float) -> void:
	if window > 0.0:
		window -= _delta
	if wolf and is_instance_valid(wolf) and wolf.lock == null and wolf.recover <= 0.0:
		var marks: Array = [akari]
		if akari and akari.decoy:
			marks.append(akari.decoy)
		marks.append(player)
		wolf.pick(marks)

func call_lie() -> void:
	if not PactSystem.is_pacted("kitsune"):
		EventBus.toast.emit("You have no pact.")
		return
	if akari == null:
		return
	akari.leave_lie()
	akari.sidestep(player.global_position)
	EventBus.toast.emit("Afterimage. She stepped.")

func commit() -> void:
	if not PactSystem.is_pacted("kitsune"):
		EventBus.toast.emit("You have no pact.")
		return
	if akari == null or wolf == null:
		return
	if window > 0.0:
		wolf.take_hit(8)
		window = 0.0
		akari.clear_lie()
		if akari.figure:
			akari.figure.swing()
		EventBus.toast.emit("The lie ate the lunge. Fox Cut.")
		_check_end()
		return
	wolf.take_hit(3)
	if akari.figure:
		akari.figure.swing()
	EventBus.toast.emit("Fox Cut. Modest. E-rank.")
	_check_end()

func _on_lunge(target: Node2D) -> void:
	if target == null:
		return
	if akari and target == akari.decoy:
		window = 1.15
		EventBus.toast.emit("It bit the statue.")
		return
	if target == akari:
		akari.take_hit(6)
		EventBus.toast.emit("It found the real fox.")
		_check_end()
		return
	if target == player:
		GameState.take_damage(4)
		player.sync_hp_from_state()
		EventBus.toast.emit("Stand was the wrong square.")
		_check_end()

func _check_end() -> void:
	if wolf and wolf.hp <= 0:
		EventBus.combat_ended.emit(true)
	elif akari and akari.hp <= 0:
		EventBus.combat_ended.emit(false)
	elif GameState.hp <= 0:
		EventBus.combat_ended.emit(false)
