extends RefCounted
class_name World25
## Single 2.5D entry. Rooms, plates, stack, handshake.

const PLATE_DIR := "res://art/plates/"

static func compose(world: Node2D, room: String) -> LayerStack:
	var stack := LayerStack.attach(world)
	match room:
		"hall":
			stack.dress_hall()
			_overlay_png(stack, "hall")
		"woods":
			_overlay_png(stack, "woods")
		"village", "yard", "town":
			stack.dress_town()
			_overlay_png(stack, "village")
	return stack

static func bind_cut(cut, camera, stack: LayerStack) -> void:
	cut.camera = camera
	cut.stack = stack

static func still(id: String) -> Texture2D:
	var path := PLATE_DIR + id + ".png"
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	return OriginArt.tex(id)

static func _overlay_png(stack: LayerStack, id: String) -> void:
	var path := PLATE_DIR + id + ".png"
	if ResourceLoader.exists(path) == false:
		return
	var spr := Sprite2D.new()
	spr.texture = load(path)
	spr.centered = false
	spr.position = Vector2(-40, 80)
	spr.texture_filter = 1
	var band := stack.band("Buildings")
	if band == null:
		band = stack.band("Npcs")
	if band:
		band.add_child(spr)
