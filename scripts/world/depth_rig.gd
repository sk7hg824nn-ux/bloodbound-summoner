extends RefCounted
class_name DepthRig
## Fake perspective on a 2D plane. No 3D nodes.
const HORIZON := 210.0
const NEAR_Y := 520.0
const FAR_SCALE := 0.72
const NEAR_SCALE := 1.18

static func scale_at(y: float) -> float:
	var t := clampf((y - HORIZON) / (NEAR_Y - HORIZON), 0.0, 1.0)
	return lerpf(FAR_SCALE, NEAR_SCALE, t)

static func apply(node: Node2D, y: float, facing_x: float = 1.0) -> void:
	var s := scale_at(y)
	node.scale = Vector2(facing_x * s, s)

static func shade(mod: CanvasItem, y: float) -> void:
	var t := clampf((y - HORIZON) / (NEAR_Y - HORIZON), 0.0, 1.0)
	var dim := lerpf(0.78, 1.0, t)
	mod.modulate = Color(dim, dim, dim, 1.0)
