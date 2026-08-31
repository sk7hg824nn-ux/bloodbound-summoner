extends Actor
class_name Akari
## First pact. One tail until the story says otherwise. Combatant, not a pet.

var follow_distance := 54.0
var decoy: Node2D = null

func _ready() -> void:
	display_name = "Akari"
	team = "player"
	figure_kind = "kitsune"
	field_sheet = "akari"
	body_color = Color(0.91, 0.48, 0.22)
	max_hp = 22
	hp = 22
	super._ready()
	if label:
		label.text = "Akari"
	if figure:
		figure.hair = Color(0.72, 0.28, 0.12)
		figure._paint()
		_one_tail()

func _one_tail() -> void:
	if figure == null:
		return
	if figure.get_node_or_null("Tail") != null:
		return
	var tail := Polygon2D.new()
	tail.name = "Tail"
	tail.color = Color(0.93, 0.55, 0.28, 0.95)
	tail.polygon = PackedVector2Array([Vector2(0, 10), Vector2(-8, 16), Vector2(-2, 36), Vector2(8, 16)])
	tail.position = Vector2(-6, 8)
	tail.rotation = -0.6
	figure.add_child(tail)
	var ear_l := Polygon2D.new()
	ear_l.name = "EarL"
	ear_l.color = Color(0.72, 0.28, 0.12)
	ear_l.polygon = PackedVector2Array([Vector2(-7, -30), Vector2(-12, -42), Vector2(-2, -32)])
	figure.add_child(ear_l)
	var ear_r := Polygon2D.new()
	ear_r.name = "EarR"
	ear_r.color = Color(0.72, 0.28, 0.12)
	ear_r.polygon = PackedVector2Array([Vector2(7, -30), Vector2(12, -42), Vector2(2, -32)])
	figure.add_child(ear_r)

func follow(host: Node2D, delta: float) -> void:
	if host == null or GameState.in_dialogue:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	var gap := global_position.distance_to(host.global_position)
	if gap > follow_distance:
		apply_velocity((host.global_position - global_position).normalized())
	else:
		apply_velocity(Vector2.ZERO)

func leave_lie() -> Node2D:
	clear_lie()
	decoy = Node2D.new()
	decoy.name = "Lie"
	var ghost := Figure2D.attach(decoy, "kitsune", Color(0.91, 0.48, 0.22, 0.45))
	ghost.modulate.a = 0.45
	get_parent().add_child(decoy)
	decoy.global_position = global_position
	return decoy

func clear_lie() -> void:
	if decoy and is_instance_valid(decoy):
		decoy.queue_free()
	decoy = null
