extends RefCounted
class_name HallArt
## Painted Grand Summoning Hall plate.
## Runtime load only. Never preload the pack — missing pack
## is a Xogot parser error.

static var _cache

static func tex():
	if _cache:
		return _cache
	var from_file = _file_tex()
	if from_file:
		_cache = from_file
		return _cache
	var packed = _packed()
	if packed != "":
		var raw = Marshalls.base64_to_raw(packed)
		if raw.is_empty() == false:
			var img = Image.new()
			if img.load_jpg_from_buffer(raw) == OK:
				_cache = ImageTexture.create_from_image(img)
				return _cache
	_cache = _fallback()
	return _cache

static func mount(band):
	var spr = Sprite2D.new()
	spr.name = "HallPlate"
	spr.texture = tex()
	spr.centered = false
	spr.texture_filter = 1
	spr.scale = Vector2(1.46, 1.42)
	spr.position = Vector2(-104, -52)
	if band:
		band.add_child(spr)
	return spr

static func _file_tex():
	var paths = ["res://art/plates/hall.jpg", "res://art/plates/hall.png"]
	var i = 0
	while i < paths.size():
		var path = paths[i]
		if FileAccess.file_exists(path):
			var img = Image.new()
			if img.load(path) == OK:
				return ImageTexture.create_from_image(img)
		i += 1
	return null

static func _packed() -> String:
	var path = "res://scripts/art/art_hall_data.gd"
	if ResourceLoader.exists(path) == false:
		return ""
	var scr = load(path)
	if scr == null:
		return ""
	if scr.has_method("plate"):
		return str(scr.plate())
	return ""

static func _fallback():
	var img = Image.create(960, 540, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.10, 0.08, 0.09))
	img.fill_rect(Rect2i(0, 180, 960, 360), Color(0.28, 0.14, 0.12))
	img.fill_rect(Rect2i(300, 10, 360, 190), Color(0.42, 0.10, 0.12))
	img.fill_rect(Rect2i(40, 160, 180, 220), Color(0.16, 0.10, 0.10))
	img.fill_rect(Rect2i(740, 160, 180, 220), Color(0.16, 0.10, 0.10))
	var y = 240
	while y < 520:
		var t = float(y - 240) / 280.0
		var half = int(80.0 + t * 380.0)
		var x = 480 - half
		while x < 480 + half:
			if y >= 0 and y < 540 and x >= 0 and x < 960:
				var c = img.get_pixel(x, y)
				img.set_pixel(x, y, Color(c.r + 0.04, c.g + 0.01, c.b + 0.01))
			x += 18
		y += 28
	return ImageTexture.create_from_image(img)
