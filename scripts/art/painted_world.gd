extends Object
class_name PaintedWorld

static func drape(world: Node2D, which: String, dest: Rect2) -> void:
	var tex: Texture2D = ArtYard.tex() if which == "yard" else ArtAcademy.tex()
	if tex == null:
		return
	for c in world.get_children():
		if c is ColorRect:
			c.visible = false
	var spr := world.get_node_or_null("PaintedWorld") as Sprite2D
	if spr == null:
		spr = Sprite2D.new()
		spr.name = "PaintedWorld"
		world.add_child(spr)
		world.move_child(spr, 0)
	spr.texture = tex
	spr.centered = false
	spr.position = dest.position
	spr.scale = Vector2(dest.size.x / float(tex.get_width()), dest.size.y / float(tex.get_height()))
	spr.z_index = -8
