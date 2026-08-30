extends Object
class_name PaintedWorld

static func drape(world: Node2D, which: String, dest: Rect2) -> void:
	for c in world.get_children():
		if c is ColorRect:
			c.visible = false
	var root := Node2D.new()
	root.name = "PaintedWorld"
	root.z_index = -8
	world.add_child(root)
	world.move_child(root, 0)
	if which == "yard":
		_yard(root, dest)
	else:
		_academy(root, dest)

static func _rect(root: Node2D, r: Rect2, color: Color) -> void:
	var n := ColorRect.new()
	n.position = r.position
	n.size = r.size
	n.color = color
	root.add_child(n)

static func _poly(root: Node2D, pts: PackedVector2Array, color: Color) -> void:
	var n := Polygon2D.new()
	n.color = color
	n.polygon = pts
	root.add_child(n)

static func _yard(root: Node2D, dest: Rect2) -> void:
	_rect(root, Rect2(dest.position.x, dest.position.y - 220, dest.size.x, 260), Color(0.55, 0.66, 0.78))
	_rect(root, dest, Color(0.28, 0.42, 0.26))
	_rect(root, Rect2(dest.position.x + 40, dest.position.y + 280, dest.size.x - 80, 36), Color(0.45, 0.36, 0.22))
	_rect(root, Rect2(80, 200, 220, 160), Color(0.42, 0.28, 0.18))
	_poly(root, PackedVector2Array([Vector2(70, 200), Vector2(190, 110), Vector2(310, 200)]), Color(0.32, 0.18, 0.12))
	_rect(root, Rect2(170, 280, 36, 80), Color(0.22, 0.12, 0.10))
	_rect(root, Rect2(110, 230, 40, 36), Color(0.55, 0.62, 0.48))
	_rect(root, Rect2(230, 230, 40, 36), Color(0.55, 0.62, 0.48))
	_rect(root, Rect2(620, dest.position.y + 300, 280, 70), Color(0.22, 0.38, 0.42))
	_poly(root, PackedVector2Array([Vector2(820, 240), Vector2(860, 140), Vector2(900, 240)]), Color(0.16, 0.28, 0.16))
	_poly(root, PackedVector2Array([Vector2(40, 260), Vector2(80, 140), Vector2(120, 260)]), Color(0.18, 0.32, 0.16))

static func _academy(root: Node2D, dest: Rect2) -> void:
	_rect(root, Rect2(dest.position.x, dest.position.y - 220, dest.size.x, 260), Color(0.62, 0.70, 0.82))
	_rect(root, dest, Color(0.42, 0.42, 0.38))
	_rect(root, Rect2(40, 80, 280, 160), Color(0.36, 0.34, 0.46))
	_rect(root, Rect2(760, 360, 320, 200), Color(0.62, 0.52, 0.32))
	_rect(root, Rect2(430, 380, 120, 120), Color(0.50, 0.28, 0.26))
