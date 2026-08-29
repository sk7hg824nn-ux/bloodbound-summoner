extends CharacterBody2D
class_name Actor

@export var display_name: String = "Actor"
@export var move_speed: float = 180.0
@export var max_hp: int = 30
@export var hp: int = 30
@export var team: String = "player"
@export var body_color: Color = Color(0.7, 0.7, 0.75)
@export var figure_kind: String = "human"

@onready var body: Polygon2D = get_node_or_null("Body")
@onready var label: Label = get_node_or_null("NameLabel")
@onready var hp_bar: ColorRect = get_node_or_null("HpBar/Fill")

var invuln_time: float = 0.0
var facing: Vector2 = Vector2.RIGHT
var figure: Figure2D

func _ready() -> void:
	hp = max_hp
	if body:
		body.visible = false
	figure = Figure2D.attach(self, figure_kind, body_color)
	if label:
		label.text = display_name
	_refresh_hp()

func apply_velocity(dir: Vector2) -> void:
	if dir.length() > 0.1:
		facing = dir.normalized()
		velocity = facing * move_speed
		if figure:
			figure.set_facing(facing)
			figure.walking = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * 6.0 * get_physics_process_delta_time())
		if figure:
			figure.walking = false
	move_and_slide()
	if figure:
		figure.tick(get_physics_process_delta_time())

func take_hit(amount: int, _from: Node = null) -> void:
	if invuln_time > 0.0 or hp <= 0:
		return
	hp = max(0, hp - amount)
	invuln_time = 0.35
	_refresh_hp()

func _refresh_hp() -> void:
	if hp_bar:
		var ratio := 0.0 if max_hp <= 0 else float(hp) / float(max_hp)
		hp_bar.scale.x = max(ratio, 0.0)
