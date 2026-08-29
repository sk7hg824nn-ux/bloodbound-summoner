extends Control
class_name VirtualJoystick

signal direction_changed(dir: Vector2)

@export var deadzone: float = 0.18
@export var max_radius: float = 56.0

var _pointer: int = -1
var _dir: Vector2 = Vector2.ZERO

@onready var base: Panel = $Base
@onready var knob: Panel = $Base/Knob

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	if base:
		base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if knob:
		knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_reset_knob()

func get_direction() -> Vector2:
	return _dir

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var e := event as InputEventScreenTouch
		if e.pressed and _pointer == -1 and _hit(e.position):
			_pointer = e.index
			_update_from_viewport(e.position)
			get_viewport().set_input_as_handled()
		elif not e.pressed and e.index == _pointer:
			_release()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		var e := event as InputEventScreenDrag
		if e.index == _pointer:
			_update_from_viewport(e.position)
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _pointer == -1 and _hit(event.position):
			_pointer = 999
			_update_from_viewport(event.position)
		elif not event.pressed and _pointer == 999:
			_release()
	elif event is InputEventMouseMotion and _pointer == 999:
		_update_from_viewport(event.position)

func _hit(viewport_pos: Vector2) -> bool:
	if get_global_rect().grow(24.0).has_point(viewport_pos):
		return true
	var vr := get_viewport().get_visible_rect()
	return viewport_pos.x < vr.size.x * 0.34 and viewport_pos.y > vr.size.y * 0.38 and viewport_pos.y < vr.size.y * 0.92

func _update_from_viewport(viewport_pos: Vector2) -> void:
	var center := base.global_position + base.size * 0.5
	var delta := viewport_pos - center
	if delta.length() > max_radius:
		delta = delta.normalized() * max_radius
	knob.position = (base.size - knob.size) * 0.5 + delta
	var norm := delta / max_radius
	if norm.length() < deadzone:
		norm = Vector2.ZERO
	_dir = norm.limit_length(1.0)
	direction_changed.emit(_dir)

func _release() -> void:
	_pointer = -1
	_dir = Vector2.ZERO
	_reset_knob()
	direction_changed.emit(_dir)

func _reset_knob() -> void:
	if knob and base:
		knob.position = (base.size - knob.size) * 0.5
