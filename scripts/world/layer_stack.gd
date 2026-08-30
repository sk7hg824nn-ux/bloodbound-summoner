extends Node2D
class_name LayerStack

const NAMES := ["Background", "Distant", "Architecture", "Npcs", "Party", "Foreground"]
const Z := [-30, -18, -8, 1, 4, 12]
const SCALE := [
	Vector2(0.12, 0.03),
	Vector2(0.28, 0.06),
	Vector2(0.62, 0.12),
	Vector2(1.0, 1.0),
	Vector2(1.0, 1.0),
	Vector2(1.22, 1.0),
]

static func attach(host: Node2D) -> LayerStack:
	var existing := host.get_node_or_null("LayerStack") as LayerStack
	if existing:
		return existing
	var stack := LayerStack.new()
	stack.name = "LayerStack"
	host.add_child(stack)
	host.move_child(stack, 0)
	for i in NAMES.size():
		var n := Parallax2D.new()
		n.name = NAMES[i]
		n.z_index = Z[i]
		n.scroll_scale = SCALE[i]
		n.repeat_size = Vector2.ZERO
		stack.add_child(n)
	return stack

func band(name: String) -> Node2D:
	return get_node_or_null(name) as Node2D

func freeze() -> void:
	for c in get_children():
		if c is Parallax2D:
			(c as Parallax2D).ignore_camera_scroll = true

func thaw() -> void:
	for c in get_children():
		if c is Parallax2D:
			(c as Parallax2D).ignore_camera_scroll = false

func dress_hall() -> void:
	var world := get_parent()
	if world:
		for c in world.get_children():
			if c is ColorRect:
				c.visible = false
	_plate(band("Background"), Rect2(-80, -80, 1400, 300), Color(0.08, 0.07, 0.10))
	_plate(band("Distant"), Rect2(300, 40, 280, 140), Color(0.14, 0.12, 0.16))
	_plate(band("Distant"), Rect2(700, 30, 220, 150), Color(0.13, 0.11, 0.15))
	_plate(band("Architecture"), Rect2(-20, 220, 170, 300), Color(0.22, 0.16, 0.16))
	_plate(band("Architecture"), Rect2(1040, 220, 170, 300), Color(0.22, 0.16, 0.16))
	_plate(band("Architecture"), Rect2(40, 200, 140, 36), Color(0.30, 0.18, 0.18))
	_plate(band("Architecture"), Rect2(40, 248, 140, 36), Color(0.26, 0.16, 0.16))
	_plate(band("Architecture"), Rect2(40, 296, 140, 36), Color(0.24, 0.15, 0.15))
	_plate(band("Architecture"), Rect2(1040, 200, 140, 36), Color(0.30, 0.18, 0.18))
	_plate(band("Architecture"), Rect2(1040, 248, 140, 36), Color(0.26, 0.16, 0.16))
	_plate(band("Architecture"), Rect2(1040, 296, 140, 36), Color(0.24, 0.15, 0.15))
	_plate(band("Architecture"), Rect2(-40, 180, 1280, 520), Color(0.16, 0.14, 0.16, 0.35))
	_circle(band("Architecture"), Vector2(480, 420), 70.0, Color(0.62, 0.12, 0.14, 0.95))
	_plate(band("Foreground"), Rect2(-10, 140, 24, 260), Color(0.12, 0.08, 0.08, 0.7))
	_plate(band("Foreground"), Rect2(1180, 160, 22, 240), Color(0.12, 0.08, 0.08, 0.7))

func _plate(root: Node2D, r: Rect2, color: Color) -> void:
	if root == null:
		return
	var n := ColorRect.new()
	n.position = r.position
	n.size = r.size
	n.color = color
	root.add_child(n)

func _circle(root: Node2D, at: Vector2, radius: float, color: Color) -> void:
	if root == null:
		return
	var line := Line2D.new()
	line.width = 4.0
	line.default_color = color
	var pts := PackedVector2Array()
	for i in 32:
		var a := TAU * float(i) / 32.0
		pts.append(at + Vector2(cos(a), sin(a)) * radius)
	pts.append(pts[0])
	line.points = pts
	root.add_child(line)
