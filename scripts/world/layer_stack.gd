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
	_hide_blockout()
	if AcademyLayers.available():
		AcademyLayers.mount(band("FarMountains"), "sky", Vector2(-160, -220), Vector2(1.18, 1.05))
		AcademyLayers.mount(band("FarBackground"), "far", Vector2(-120, -40), Vector2(1.22, 1.02))
		AcademyLayers.mount(band("Buildings"), "buildings", Vector2(-80, 20), Vector2(1.08, 0.92))
		AcademyLayers.mount(band("Foreground"), "fore", Vector2(-100, 40), Vector2(1.20, 1.05))
		return
	HallLayers.mount(band("FarBackground"), "far", Vector2(-80, -40), Vector2(1.22, 1.05))
	HallArt.mount(band("Buildings"))
	HallLayers.mount(band("Npcs"), "crowd", Vector2(-60, 70), Vector2(1.18, 1.08))
	HallLayers.mount(band("Foreground"), "fore", Vector2(-90, -10), Vector2(1.28, 1.18))

func dress_woods() -> void:
	_hide_blockout()
	var path = "res://art/plates/woods_mid.jpg"
	if FileAccess.file_exists(path) == false:
		path = "res://art/plates/woods.jpg"
	if FileAccess.file_exists(path) == false:
		return
	var img = Image.new()
	if img.load(path) != OK:
		return
	var spr = Sprite2D.new()
	spr.name = "Woods_mid"
	spr.texture = ImageTexture.create_from_image(img)
	spr.centered = false
	spr.texture_filter = 1
	spr.position = Vector2(-80, -20)
	spr.scale = Vector2(1.12, 1.02)
	var mid = band("Buildings")
	if mid:
		mid.add_child(spr)

func dress_town() -> void:
	_hide_blockout()
	TownLayers.mount(band("FarMountains"), "sky", Vector2(-120, -180), Vector2(1.38, 1.12))
	TownLayers.mount(band("FarBackground"), "far", Vector2(-90, 20), Vector2(1.28, 1.02))
	TownLayers.mount(band("Buildings"), "mid", Vector2(-40, 148), Vector2(1.10, 0.92))
	TownLayers.mount(band("Npcs"), "trees", Vector2(520, 210), Vector2(0.62, 0.62))
	TownLayers.mount_mother(band("Npcs"), Vector2(214, 402))
	TownLayers.mount(band("Foreground"), "fore", Vector2(-110, 310), Vector2(1.22, 1.02))

func _hide_blockout() -> void:
	var world := get_parent()
	if world == null:
		return
	for c in world.get_children():
		if c is ColorRect:
			c.visible = false
	var root = world.get_parent()
	if root:
		var sky = root.get_node_or_null("ParallaxBackground")
		if sky:
			sky.visible = false
