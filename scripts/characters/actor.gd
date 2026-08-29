extends CharacterBody2D
class_name Actor
## Shared movement, health, and flash for player, companions, and enemies.

@export var display_name: String = "Actor"
@export var move_speed: float = 180.0
@export var max_hp: int = 30
@export var hp: int = 30
@export var team: String = "player"
@export var body_color: Color = Color(0.7, 0.7, 0.75)

@onready var body: Polygon2D = $Body
@onready var label: Label = $NameLabel
@onready var hp_bar: ColorRect = $HpBar/Fill

var invuln_time: float = 0.0
var facing: Vector2 = Vector2.RIGHT


func _ready() -> void:
	hp = max_hp
	if body:
		body.color = body_color
	if label:
		label.text = display_name
	_refresh_hp()


func _process(delta: float) -> void:
	if invuln_time > 0.0:
		invuln_time -= delta
		if body:
			body.modulate.a = 0.45 if fmod(invuln_time, 0.12) < 0.06 else 1.0
	elif body:
		body.modulate.a = 1.0


func apply_velocity(dir: Vector2) -> void:
	if dir.length() > 0.1:
		facing = dir.normalized()
		velocity = facing * move_speed
		if body:
			body.scale.x = -1.0 if facing.x < 0.0 else 1.0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * 6.0 * get_physics_process_delta_time())
	move_and_slide()


func take_hit(amount: int, _from: Node = null) -> void:
	if invuln_time > 0.0 or hp <= 0:
		return
	hp = max(0, hp - amount)
	invuln_time = 0.35
	_refresh_hp()
	_flash()


func heal(amount: int) -> void:
	hp = min(max_hp, hp + amount)
	_refresh_hp()


func is_alive() -> bool:
	return hp > 0


func _refresh_hp() -> void:
	if hp_bar:
		var ratio := 0.0 if max_hp <= 0 else float(hp) / float(max_hp)
		hp_bar.scale.x = max(ratio, 0.0)


func _flash() -> void:
	modulate = Color(1.4, 0.7, 0.7)
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color.WHITE, 0.18)
