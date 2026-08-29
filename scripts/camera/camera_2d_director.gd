extends Camera2D
class_name Camera2DDirector

enum Mode { EXPLORE, COMBAT, ROMANCE, BOSS, TOURNAMENT }

@export var mode: Mode = Mode.EXPLORE
var target: Node2D
var _shake: float = 0.0
var _look: Vector2 = Vector2(0, -12)

func set_target(n: Node2D) -> void:
	target = n
	enabled = true
	make_current()

func set_bounds(rect: Rect2) -> void:
	limit_enabled = true
	limit_left = int(rect.position.x)
	limit_top = int(rect.position.y)
	limit_right = int(rect.end.x)
	limit_bottom = int(rect.end.y)

func set_mode(next: Mode) -> void:
	mode = next

func punch(amount: float = 0.18) -> void:
	_shake = max(_shake, amount)

func _rig() -> Dictionary:
	match mode:
		Mode.COMBAT:
			return {"zoom": 1.32, "look": Vector2(0, -8), "lerp": 6.5}
		Mode.ROMANCE:
			return {"zoom": 1.62, "look": Vector2(0, -22), "lerp": 2.4}
		Mode.BOSS:
			return {"zoom": 1.05, "look": Vector2(18, -6), "lerp": 3.0}
		Mode.TOURNAMENT:
			return {"zoom": 1.08, "look": Vector2(0, 8), "lerp": 4.0}
		_:
			return {"zoom": 1.16, "look": Vector2(0, -12), "lerp": 5.0}

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return
	var rig: Dictionary = _rig()
	_look = _look.lerp(rig["look"], 4.0 * delta)
	var dest := target.global_position + _look
	if limit_enabled:
		dest.x = clampf(dest.x, float(limit_left) + 80.0, float(limit_right) - 80.0)
		dest.y = clampf(dest.y, float(limit_top) + 50.0, float(limit_bottom) - 50.0)
	if _shake > 0.0:
		dest += Vector2(randf_range(-1, 1), randf_range(-1, 1)) * _shake * 18.0
		_shake = move_toward(_shake, 0.0, delta * 1.8)
	global_position = global_position.lerp(dest, clampf(float(rig["lerp"]) * delta, 0.0, 1.0))
	var z := float(rig["zoom"])
	zoom = zoom.lerp(Vector2(z, z), 3.2 * delta)
