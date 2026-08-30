extends Object
## Thin router. Packs load at runtime.

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
	var names = [
		"art_ash_pack_front.gd",
		"art_ash_pack_back.gd",
		"art_ash_pack_left.gd",
		"art_ash_pack_right.gd",
		"art_ash_pack_three_quarter_front.gd",
		"art_ash_pack_three_quarter_back.gd",
	]
	var i = 0
	while i < names.size():
		var path = "res://scripts/art/" + names[i]
		if ResourceLoader.exists(path):
			var p = load(path)
			if p != null:
				var s = p.frame(name)
				if s != "":
					return s
		i += 1
	return ""
