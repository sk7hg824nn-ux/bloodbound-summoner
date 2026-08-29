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
	_reset_knob()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var e := event as InputEventScreenTouch
		if e.pressed and _pointer == -1:
			_pointer = e.index
			_update(e.position)
		elif not e.pressed and e.index == _pointer:
			_release()
	elif event is InputEventScreenDrag:
		var e := event as InputEventScreenDrag
		if e.index == _pointer:
			_update(e.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _pointer == -1:
			_pointer = 999
			_update(event.position)
		elif not event.pressed and _pointer == 999:
			_release()
	elif event is InputEventMouseMotion and _pointer == 999:
		_update(event.position)

func _update(pos: Vector2) -> void:
	var center := base.position + base.size * 0.5
	var delta := pos - center
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
