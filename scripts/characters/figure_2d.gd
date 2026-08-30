extends Node2D
class_name Figure2D

var kind: String = "human"
var body_color: Color = Color(0.4, 0.5, 0.8)
var skin := Color(0.93, 0.80, 0.70)
var hair := Color(0.18, 0.14, 0.16)
var shadow: Polygon2D
var coat: Polygon2D
var arm: Polygon2D
var head: Polygon2D
var hair_back: Polygon2D
var hair_front: Polygon2D
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
	shadow = _poly("Shadow", Color(0, 0, 0, 0.28), PackedVector2Array([Vector2(-16, 16), Vector2(16, 16), Vector2(11, 20), Vector2(-11, 20)]))
	shadow.z_index = -2
	hair_back = _poly("HairBack", hair, PackedVector2Array([Vector2(-11, -18), Vector2(-13, -30), Vector2(0, -36), Vector2(13, -30), Vector2(11, -18)]))
	coat = _poly("Body", body_color, PackedVector2Array([Vector2(-12, 16), Vector2(-13, -4), Vector2(-8, -16), Vector2(8, -16), Vector2(13, -4), Vector2(12, 16)]))
	var lining := _poly("Lining", body_color.lightened(0.18), PackedVector2Array([Vector2(-6, 14), Vector2(-5, -8), Vector2(5, -8), Vector2(6, 14)]))
	lining.z_index = 1
	arm = _poly("Arm", body_color.darkened(0.08), PackedVector2Array([Vector2(8, -8), Vector2(16, -4), Vector2(15, 8), Vector2(9, 6)]))
	arm.z_index = 2
	head = _poly("Head", skin, PackedVector2Array([Vector2(-8, -16), Vector2(-8, -30), Vector2(0, -34), Vector2(8, -30), Vector2(8, -16)]))
	hair_front = _poly("HairFront", hair.lightened(0.06), PackedVector2Array([Vector2(-8, -26), Vector2(-10, -32), Vector2(0, -36), Vector2(10, -32), Vector2(8, -26), Vector2(3, -22), Vector2(-4, -24)]))
	eye_l = _poly("EyeL", Color(0.12, 0.10, 0.12), PackedVector2Array([Vector2(-5, -24), Vector2(-5, -26), Vector2(-2, -26), Vector2(-2, -24)]))
	eye_r = _poly("EyeR", Color(0.12, 0.10, 0.12), PackedVector2Array([Vector2(2, -24), Vector2(2, -26), Vector2(5, -26), Vector2(5, -24)]))
	_paint()

func _poly(n: String, color: Color, pts: PackedVector2Array) -> Polygon2D:
	var p := Polygon2D.new()
	p.name = n
	p.color = color
	p.polygon = pts
	add_child(p)
	return p

func _paint() -> void:
	if coat:
		coat.color = body_color
	_apply_portrait()

func _apply_portrait() -> void:
	var tex: Texture2D = ArtAsh.tex() if kind != "kitsune" else null
	if tex == null:
		return
	for c in get_children():
		if c is Polygon2D:
			c.visible = false
	var spr := get_node_or_null("Portrait") as Sprite2D
	if spr == null:
		spr = Sprite2D.new()
		spr.name = "Portrait"
		spr.centered = true
		spr.position = Vector2(0, -10)
		add_child(spr)
	spr.texture = tex
	spr.scale = Vector2(0.28, 0.28)

func apply_look(era: String) -> void:
	look_scale = 0.84 if era == "child" else 1.0
	scale = Vector2(facing_x * look_scale, look_scale)

func set_facing(dir: Vector2) -> void:
	if abs(dir.x) > 0.12:
		facing_x = -1.0 if dir.x < 0.0 else 1.0
		scale = Vector2(facing_x * look_scale, look_scale)

func tick(delta: float) -> void:
	if gait == "run" or walking:
		gait = "run" if gait == "run" else "walk"
	elif not walking:
		gait = "idle"
	var amp := 2.2 if gait != "idle" else 0.7
	_bob += delta * (12.0 if gait != "idle" else 3.0)
	position.y = sin(_bob) * amp

func swing() -> void:
	pass

func dodge_smear() -> void:
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color(0.7, 0.85, 1.2, 0.7), 0.04)
	tw.tween_property(self, "modulate", Color.WHITE, 0.16)
