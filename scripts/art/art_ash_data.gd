extends Object
## Thin router so older ArtAsh preloads still resolve.
## Real keyed JPEGs live in art_ash_pack_a.gd / art_ash_pack_b.gd
## and are loaded at runtime.

static func frame(name: String) -> String:
	if name == "idle_se" or name == "se":
		name = "three_quarter_front/idle/0"
	elif name == "idle_front":
		name = "front/idle/0"
	elif name == "idle_back":
		name = "back/idle/0"
	elif name == "idle_side":
		name = "right/idle/0"
	elif name == "walk_se_0":
		name = "three_quarter_front/walk/0"
	elif name == "walk_se_1":
		name = "three_quarter_front/walk/1"
	elif name == "run_se_0":
		name = "three_quarter_front/run/0"
	elif name == "run_se_1":
		name = "three_quarter_front/run/1"
	if ResourceLoader.exists("res://scripts/art/art_ash_pack_a.gd"):
		var a = load("res://scripts/art/art_ash_pack_a.gd")
		if a != null:
			var s = a.frame(name)
			if s != "":
				return s
	if ResourceLoader.exists("res://scripts/art/art_ash_pack_b.gd"):
		var b = load("res://scripts/art/art_ash_pack_b.gd")
		if b != null:
			var s2 = b.frame(name)
			if s2 != "":
				return s2
	return ""
