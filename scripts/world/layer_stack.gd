extends Node2D
class_name LayerStack

const NAMES := ["FarMountains", "FarBackground", "Buildings", "Npcs", "Party", "ForegroundNpcs", "Foreground"]
const Z := [-40, -30, -15, -5, 0, 5, 12]
const SCALE := [
	Vector2(0.04, 0.01),
	Vector2(0.12, 0.03),
	Vector2(0.40, 0.08),
	Vector2(1.0, 1.0),
	Vector2(1.0, 1.0),
	Vector2(1.12, 1.04),
	Vector2(1.35, 1.10),
]
const ALIAS := {
	"Background": "FarMountains",
	"Distant": "FarBackground",
	"Architecture": "Buildings",
}

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
	var key := name
	if ALIAS.has(key):
		key = str(ALIAS[key])
	return get_node_or_null(key) as Node2D

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
	var far := ColorRect.new()
	far.size = Vector2(1600, 220)
	far.position = Vector2(-200, -40)
	far.color = Color(0.16, 0.14, 0.20)
	var bg := band("FarMountains")
	if bg:
		bg.add_child(far)
	var mid := ColorRect.new()
	mid.size = Vector2(1400, 160)
	mid.position = Vector2(-80, 40)
	mid.color = Color(0.22, 0.18, 0.24, 0.85)
	var dist := band("FarBackground")
	if dist:
		dist.add_child(mid)
	var spr := Sprite2D.new()
	spr.texture = HallArt.tex()
	spr.centered = false
	spr.position = Vector2(-40, 80)
	spr.scale = Vector2(1.28, 0.92)
	var floor := band("Npcs")
	if floor:
		floor.add_child(spr)
	_plate(band("Foreground"), Rect2(-80, 200, 70, 320), Color(0.10, 0.07, 0.08, 0.82))
	_plate(band("Foreground"), Rect2(1180, 210, 90, 300), Color(0.10, 0.07, 0.08, 0.82))

func _plate(root: Node2D, r: Rect2, color: Color) -> void:
	if root == null:
		return
	var n := ColorRect.new()
	n.position = r.position
	n.size = r.size
	n.color = color
	root.add_child(n)
