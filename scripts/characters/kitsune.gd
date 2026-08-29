extends Companion
class_name Kitsune
## Pact #1. Tsundere. Starts at one tail. Cannot sense the hidden bloodline.

func _ready() -> void:
	companion_id = "kitsune"
	follow_distance = 52.0
	attack_range = 46.0
	attack_cooldown_max = 0.72
	super._ready()
	EventBus.bond_changed.connect(_on_bond)


func _on_bond(id: String, _bond: int, tails: int) -> void:
	if id != "kitsune":
		return
	refresh_from_pact()
	_draw_tails(tails)


func _draw_tails(tails: int) -> void:
	var holder := get_node_or_null("Tails")
	if holder == null:
		return
	for c in holder.get_children():
		c.queue_free()
	for i in tails:
		var p := Polygon2D.new()
		var t := float(i) / max(tails, 1)
		var ang := lerp(-1.1, 1.1, t)
		p.color = Color(0.93, 0.55, 0.28, 0.95)
		p.polygon = PackedVector2Array([
			Vector2(0, 10),
			Vector2(-7, 18),
			Vector2(0, 34 + i * 2),
			Vector2(7, 18),
		])
		p.rotation = ang
		p.position = Vector2(0, 12)
		holder.add_child(p)
