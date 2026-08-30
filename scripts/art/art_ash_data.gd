extends Object
## Packed Ash field atlas. No class_name (Xogot cache).
const C0 = preload("res://scripts/art/art_ash_p0.gd")
const C1 = preload("res://scripts/art/art_ash_p1.gd")
const C2 = preload("res://scripts/art/art_ash_p2.gd")
const C3 = preload("res://scripts/art/art_ash_p3.gd")
const C4 = preload("res://scripts/art/art_ash_p4.gd")
const C5 = preload("res://scripts/art/art_ash_p5.gd")

static func raw() -> String:
	return C0.s() + C1.s() + C2.s() + C3.s() + C4.s() + C5.s()
