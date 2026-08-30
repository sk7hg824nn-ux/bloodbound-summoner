extends RefCounted
class_name HallArt
static var _cache: Texture2D

static func tex() -> Texture2D:
	if _cache:
		return _cache
	if ResourceLoader.exists("res://art/plates/hall.png"):
		_cache = load("res://art/plates/hall.png") as Texture2D
		if _cache:
			return _cache
	var img := Image.create(960, 540, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.20, 0.16, 0.18))
	# vanishing floor
	for y in range(200, 540):
		var t := float(y - 200) / 340.0
		var c := Color(0.24 + t * 0.10, 0.18 + t * 0.04, 0.18)
		for x in 960:
			img.set_pixel(x, y, c)
	# ceiling dark
	img.fill_rect(Rect2i(0, 0, 960, 200), Color(0.14, 0.12, 0.16))
	# back wall recedes
	img.fill_rect(Rect2i(280, 20, 400, 180), Color(0.18, 0.14, 0.16))
	img.fill_rect(Rect2i(360, 40, 240, 140), Color(0.28, 0.16, 0.16))
	# perspective rails toward 480,200
	for i in 8:
		var t := float(i) / 7.0
		var y := 220 + int(t * 300)
		var half := int(lerpf(80, 420, t))
		_hline(img, 480 - half, 480 + half, y, Color(0.32, 0.22, 0.22, 0.35))
	for i in 6:
		var shade := 0.36 - float(i) * 0.02
		img.fill_rect(Rect2i(8, 170 + i * 28, 150 + i * 8, 22), Color(shade, 0.20, 0.20))
		img.fill_rect(Rect2i(802 - i * 8, 170 + i * 28, 150 + i * 8, 22), Color(shade, 0.20, 0.20))
	_ring(img, Vector2i(480, 400), 90, Color(0.82, 0.16, 0.16))
	_ring(img, Vector2i(480, 400), 56, Color(0.62, 0.12, 0.14))
	_cache = ImageTexture.create_from_image(img)
	return _cache

static func _hline(img: Image, x0: int, x1: int, y: int, color: Color) -> void:
	if y < 0 or y >= img.get_height():
		return
	for x in range(maxi(0, x0), mini(img.get_width(), x1)):
		img.set_pixel(x, y, color)

static func _ring(img: Image, c: Vector2i, radius: int, color: Color) -> void:
	for a in 90:
		var ang := TAU * float(a) / 90.0
		for w in 4:
			var p := c + Vector2i(int(cos(ang) * float(radius + w)), int(sin(ang) * float(radius + w) * 0.48))
			if p.x >= 0 and p.y >= 0 and p.x < img.get_width() and p.y < img.get_height():
				img.set_pixel(p.x, p.y, color)
