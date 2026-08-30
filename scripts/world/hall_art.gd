extends RefCounted
class_name HallArt
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
	img.fill_rect(Rect2i(0, 0, 960, 210), Color(0.09, 0.08, 0.11))
	img.fill_rect(Rect2i(0, 210, 960, 330), Color(0.13, 0.11, 0.13))
	img.fill_rect(Rect2i(380, 40, 200, 120), Color(0.10, 0.08, 0.10))
	img.fill_rect(Rect2i(430, 70, 100, 80), Color(0.16, 0.10, 0.10))
	for i in 6:
		img.fill_rect(Rect2i(20, 190 + i * 22, 150, 18), Color(0.22 - float(i) * 0.015, 0.14, 0.14))
		img.fill_rect(Rect2i(790, 190 + i * 22, 150, 18), Color(0.22 - float(i) * 0.015, 0.14, 0.14))
	img.fill_rect(Rect2i(80, 80, 36, 280), Color(0.18, 0.15, 0.16))
	img.fill_rect(Rect2i(844, 80, 36, 280), Color(0.18, 0.15, 0.16))
	var rng := RandomNumberGenerator.new()
	rng.seed = 77
	for _n in 120:
		img.set_pixel(rng.randi_range(0, 959), rng.randi_range(220, 530), Color(0.18, 0.14, 0.14, 0.55))
	_ring(img, Vector2i(480, 390), 78, Color(0.62, 0.12, 0.14))
	_ring(img, Vector2i(480, 390), 48, Color(0.50, 0.10, 0.12))
	_cache = ImageTexture.create_from_image(img)
	return _cache

static func _ring(img: Image, c: Vector2i, radius: int, color: Color) -> void:
	for a in 72:
		var ang := TAU * float(a) / 72.0
		for w in 3:
			var p := c + Vector2i(int(cos(ang) * float(radius + w)), int(sin(ang) * float(radius + w) * 0.55))
			if p.x >= 0 and p.y >= 0 and p.x < img.get_width() and p.y < img.get_height():
				img.set_pixel(p.x, p.y, color)
