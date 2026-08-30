extends Object
class_name ArtAsh
## Illustrated Ash field frames.
## Tries res://art/characters/ash/<name>.png first.
## Falls back to the packed atlas so Xogot still renders
## Ash when PNG import is missing.

const Data = preload("res://scripts/art/art_ash_data.gd")

const FRAMES := {
	"idle_se": Rect2i(1, 1, 109, 256),
	"idle_front": Rect2i(111, 1, 128, 256),
	"idle_back": Rect2i(240, 1, 117, 256),
	"idle_side": Rect2i(358, 1, 111, 256),
	"walk_se_0": Rect2i(470, 1, 172, 256),
	"walk_se_1": Rect2i(643, 1, 152, 256),
	"run_se_0": Rect2i(796, 1, 186, 256),
	"run_se_1": Rect2i(1, 258, 147, 256),
	"child_idle_se": Rect2i(149, 258, 134, 200),
	"face_close": Rect2i(284, 258, 121, 180),
}

static var _booted: bool = false
static var _cache = {}
static var _atlas_img: Image = null

static func tex(name: String = "idle_se") -> Texture2D:
	if _cache.has(name):
		return _cache[name]
	var from_file = _file_tex(name)
	if from_file != null:
		_cache[name] = from_file
		return from_file
	_ensure_atlas()
	if _atlas_img == null:
		return null
	if FRAMES.has(name) == false:
		return null
	var r: Rect2i = FRAMES[name]
	var slice := _atlas_img.get_region(r)
	if slice == null or slice.is_empty():
		return null
	var t := ImageTexture.create_from_image(slice)
	_cache[name] = t
	return t

static func has_art() -> bool:
	return tex("idle_se") != null

static func _file_tex(name: String) -> Texture2D:
	var path := "res://art/characters/ash/%s.png" % name
	if ResourceLoader.exists(path):
		var loaded = load(path)
		if loaded is Texture2D:
			return loaded
	if FileAccess.file_exists(path):
		var img := Image.new()
		if img.load(path) == OK:
			return ImageTexture.create_from_image(img)
	return null

static func _ensure_atlas() -> void:
	if _booted:
		return
	_booted = true
	var packed := Data.raw()
	var raw := Marshalls.base64_to_raw(packed)
	if raw.is_empty():
		return
	var img := Image.new()
	if img.load_png_from_buffer(raw) != OK:
		return
	_atlas_img = img
