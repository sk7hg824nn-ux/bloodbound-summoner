extends Object
## Joins packed hall halves. No class_name. No preload.

static func plate() -> String:
	var a = _pack("res://scripts/art/art_hall_a.gd")
	var b = _pack("res://scripts/art/art_hall_b.gd")
	return a + b

static func _pack(path: String) -> String:
	if ResourceLoader.exists(path) == false:
		return ""
	var scr = load(path)
	if scr == null:
		return ""
	if scr.has_method("pack"):
		return str(scr.pack())
	return ""
