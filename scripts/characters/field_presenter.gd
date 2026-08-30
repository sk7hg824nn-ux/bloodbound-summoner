extends Node2D
class_name FieldPresenter
## Illustrated 2.5D field body for an Actor.
## Depth comes from DepthRig (Y scale + shade). This node only
## swaps illustrated frames. Figure2D stays attached as fallback.

var sheet = "ash_field"
var figure
var sprite
var shadow
var _era = "academy"
var _pose = ""
var _last_dir = "se"
const BASE = 0.42

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
			if sprite.sprite_frames.has_animation("idle"):
				sprite.sprite_frames.set_frame("idle", 0, t)
				sprite.play("idle")

func _build_shadow() -> void:
	if shadow != null:
		return
	shadow = Polygon2D.new()
	shadow.name = "Shadow"
	shadow.color = Color(0, 0, 0, 0.38)
	shadow.polygon = PackedVector2Array([
		Vector2(-16, 6), Vector2(16, 6), Vector2(11, 12), Vector2(-11, 12)
	])
	shadow.z_index = -2
	add_child(shadow)

func _tex(name):
	return ArtAsh.tex(name)

func _build_sprite() -> void:
	if sprite != null:
		sprite.queue_free()
		sprite = null
	var frames = SpriteFrames.new()
	var clips = ["idle", "walk", "run", "dodge", "attack", "hit", "cast", "summon", "damage", "death"]
	var i = 0
	while i < clips.size():
		frames.add_animation(clips[i])
		frames.set_animation_loop(clips[i], clips[i] == "idle" or clips[i] == "walk" or clips[i] == "run")
		i += 1
	frames.set_animation_speed("idle", 6.0)
	frames.set_animation_speed("walk", 8.0)
	frames.set_animation_speed("run", 10.0)
	var child = (_era == "child" or _era == "memory")
	if child:
		var t = _tex("child_idle_se")
		if t != null:
			frames.add_frame("idle", t)
			frames.add_frame("walk", t)
			frames.add_frame("run", t)
	else:
		var idle = _tex("idle_se")
		var front = _tex("idle_front")
		var back = _tex("idle_back")
		var side = _tex("idle_side")
		var w0 = _tex("walk_se_0")
		var w1 = _tex("walk_se_1")
		var r0 = _tex("run_se_0")
		var r1 = _tex("run_se_1")
		if idle != null:
			frames.add_frame("idle", idle)
		if w0 != null:
			frames.add_frame("walk", w0)
		if w1 != null:
			frames.add_frame("walk", w1)
		elif idle != null:
			frames.add_frame("walk", idle)
		if r0 != null:
			frames.add_frame("run", r0)
		if r1 != null:
			frames.add_frame("run", r1)
		elif w0 != null:
			frames.add_frame("run", w0)
		set_meta("front", front)
		set_meta("back", back)
		set_meta("side", side)
		set_meta("idle", idle)
		set_meta("se", idle)
	var idle0 = null
	if frames.get_frame_count("idle") > 0:
		idle0 = frames.get_frame_texture("idle", 0)
	if idle0 != null:
		var extras = ["dodge", "attack", "hit", "cast", "summon", "damage", "death"]
		var e = 0
		while e < extras.size():
			if frames.get_frame_count(extras[e]) <= 0:
				frames.add_frame(extras[e], idle0)
			e += 1
	if frames.get_frame_count("idle") <= 0:
		if figure != null:
			figure.visible = true
		return
	sprite = AnimatedSprite2D.new()
	sprite.name = "Sprite"
	sprite.sprite_frames = frames
	sprite.texture_filter = 1
	sprite.centered = true
	sprite.offset = Vector2(0, -18)
	sprite.play("idle")
	add_child(sprite)
	if figure != null:
		figure.visible = false

func _dir_tex(face_y, gait):
	if gait != "idle":
		return null
	if abs(face_y) > 0.55:
		if face_y < 0.0:
			return get_meta("back") if has_meta("back") else null
		return get_meta("front") if has_meta("front") else null
	if abs(face_y) < 0.28 and has_meta("side"):
		return get_meta("side")
	return get_meta("idle") if has_meta("idle") else null

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
	var use = gait
	if sprite.sprite_frames.has_animation(use) == false:
		use = "idle"
	if _pose == "face" or _pose == "close":
		use = "idle"
	if sprite.animation != use:
		sprite.play(use)
	sprite.flip_h = facing_left
	if _pose == "":
		var swap = _dir_tex(face_y, gait)
		if swap != null and gait == "idle":
			sprite.sprite_frames.set_frame("idle", 0, swap)

func tick(delta) -> void:
	if figure != null and figure.visible:
		figure.tick(delta)
	elif sprite != null and sprite.animation == "idle":
		var b = sin(Time.get_ticks_msec() * 0.004) * 0.6
		sprite.position.y = b
