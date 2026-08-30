extends Object
class_name TownLayers
## Childhood town plates. Runtime load only. Never preload packs.

static var _cache = {}


static func tex(which: String) -> Texture2D:
	if _cache.has(which):
		return _cache[which]
	var from_file = _file_tex(which)
	if from_file != null:
		_cache[which] = from_file
		return from_file
	var packed = _packed(which)
	if packed == "":
		return null
	var raw = Marshalls.base64_to_raw(packed)
	if raw.is_empty():
		return null
	var img = Image.new()
	if img.load_jpg_from_buffer(raw) != OK:
		return null
	img.convert(Image.FORMAT_RGBA8)
	if which != "sky" and which != "mid":
		_key_magenta(img)
	var t = ImageTexture.create_from_image(img)
	_cache[which] = t
	return t


static func mount(band, which: String, pos: Vector2, sc: Vector2) -> Sprite2D:
	var t = tex(which)
	if t == null or band == null:
		return null
	var spr = Sprite2D.new()
	spr.name = "Town_" + which
	spr.texture = t
	spr.centered = false
	spr.texture_filter = 1
	spr.position = pos
	spr.scale = sc
	band.add_child(spr)
	return spr


static func mount_mother(band, pos: Vector2) -> Sprite2D:
	var t = tex("mother")
	if t == null or band == null:
		return null
	var spr = Sprite2D.new()
	spr.name = "Town_mother"
	spr.texture = t
	spr.centered = true
	spr.texture_filter = 1
	spr.position = pos
	spr.scale = Vector2(0.42, 0.42)
	spr.offset = Vector2(0, -t.get_height() * 0.42)
	band.add_child(spr)
	return spr


static func _file_tex(which: String) -> Texture2D:
	var paths = [
		"res://art/plates/town_%s.jpg" % which,
		"res://art/plates/town_%s.png" % which,
	]
	var i = 0
	while i < paths.size():
		var path = paths[i]
		if FileAccess.file_exists(path):
			var img = Image.new()
			if img.load(path) == OK:
				if img.get_format() != Image.FORMAT_RGBA8:
					img.convert(Image.FORMAT_RGBA8)
				if which != "sky" and which != "mid":
					_key_magenta(img)
				return ImageTexture.create_from_image(img)
		i += 1
	return null


static func _packed(which: String) -> String:
	var path = "res://scripts/art/art_town_%s.gd" % which
	if ResourceLoader.exists(path) == false:
		return ""
	var scr = load(path)
	if scr == null:
		return ""
	if scr.has_method("pack"):
		return str(scr.pack())
	return ""


static func _key_magenta(img: Image) -> void:
	var w = img.get_width()
	var h = img.get_height()
	var y = 0
	while y < h:
		var x = 0
		while x < w:
			var c = img.get_pixel(x, y)
			var mag = c.r > 0.58 and c.b > 0.52 and c.g < 0.70 and (c.r + c.b) > (c.g * 2.0 + 0.08)
			if mag:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			x += 1
		y += 1
