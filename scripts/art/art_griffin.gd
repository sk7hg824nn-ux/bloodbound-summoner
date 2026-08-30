extends Object
class_name ArtGriffin
## Runtime load. Do not preload the pack.

static var _cache

static func tex():
	if _cache:
		return _cache
	if FileAccess.file_exists("res://art/characters/griffin/idle.png"):
		var img = Image.new()
		if img.load("res://art/characters/griffin/idle.png") == OK:
			_cache = ImageTexture.create_from_image(img)
			return _cache
	var packed = _packed()
	if packed == "":
		return null
	var raw = Marshalls.base64_to_raw(packed)
	if raw.is_empty():
		return null
	var img2 = Image.new()
	if img2.load_jpg_from_buffer(raw) != OK:
		return null
	img2.convert(Image.FORMAT_RGBA8)
	_key_magenta(img2)
	_cache = ImageTexture.create_from_image(img2)
	return _cache

static func _packed() -> String:
	var path = "res://scripts/art/art_griffin_data.gd"
	if ResourceLoader.exists(path) == false:
		return ""
	var scr = load(path)
	if scr == null:
		return ""
	if scr.has_method("frame"):
		return str(scr.frame())
	return ""

static func _key_magenta(img):
	var w = img.get_width()
	var h = img.get_height()
	var y = 0
	while y < h:
		var x = 0
		while x < w:
			var c = img.get_pixel(x, y)
			if c.r > 0.62 and c.b > 0.62 and c.g < 0.48:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			x += 1
		y += 1
