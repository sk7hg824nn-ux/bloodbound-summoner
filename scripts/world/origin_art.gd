extends RefCounted
class_name OriginArt

static func tex(kind: String) -> Texture2D:
	var img := Image.create(844, 390, false, Image.FORMAT_RGBA8)
	match kind:
		"castle":
			img.fill(Color(0.07, 0.08, 0.16))
			img.fill_rect(Rect2i(0, 260, 844, 130), Color(0.10, 0.11, 0.14))
			img.fill_rect(Rect2i(280, 90, 280, 200), Color(0.16, 0.14, 0.18))
			img.fill_rect(Rect2i(390, 40, 60, 60), Color(0.18, 0.16, 0.20))
			img.fill_rect(Rect2i(330, 140, 18, 28), Color(0.72, 0.55, 0.22))
			img.fill_rect(Rect2i(490, 140, 18, 28), Color(0.72, 0.55, 0.22))
		"fire":
			img.fill(Color(0.12, 0.04, 0.03))
			img.fill_rect(Rect2i(0, 220, 844, 170), Color(0.18, 0.06, 0.04))
			img.fill_rect(Rect2i(200, 80, 420, 180), Color(0.55, 0.18, 0.06))
			img.fill_rect(Rect2i(300, 40, 220, 90), Color(0.72, 0.32, 0.08))
		"road":
			img.fill(Color(0.06, 0.07, 0.10))
			img.fill_rect(Rect2i(0, 240, 844, 150), Color(0.14, 0.12, 0.10))
			img.fill_rect(Rect2i(360, 240, 80, 150), Color(0.18, 0.15, 0.12))
		"house":
			img.fill(Color(0.22, 0.28, 0.34))
			img.fill_rect(Rect2i(0, 250, 844, 140), Color(0.20, 0.32, 0.18))
			img.fill_rect(Rect2i(320, 160, 200, 120), Color(0.36, 0.28, 0.20))
			img.fill_rect(Rect2i(300, 130, 240, 40), Color(0.28, 0.16, 0.12))
		"years":
			img.fill(Color(0.14, 0.16, 0.18))
			img.fill_rect(Rect2i(0, 200, 844, 190), Color(0.16, 0.22, 0.16))
		"black":
			img.fill(Color(0.02, 0.02, 0.03))
		_:
			img.fill(Color(0.04, 0.04, 0.06))
	return ImageTexture.create_from_image(img)
