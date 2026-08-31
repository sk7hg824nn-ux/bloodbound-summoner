extends Object
class_name ArtAkari
## Akari field frames. File first. Runtime only.

static var _cache = {}


static func tex(name: String = "three_quarter_front/idle/0") -> Texture2D:
	name = _alias(name)
	if _cache.has(name):
		return _cache[name]
	var t = _file_tex(name)
	if t != null:
		_cache[name] = t
		return t
	var packed = ""
	if ResourceLoader.exists("res://scripts/art/art_akari_pack.gd"):
		var pack = load("res://scripts/art/art_akari_pack.gd")
		if pack != null and pack.has_method("frame"):
			packed = str(pack.frame(name))
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
	t = ImageTexture.create_from_image(img)
	_cache[name] = t
	return t


static func clip(dir_name: String, gait: String) -> Array:
	var out = []
	var i = 0
	while i < 6:
		var key = "%s/%s/%d" % [dir_name, gait, i]
		var t2 = tex(key)
		if t2 == null:
			break
		out.append(t2)
		i += 1
	return out


static func portrait(mood: String = "neutral") -> Texture2D:
	return _file_tex_any([
		"res://art/characters/akari/portrait/%s.jpg" % mood,
		"res://art/characters/akari/portrait/%s.png" % mood,
		"res://art/characters/akari/portrait/neutral.jpg",
	])


static func _alias(name: String) -> String:
	if name == "idle_se" or name == "se":
		return "three_quarter_front/idle/0"
	if name == "idle_front":
		return "front/idle/0"
	if name == "idle_back":
		return "back/idle/0"
	if name == "idle_side":
		return "right/idle/0"
	return name


static func _file_tex(name: String) -> Texture2D:
	return _file_tex_any([
		"res://art/characters/akari/academy/%s.jpg" % name,
		"res://art/characters/akari/academy/%s.png" % name,
		"res://art/characters/akari/%s.jpg" % name,
		"res://art/characters/akari/%s.png" % name,
	])


static func _file_tex_any(paths: Array) -> Texture2D:
	var p = 0
	while p < paths.size():
		var path = str(paths[p])
		if FileAccess.file_exists(path):
			var img := Image.new()
			if img.load(path) == OK:
				if img.get_format() != Image.FORMAT_RGBA8:
					img.convert(Image.FORMAT_RGBA8)
				_key_magenta(img)
				return ImageTexture.create_from_image(img)
		p += 1
	return null


static func _key_magenta(img: Image) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var y := 0
	while y < h:
		var x := 0
		while x < w:
			var c := img.get_pixel(x, y)
			var mag = c.r > 0.58 and c.b > 0.52 and c.g < 0.70 and (c.r + c.b) > (c.g * 2.0 + 0.08)
			if mag:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			x += 1
		y += 1
