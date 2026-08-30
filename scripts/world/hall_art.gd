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
	img.fill(Color(0.18, 0.14, 0.16))
	img.fill_rect(Rect2i(0, 0, 960, 200), Color(0.22, 0.18, 0.24))
	img.fill_rect(Rect2i(0, 200, 960, 340), Color(0.28, 0.22, 0.24))
	img.fill_rect(Rect2i(360, 30, 240, 130), Color(0.20, 0.16, 0.18))
	img.fill_rect(Rect2i(420, 60, 120, 90), Color(0.38, 0.22, 0.20))
	for i in 6:
		var shade := 0.34 - float(i) * 0.02
		img.fill_rect(Rect2i(16, 180 + i * 24, 170, 20), Color(shade, 0.20, 0.20))
		img.fill_rect(Rect2i(774, 180 + i * 24, 170, 20), Color(shade, 0.20, 0.20))
	img.fill_rect(Rect2i(70, 70, 40, 300), Color(0.32, 0.26, 0.26))
	img.fill_rect(Rect2i(850, 70, 40, 300), Color(0.32, 0.26, 0.26))
	_ring(img, Vector2i(480, 390), 80, Color(0.78, 0.16, 0.18))
	_ring(img, Vector2i(480, 390), 50, Color(0.62, 0.12, 0.14))
	_cache = ImageTexture.create_from_image(img)
	return _cache

static func _ring(img: Image, c: Vector2i, radius: int, color: Color) -> void:
	for a in 80:
		var ang := TAU * float(a) / 80.0
		for w in 4:
			var p := c + Vector2i(int(cos(ang) * float(radius + w)), int(sin(ang) * float(radius + w) * 0.55))
			if p.x >= 0 and p.y >= 0 and p.x < img.get_width() and p.y < img.get_height():
				img.set_pixel(p.x, p.y, color)
