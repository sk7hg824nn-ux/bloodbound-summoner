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
	var spr := Sprite2D.new()
	spr.texture = HallArt.tex()
	spr.centered = false
	spr.position = Vector2(-40, 80)
	spr.scale = Vector2(1.28, 0.92)
	var floor := band("Npcs")
	if floor:
		floor.add_child(spr)
	_plate(band("Foreground"), Rect2(-10, 140, 22, 260), Color(0.22, 0.12, 0.12, 0.7))
	_plate(band("Foreground"), Rect2(1180, 160, 20, 240), Color(0.22, 0.12, 0.12, 0.7))

func _plate(root: Node2D, r: Rect2, color: Color) -> void:
	if root == null:
		return
	var n := ColorRect.new()
	n.position = r.position
	n.size = r.size
	n.color = color
	root.add_child(n)
