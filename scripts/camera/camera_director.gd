extends Node3D
class_name CameraDirector
## Directed 2.5D camera. Personality scenes own the lens.

enum Mode { EXPLORE, COMBAT, ROMANCE, BOSS, TOURNAMENT }

@export var mode: Mode = Mode.EXPLORE
@export var target_path: NodePath
@export var use_ortho: bool = false

var target: Node3D
@onready var cam: Camera3D = $Camera3D

var _shake: float = 0.0
var _look_offset: Vector3 = Vector3(0, 1.15, 0)


func _ready() -> void:
	if target_path:
		target = get_node_or_null(target_path) as Node3D
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL if use_ortho else Camera3D.PROJECTION_PERSPECTIVE
	cam.fov = 42.0
	cam.size = 9.0
	cam.current = true


func set_target(n: Node3D) -> void:
	target = n


func set_mode(next: Mode) -> void:
	mode = next


func punch(amount: float = 0.18) -> void:
	_shake = max(_shake, amount)


func _rig() -> Dictionary:
	match mode:
		Mode.COMBAT:
			return {"offset": Vector3(4.2, 5.2, 4.2), "fov": 46.0, "look": Vector3(0, 1.0, 0), "lerp": 6.5}
		Mode.ROMANCE:
			return {"offset": Vector3(1.8, 1.7, 2.4), "fov": 38.0, "look": Vector3(0, 1.35, 0), "lerp": 2.2}
		Mode.BOSS:
			return {"offset": Vector3(7.5, 3.6, 1.2), "fov": 50.0, "look": Vector3(0, 1.4, 0), "lerp": 3.0}
		Mode.TOURNAMENT:
			return {"offset": Vector3(0.4, 8.2, 7.4), "fov": 44.0, "look": Vector3(0, 0.6, 0), "lerp": 4.0}
		_:
			return {"offset": Vector3(5.6, 6.4, 5.6), "fov": 42.0, "look": Vector3(0, 1.15, 0), "lerp": 4.8}


func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return
	var rig: Dictionary = _rig()
	var dest: Vector3 = target.global_position + rig["offset"]
	global_position = global_position.lerp(dest, clampf(rig["lerp"] * delta, 0.0, 1.0))
	_look_offset = _look_offset.lerp(rig["look"], 4.0 * delta)
	var look_at_pt: Vector3 = target.global_position + _look_offset
	if _shake > 0.0:
		look_at_pt += Vector3(randf_range(-1, 1), randf_range(-0.4, 0.4), randf_range(-1, 1)) * _shake
		_shake = move_toward(_shake, 0.0, delta * 1.6)
	look_at(look_at_pt)
	if not use_ortho:
		cam.fov = lerpf(cam.fov, rig["fov"], 3.0 * delta)
