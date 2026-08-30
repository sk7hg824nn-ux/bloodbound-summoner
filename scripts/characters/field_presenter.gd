extends Node2D
class_name FieldPresenter
## Illustrated 2.5D field body.
## Directional state picks a unique view. DepthRig handles Y scale.

var sheet = "ash_field"
var figure
var sprite
var shadow
var _era = "academy"
var _pose = ""
var _dir = "three_quarter_front"
var _gait = "idle"
const BASE = 0.62

const DIRS = [
	"front",
	"back",
	"left",
	"right",
	"three_quarter_front",
	"three_quarter_back",
]

static func attach(host, sheet_name, kind, color):
	var existing = host.get_node_or_null("Field")
	if existing != null:
		return existing
	var fp = FieldPresenter.new()
	fp.name = "Field"
	fp.sheet = sheet_name
	host.add_child(fp)
	fp.figure = Figure2D.attach(fp, kind, color)
	fp._build_shadow()
	fp._build_sprite()
	return fp

func set_era(era) -> void:
	_era = era
	_build_sprite()

func set_pose(pose) -> void:
	_pose = str(pose)
	if sprite == null:
		return
	if _pose == "face" or _pose == "close":
		var t = ArtAsh.tex("face_close")
		if t != null and sprite.sprite_frames:
			if sprite.sprite_frames.has_animation("idle_front"):
				sprite.sprite_frames.set_frame("idle_front", 0, t)
				sprite.play("idle_front")

func _build_shadow() -> void:
	if shadow != null:
		return
	shadow = Polygon2D.new()
	shadow.name = "Shadow"
	shadow.color = Color(0, 0, 0, 0.38)
	shadow.polygon = PackedVector2Array([
		Vector2(-22, 6), Vector2(22, 6), Vector2(16, 14), Vector2(-16, 14)
	])
	shadow.z_index = -2
	add_child(shadow)

func _anim_name(gait, dir_name) -> String:
	return "%s_%s" % [gait, dir_name]

func _build_sprite() -> void:
	if sprite != null:
		sprite.queue_free()
		sprite = null
	var frames = SpriteFrames.new()
	var child = (_era == "child" or _era == "memory")
	var first = null
	if child:
		frames.add_animation("idle_front")
		frames.set_animation_loop("idle_front", true)
		frames.set_animation_speed("idle_front", 6.0)
		var t = ArtAsh.tex("child_idle_se")
		if t != null:
			frames.add_frame("idle_front", t)
			first = t
	else:
		var d = 0
		while d < DIRS.size():
			var dir_name = DIRS[d]
			var gaits = ["idle", "walk", "run"]
			var g = 0
			while g < gaits.size():
				var gait = gaits[g]
				var clip = ArtAsh.clip(dir_name, gait)
				if clip.is_empty() and gait != "idle":
					clip = ArtAsh.clip(dir_name, "idle")
				if clip.is_empty():
					clip = ArtAsh.clip("three_quarter_front", gait)
				if clip.is_empty():
					clip = ArtAsh.clip("three_quarter_front", "idle")
				var an = _anim_name(gait, dir_name)
				frames.add_animation(an)
				frames.set_animation_loop(an, true)
				var spd = 6.0
				if gait == "walk":
					spd = 8.0
				elif gait == "run":
					spd = 10.0
				frames.set_animation_speed(an, spd)
				var i = 0
				while i < clip.size():
					frames.add_frame(an, clip[i])
					if first == null:
						first = clip[i]
					i += 1
				g += 1
			d += 1
	var extras = ["dodge", "attack", "hit", "cast", "summon", "damage", "death"]
	var e = 0
	while e < extras.size():
		frames.add_animation(extras[e])
		if first != null:
			frames.add_frame(extras[e], first)
		e += 1
	if first == null:
		if figure != null:
			figure.visible = true
		return
	sprite = AnimatedSprite2D.new()
	sprite.name = "Sprite"
	sprite.sprite_frames = frames
	sprite.texture_filter = 1
	sprite.centered = true
	var foot = -float(first.get_height()) * 0.48
	sprite.offset = Vector2(0, foot)
	var start = "idle_three_quarter_front"
	if frames.has_animation(start) == false:
		start = "idle_front"
	sprite.play(start)
	add_child(sprite)
	if figure != null:
		figure.visible = false

func resolve_dir(facing_left, face_y) -> String:
	if face_y <= -0.58:
		return "back"
	if face_y >= 0.58:
		return "front"
	if abs(face_y) <= 0.32:
		if facing_left:
			return "left"
		return "right"
	if face_y < 0.0:
		return "three_quarter_back"
	return "three_quarter_front"

func play_gait(gait, facing_left, world_y, face_y = 0.0) -> void:
	var s = DepthRig.scale_at(world_y) * BASE
	if _era == "child" or _era == "memory":
		s *= 0.78
	scale = Vector2(s, s)
	DepthRig.shade(self, world_y)
	if sprite == null:
		if figure != null:
			figure.gait = gait
			figure.walking = gait != "idle"
			figure.set_facing(Vector2(-1.0 if facing_left else 1.0, face_y))
			DepthRig.apply(figure, world_y, -1.0 if facing_left else 1.0)
		return
	if _pose == "face" or _pose == "close":
		if sprite.animation != "idle_front":
			sprite.play("idle_front")
		return
	var use_gait = gait
	if use_gait != "idle" and use_gait != "walk" and use_gait != "run":
		if sprite.sprite_frames.has_animation(use_gait):
			if sprite.animation != use_gait:
				sprite.play(use_gait)
			return
		use_gait = "idle"
	_dir = resolve_dir(facing_left, face_y)
	_gait = use_gait
	var an = _anim_name(use_gait, _dir)
	if sprite.sprite_frames.has_animation(an) == false:
		an = _anim_name("idle", _dir)
	if sprite.sprite_frames.has_animation(an) == false:
		an = "idle_three_quarter_front"
	if sprite.animation != an:
		sprite.play(an)
	sprite.flip_h = false

func tick(_delta) -> void:
	if figure != null and figure.visible:
		figure.tick(_delta)
	elif sprite != null and _gait == "idle":
		var b = sin(Time.get_ticks_msec() * 0.004) * 0.6
		sprite.position.y = b
