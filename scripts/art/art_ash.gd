extends Object
class_name ArtAsh
## Illustrated Ash field frames.
## File PNGs first. Packed keyed JPEGs second.

const Data = preload("res://scripts/art/art_ash_data.gd")

static var _cache = {}

static func tex(name: String = "idle_se") -> Texture2D:
	if _cache.has(name):
		return _cache[name]
	var from_file = _file_tex(name)
	if from_file != null:
		_cache[name] = from_file
		return from_file
	var packed = Data.frame(name)
	if packed == "":
		return null
	var raw := Marshalls.base64_to_raw(packed)
	if raw.is_empty():
		return null
	var img := Image.new()
	if img.load_jpg_from_buffer(raw) != OK:
		return null
	img.convert(Image.FORMAT_RGBA8)
	_key_magenta(img)
	var t := ImageTexture.create_from_image(img)
	_cache[name] = t
	return t

static func has_art() -> bool:
	return tex("idle_se") != null

static func _file_tex(name: String) -> Texture2D:
	var path := "res://art/characters/ash/%s.png" % name
	if ResourceLoader.exists(path):
		var loaded = load(path)
		if loaded != null:
			return loaded
	if FileAccess.file_exists(path):
		var img := Image.new()
		if img.load(path) == OK:
			return ImageTexture.create_from_image(img)
	return null

static func _key_magenta(img: Image) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var y := 0
	while y < h:
		var x := 0
		while x < w:
			var c := img.get_pixel(x, y)
			if c.r > 0.62 and c.b > 0.62 and c.g < 0.48:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			x += 1
		y += 1
