extends CharacterBody2D
class_name Actor

@export var display_name: String = "Actor"
@export var move_speed: float = 180.0
@export var max_hp: int = 30
@export var hp: int = 30
@export var team: String = "player"
@export var body_color: Color = Color(0.7, 0.7, 0.75)
@export var figure_kind: String = "human"
@export var field_sheet: String = "ash_field"

@onready var body: Polygon2D = get_node_or_null("Body")
@onready var label: Label = get_node_or_null("NameLabel")
@onready var hp_bar: ColorRect = get_node_or_null("HpBar/Fill")

var invuln_time: float = 0.0
var facing: Vector2 = Vector2.RIGHT
var figure: Figure2D
var field: FieldPresenter

func _ready() -> void:
	hp = max_hp
	if body:
		body.visible = false
	z_as_relative = false
	field = FieldPresenter.attach(self, field_sheet, figure_kind, body_color)
	figure = field.figure if field else Figure2D.attach(self, figure_kind, body_color)
	if field:
		field.set_era(GameState.era)
	if label:
		label.text = display_name
	_refresh_hp()

func apply_velocity(dir: Vector2) -> void:
	var gait := "idle"
	if dir.length() > 0.1:
		facing = dir.normalized()
		velocity = facing * move_speed
		gait = "run" if move_speed > 200.0 else "walk"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * 6.0 * get_physics_process_delta_time())
	move_and_slide()
	z_index = int(global_position.y)
	var left := facing.x < 0.0
	if field:
		field.play_gait(gait, left, global_position.y, facing.y)
		field.tick(get_physics_process_delta_time())
	elif figure:
		figure.set_facing(facing)
		figure.walking = gait != "idle"
		figure.gait = gait
		figure.tick(get_physics_process_delta_time())
		DepthRig.apply(figure, global_position.y, figure.facing_x)

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
