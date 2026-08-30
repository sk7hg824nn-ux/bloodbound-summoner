extends Object
class_name ArtAsh
## Academy Ash field frames.
## File PNGs first. Packed keyed JPEGs second. Packs load at runtime.

static var _cache = {}
static var _packs = []
static var _packs_tried = false

static func tex(name: String = "idle_se") -> Texture2D:
	name = _alias(name)
	if _cache.has(name):
		return _cache[name]
	var from_file = _file_tex(name)
	if from_file != null:
		_cache[name] = from_file
		return from_file
	var packed = _packed_string(name)
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

static func clip(dir_name: String, gait: String) -> Array:
	var out = []
	var i = 0
	while i < 6:
		var key = "%s/%s/%d" % [dir_name, gait, i]
		var t = tex(key)
		if t == null:
			break
		out.append(t)
		i += 1
	return out

static func _alias(name: String) -> String:
	if name == "idle_se" or name == "se":
		return "three_quarter_front/idle/0"
	if name == "idle_front":
		return "front/idle/0"
	if name == "idle_back":
		return "back/idle/0"
	if name == "idle_side":
		return "right/idle/0"
	if name == "walk_se_0":
		return "three_quarter_front/walk/0"
	if name == "walk_se_1":
		return "three_quarter_front/walk/1"
	if name == "run_se_0":
		return "three_quarter_front/run/0"
	if name == "run_se_1":
		return "three_quarter_front/run/1"
	return name

static func has_art() -> bool:
	return tex("three_quarter_front/idle/0") != null or tex("front/idle/0") != null

static func _file_tex(name: String) -> Texture2D:
	var paths = [
		"res://art/characters/ash/academy/%s.png" % name,
		"res://art/characters/ash/%s.png" % name,
	]
	var p = 0
	while p < paths.size():
		var path = paths[p]
		if ResourceLoader.exists(path):
			var loaded = load(path)
			if loaded != null:
				return loaded
		if FileAccess.file_exists(path):
			var img := Image.new()
			if img.load(path) == OK:
				if img.get_format() != Image.FORMAT_RGBA8:
					img.convert(Image.FORMAT_RGBA8)
				_key_magenta(img)
				return ImageTexture.create_from_image(img)
		p += 1
	return null

static func _packed_string(name: String) -> String:
	_ensure_packs()
	var i = 0
	while i < _packs.size():
		var s = _packs[i].frame(name)
		if s != "":
			return s
		i += 1
	return ""

static func _ensure_packs() -> void:
	if _packs_tried:
		return
	_packs_tried = true
	var names = [
		"art_ash_pack_front.gd",
		"art_ash_pack_back.gd",
		"art_ash_pack_left.gd",
		"art_ash_pack_right.gd",
		"art_ash_pack_three_quarter_front.gd",
		"art_ash_pack_three_quarter_back.gd",
	]
	var i = 0
	while i < names.size():
		var path = "res://scripts/art/" + names[i]
		if ResourceLoader.exists(path):
			var packed = load(path)
			if packed != null:
				_packs.append(packed)
		i += 1

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
