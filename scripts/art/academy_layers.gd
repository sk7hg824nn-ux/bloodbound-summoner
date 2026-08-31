extends Object
class_name AcademyLayers
## Courtyard plates. Runtime file load. Magenta keyed except sky.

static var _cache = {}


static func tex(which: String) -> Texture2D:
	if _cache.has(which):
		return _cache[which]
	var t = _file_tex(which)
	if t != null:
		_cache[which] = t
	return t


static func mount(band, which: String, pos: Vector2, sc: Vector2) -> Sprite2D:
	var t = tex(which)
	if t == null or band == null:
		return null
	var spr = Sprite2D.new()
	spr.name = "Academy_" + which
	spr.texture = t
	spr.centered = false
	spr.texture_filter = 1
	spr.position = pos
	spr.scale = sc
	band.add_child(spr)
	return spr


static func available() -> bool:
	return tex("buildings") != null


static func _file_tex(which: String) -> Texture2D:
	var paths = [
		"res://art/plates/academy_%s.jpg" % which,
		"res://art/plates/academy_%s.png" % which,
	]
	var i = 0
	while i < paths.size():
		var path = paths[i]
		if FileAccess.file_exists(path):
			var img = Image.new()
			if img.load(path) == OK:
				if img.get_format() != Image.FORMAT_RGBA8:
					img.convert(Image.FORMAT_RGBA8)
				if which != "sky":
					_key_magenta(img)
				return ImageTexture.create_from_image(img)
		i += 1
	return null


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
