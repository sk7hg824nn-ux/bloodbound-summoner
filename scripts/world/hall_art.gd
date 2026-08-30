extends RefCounted
class_name HallArt
## Runtime painted plate. Optional res://art/hall.png overrides.
static var _cache: Texture2D

static func tex() -> Texture2D:
	if _cache:
		return _cache
	if ResourceLoader.exists("res://art/hall.png"):
		_cache = load("res://art/hall.png") as Texture2D
		if _cache:
			return _cache
	var img := Image.create(960, 540, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.07, 0.06, 0.08))
	_fill(img, Rect2i(0, 0, 960, 210), Color(0.09, 0.08, 0.11))
	_fill(img, Rect2i(0, 210, 960, 330), Color(0.13, 0.11, 0.13))
	_fill(img, Rect2i(380, 40, 200, 120), Color(0.10, 0.08, 0.10))
	_fill(img, Rect2i(430, 70, 100, 80), Color(0.16, 0.10, 0.10))
	for i in 6:
		_fill(img, Rect2i(20, 190 + i * 22, 150, 18), Color(0.22 - i * 0.015, 0.14, 0.14))
		_fill(img, Rect2i(790, 190 + i * 22, 150, 18), Color(0.22 - i * 0.015, 0.14, 0.14))
	_fill(img, Rect2i(80, 80, 36, 280), Color(0.18, 0.15, 0.16))
	_fill(img, Rect2i(844, 80, 36, 280), Color(0.18, 0.15, 0.16))
	var rng := RandomNumberGenerator.new()
	rng.seed = 77
	for _n in 180:
		var x := rng.randi_range(0, 959)
		var y := rng.randi_range(220, 530)
		img.set_pixel(x, y, Color(0.18, 0.14, 0.14, 0.5))
	_ring(img, Vector2i(480, 390), 78, Color(0.62, 0.12, 0.14))
	_ring(img, Vector2i(480, 390), 48, Color(0.50, 0.10, 0.12))
	_cache = ImageTexture.create_from_image(img)
	return _cache

static func _fill(img: Image, r: Rect2i, color: Color) -> void:
	for y in range(r.position.y, r.end.y):
		for x in range(r.position.x, r.end.x):
			if x >= 0 and y >= 0 and x < img.get_width() and y < img.get_height():
				img.set_pixel(x, y, color)

static func _ring(img: Image, c: Vector2i, radius: int, color: Color) -> void:
	for a in 72:
		var ang := TAU * float(a) / 72.0
		for w in 3:
			var p := c + Vector2i(int(cos(ang) * (radius + w)), int(sin(ang) * (radius + w) * 0.55))
			if p.x >= 0 and p.y >= 0 and p.x < img.get_width() and p.y < img.get_height():
				img.set_pixel(p.x, p.y, color)
