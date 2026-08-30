extends RefCounted
class_name HallArt
## Painted Grand Summoning Hall plate.
## File first, packed JPEG second, procedural last.

const Data = preload("res://scripts/art/art_hall_data.gd")

static var _cache: Texture2D

static func tex() -> Texture2D:
	if _cache:
		return _cache
	if ResourceLoader.exists("res://art/plates/hall.png"):
		_cache = load("res://art/plates/hall.png") as Texture2D
		if _cache:
			return _cache
	if ResourceLoader.exists("res://art/plates/hall.jpg"):
		_cache = load("res://art/plates/hall.jpg") as Texture2D
		if _cache:
			return _cache
	var packed = Data.plate()
	if packed != "":
		var raw := Marshalls.base64_to_raw(packed)
		if raw.is_empty() == false:
			var img := Image.new()
			if img.load_jpg_from_buffer(raw) == OK:
				_cache = ImageTexture.create_from_image(img)
				return _cache
	_cache = _fallback()
	return _cache

static func mount(band: Node2D) -> Sprite2D:
	var spr := Sprite2D.new()
	spr.name = "HallPlate"
	spr.texture = tex()
	spr.centered = false
	spr.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	# Plate is 800x450. Circle near image center-low.
	# World circle / Ash walk target is (480, 420).
	spr.scale = Vector2(1.46, 1.42)
	spr.position = Vector2(-104, -52)
	if band:
		band.add_child(spr)
	return spr

static func _fallback() -> Texture2D:
	var img := Image.create(960, 540, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.10, 0.08, 0.09))
	img.fill_rect(Rect2i(0, 200, 960, 340), Color(0.22, 0.12, 0.10))
	img.fill_rect(Rect2i(360, 20, 240, 200), Color(0.18, 0.08, 0.10))
	var t := ImageTexture.create_from_image(img)
	return t
