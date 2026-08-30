extends Node2D
class_name Figure2D

var kind: String = "human"
var body_color: Color = Color(0.08, 0.09, 0.10)
var skin := Color(0.86, 0.72, 0.62)
var hair := Color(0.92, 0.93, 0.90)
var shadow: Polygon2D
var coat: Polygon2D
var lining: Polygon2D
var arm: Polygon2D
var head: Polygon2D
var hair_back: Polygon2D
var hair_front: Polygon2D
var streak: Polygon2D
var eye_l: Polygon2D
var eye_r: Polygon2D
var _bob: float = 0.0
var walking: bool = false
var gait: String = "idle"
var facing_x: float = 1.0
var look_scale: float = 1.0

static func attach(host: Node2D, kind: String, color: Color) -> Figure2D:
	var existing := host.get_node_or_null("Figure") as Figure2D
	if existing:
		existing.kind = kind
		existing.body_color = color
		existing._paint()
		return existing
	var fig := Figure2D.new()
	fig.name = "Figure"
	fig.kind = kind
	fig.body_color = color
	host.add_child(fig)
	fig.z_index = 2
	fig._build()
	return fig

func _build() -> void:
	shadow = _poly("Shadow", Color(0, 0, 0, 0.35), PackedVector2Array([
		Vector2(-18, 18), Vector2(18, 18), Vector2(12, 22), Vector2(-12, 22)
	]))
	shadow.z_index = -2
	hair_back = _poly("HairBack", hair, PackedVector2Array([
		Vector2(-12, -20), Vector2(-14, -34), Vector2(-4, -42), Vector2(8, -40), Vector2(14, -30), Vector2(10, -18)
	]))
	lining = _poly("Lining", Color(0.22, 0.55, 0.18), PackedVector2Array([
		Vector2(-6, 18), Vector2(-16, 4), Vector2(-14, -10), Vector2(4, -12), Vector2(8, 16)
	]))
	coat = _poly("Coat", Color(0.07, 0.08, 0.09), PackedVector2Array([
		Vector2(-14, 18), Vector2(-16, -2), Vector2(-10, -16), Vector2(10, -16), Vector2(16, -2), Vector2(13, 18), Vector2(4, 16), Vector2(-4, 16)
	]))
	arm = _poly("Arm", Color(0.10, 0.11, 0.12), PackedVector2Array([
		Vector2(8, -10), Vector2(18, -6), Vector2(16, 8), Vector2(8, 6)
	]))
	arm.z_index = 2
	head = _poly("Head", skin, PackedVector2Array([
		Vector2(-8, -16), Vector2(-9, -30), Vector2(-2, -36), Vector2(7, -34), Vector2(9, -22), Vector2(6, -16)
	]))
	hair_front = _poly("Hair", hair, PackedVector2Array([
		Vector2(-9, -24), Vector2(-12, -36), Vector2(-2, -44), Vector2(10, -38), Vector2(8, -24), Vector2(2, -20), Vector2(-4, -22)
	]))
	streak = _poly("Streak", Color(0.35, 0.78, 0.28), PackedVector2Array([
		Vector2(-2, -40), Vector2(2, -42), Vector2(4, -28), Vector2(0, -26)
	]))
	eye_l = _poly("EyeL", Color(0.18, 0.42, 0.20), PackedVector2Array([
		Vector2(-5, -26), Vector2(-5, -29), Vector2(-1, -29), Vector2(-1, -26)
	]))
	eye_r = _poly("EyeR", Color(0.18, 0.42, 0.20), PackedVector2Array([
		Vector2(2, -26), Vector2(2, -29), Vector2(6, -29), Vector2(6, -26)
	]))
	_paint()

func _poly(n: String, color: Color, pts: PackedVector2Array) -> Polygon2D:
	var p := Polygon2D.new()
	p.name = n
	p.color = color
	p.polygon = pts
	add_child(p)
	return p

func _paint() -> void:
	if kind == "kitsune":
		hair = Color(0.62, 0.42, 0.82)
		if hair_front:
			hair_front.color = hair
		if hair_back:
			hair_back.color = hair.darkened(0.1)
		if coat:
			coat.color = Color(0.55, 0.16, 0.22)
		if lining:
			lining.color = Color(0.92, 0.90, 0.88)
	elif kind == "human":
		if hair_front:
			hair_front.color = Color(0.92, 0.93, 0.90)
		if hair_back:
			hair_back.color = Color(0.86, 0.88, 0.84)
		if streak:
			streak.color = Color(0.35, 0.78, 0.28)
		if coat:
			coat.color = Color(0.07, 0.08, 0.09)
		if lining:
			lining.color = Color(0.22, 0.55, 0.18)

func apply_look(era: String) -> void:
	look_scale = 0.78 if era == "child" else 1.12
	scale = Vector2(facing_x * look_scale, look_scale)
	if era == "child":
		if coat:
			coat.color = Color(0.28, 0.34, 0.42)
		if lining:
			lining.color = Color(0.40, 0.46, 0.38)
		if hair_front:
			hair_front.color = Color(0.16, 0.14, 0.14)
		if streak:
			streak.visible = false
	else:
		_paint()
		if streak:
			streak.visible = true

func set_facing(dir: Vector2) -> void:
	if abs(dir.x) > 0.12:
		facing_x = -1.0 if dir.x < 0.0 else 1.0
		scale = Vector2(facing_x * look_scale, look_scale)

func tick(delta: float) -> void:
	if gait == "run" or walking:
		gait = "walk" if gait != "run" else "run"
	elif not walking:
		gait = "idle"
	var amp := 2.4 if gait != "idle" else 0.6
	_bob += delta * (12.0 if gait != "idle" else 3.0)
	position.y = sin(_bob) * amp

func swing() -> void:
	pass

func dodge_smear() -> void:
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color(0.7, 0.85, 1.2, 0.7), 0.04)
	tw.tween_property(self, "modulate", Color.WHITE, 0.16)
