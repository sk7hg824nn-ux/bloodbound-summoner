extends Actor
class_name WolfSummon

signal lunged(target: Node2D)
var lock: Node2D = null
var lock_time := 0.0
var recover := 0.0

func _ready() -> void:
	display_name = "Wolf"
	team = "enemy"
	figure_kind = "human"
	body_color = Color(0.45, 0.42, 0.40)
	max_hp = 18
	hp = 18
	super._ready()
	if label:
		label.text = "Wolf"

func pick(candidates: Array) -> void:
	var best: Node2D = null
	var best_d := 99999.0
	for n in candidates:
		if n == null or not is_instance_valid(n):
			continue
		var d := global_position.distance_to(n.global_position)
		if d < best_d:
			best_d = d
			best = n
	lock = best
	lock_time = 0.85

func _physics_process(delta: float) -> void:
	if recover > 0.0:
		recover -= delta
		apply_velocity(Vector2.ZERO)
		return
	if lock == null or not is_instance_valid(lock):
		apply_velocity(Vector2.ZERO)
		return
	lock_time -= delta
	var dir := lock.global_position - global_position
	if lock_time > 0.0:
		apply_velocity(dir.normalized())
		return
	global_position += dir.normalized() * min(dir.length(), 52.0)
	recover = 0.9
	lunged.emit(lock)
	lock = null
