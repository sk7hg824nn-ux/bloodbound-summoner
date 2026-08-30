extends Node2D
class_name Griffin2D
## Layered 2D griffin. Placeholder until atlas art.

func _ready() -> void:
	var shadow := _poly(Color(0, 0, 0, 0.35), PackedVector2Array([Vector2(-28, 18), Vector2(28, 18), Vector2(20, 24), Vector2(-20, 24)]))
	shadow.z_index = -2
	var wing_l := _poly(Color(0.62, 0.58, 0.52), PackedVector2Array([Vector2(-8, -6), Vector2(-48, -28), Vector2(-40, 8), Vector2(-10, 10)]))
	wing_l.z_index = -1
	var wing_r := _poly(Color(0.70, 0.66, 0.58), PackedVector2Array([Vector2(8, -6), Vector2(52, -30), Vector2(44, 10), Vector2(10, 10)]))
	var body := _poly(Color(0.72, 0.50, 0.22), PackedVector2Array([Vector2(-16, 16), Vector2(-18, -4), Vector2(0, -12), Vector2(18, -2), Vector2(16, 16)]))
	var head := _poly(Color(0.78, 0.74, 0.68), PackedVector2Array([Vector2(-4, -12), Vector2(-6, -28), Vector2(10, -30), Vector2(16, -18), Vector2(8, -10)]))
	var beak := _poly(Color(0.82, 0.55, 0.16), PackedVector2Array([Vector2(14, -20), Vector2(26, -16), Vector2(14, -14)]))
	var eye := _poly(Color(0.15, 0.12, 0.10), PackedVector2Array([Vector2(6, -22), Vector2(6, -25), Vector2(10, -25), Vector2(10, -22)]))
	var tw := create_tween().set_loops()
	tw.tween_property(wing_r, "position:y", -3.0, 0.7)
	tw.tween_property(wing_r, "position:y", 0.0, 0.7)

func _poly(color: Color, pts: PackedVector2Array) -> Polygon2D:
	var p := Polygon2D.new()
	p.color = color
	p.polygon = pts
	add_child(p)
	return p
