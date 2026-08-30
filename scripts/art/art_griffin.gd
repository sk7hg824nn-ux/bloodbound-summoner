extends Object
class_name ArtGriffin

const Data = preload("res://scripts/art/art_griffin_data.gd")
static var _cache: Texture2D

static func tex() -> Texture2D:
	if _cache:
		return _cache
	if ResourceLoader.exists("res://art/characters/griffin/idle.png"):
		_cache = load("res://art/characters/griffin/idle.png") as Texture2D
		if _cache:
			return _cache
	var packed = Data.frame()
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
	_cache = ImageTexture.create_from_image(img)
	return _cache

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
