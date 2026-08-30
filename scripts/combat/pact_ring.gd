extends Node
class_name PactRing

var player
var akari
var wolf
var window := 0.0

func bind(p, a, w) -> void:
	player = p
	akari = a
	wolf = w
	if wolf != null and wolf.lunged.is_connected(_on_lunge) == false:
		wolf.lunged.connect(_on_lunge)

func tick(_delta) -> void:
	if window > 0.0:
		window -= _delta
	if wolf != null and is_instance_valid(wolf) and wolf.lock == null and wolf.recover <= 0.0:
		var marks = [akari]
		if akari != null and akari.decoy != null:
			marks.append(akari.decoy)
		marks.append(player)
		wolf.pick(marks)

func call_lie() -> void:
	if PactSystem.is_pacted("kitsune") == false:
		EventBus.toast.emit("You have no pact.")
		return
	if akari == null:
		return
	akari.leave_lie()
	akari.sidestep(player.global_position)
	EventBus.toast.emit("Afterimage. She stepped.")

func commit() -> void:
	if PactSystem.is_pacted("kitsune") == false:
		EventBus.toast.emit("You have no pact.")
		return
	if akari == null or wolf == null:
		return
	if window > 0.0:
		wolf.take_hit(8)
		window = 0.0
		akari.clear_lie()
		EventBus.toast.emit("The lie ate the lunge. Fox Cut.")
		_check_end()
		return
	wolf.take_hit(3)
	EventBus.toast.emit("Fox Cut. Modest. E-rank.")
	_check_end()

func _on_lunge(target) -> void:
	if target == null:
		return
	if akari != null and target == akari.decoy:
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
	if wolf != null and wolf.hp <= 0:
		EventBus.combat_ended.emit(true)
	elif akari != null and akari.hp <= 0:
		EventBus.combat_ended.emit(false)
	elif GameState.hp <= 0:
		EventBus.combat_ended.emit(false)
