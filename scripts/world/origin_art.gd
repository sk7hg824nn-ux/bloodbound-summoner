extends RefCounted
class_name OriginArt

static func tex(kind: String) -> Texture2D:
	var img := Image.create(844, 390, false, Image.FORMAT_RGBA8)
	match kind:
		"castle":
			img.fill(Color(0.12, 0.14, 0.28))
			img.fill_rect(Rect2i(0, 250, 844, 140), Color(0.16, 0.16, 0.20))
			img.fill_rect(Rect2i(260, 80, 320, 200), Color(0.28, 0.24, 0.32))
			img.fill_rect(Rect2i(380, 30, 80, 70), Color(0.32, 0.28, 0.36))
			img.fill_rect(Rect2i(310, 130, 22, 32), Color(0.85, 0.68, 0.28))
			img.fill_rect(Rect2i(510, 130, 22, 32), Color(0.85, 0.68, 0.28))
		"fire":
			img.fill(Color(0.28, 0.08, 0.05))
			img.fill_rect(Rect2i(0, 210, 844, 180), Color(0.36, 0.10, 0.06))
			img.fill_rect(Rect2i(180, 70, 480, 200), Color(0.78, 0.28, 0.08))
			img.fill_rect(Rect2i(280, 20, 280, 110), Color(0.92, 0.48, 0.12))
		"road":
			img.fill(Color(0.10, 0.12, 0.16))
			img.fill_rect(Rect2i(0, 230, 844, 160), Color(0.28, 0.22, 0.16))
			img.fill_rect(Rect2i(350, 230, 140, 160), Color(0.36, 0.28, 0.18))
		"house":
			img.fill(Color(0.36, 0.48, 0.58))
			img.fill_rect(Rect2i(0, 240, 844, 150), Color(0.28, 0.46, 0.24))
			img.fill_rect(Rect2i(300, 150, 240, 130), Color(0.52, 0.38, 0.26))
			img.fill_rect(Rect2i(280, 118, 280, 42), Color(0.40, 0.22, 0.16))
		"years":
			img.fill(Color(0.30, 0.34, 0.38))
			img.fill_rect(Rect2i(0, 200, 844, 190), Color(0.26, 0.38, 0.24))
		"black":
			img.fill(Color(0.02, 0.02, 0.03))
		_:
			img.fill(Color(0.08, 0.08, 0.10))
	return ImageTexture.create_from_image(img)
