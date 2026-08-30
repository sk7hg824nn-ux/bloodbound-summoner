extends Node2D
class_name FieldPresenter

var sheet = "ash_field"
var figure
var sprite
var _era = "academy"
const BASE = 0.30

static func attach(host, sheet_name, kind, color):
	var existing = host.get_node_or_null("Field")
	if existing != null:
		return existing
	var fp = FieldPresenter.new()
	fp.name = "Field"
	fp.sheet = sheet_name
	host.add_child(fp)
	fp.figure = Figure2D.attach(fp, kind, color)
	fp._build_sprite()
	return fp

func set_era(era) -> void:
	_era = era
	_build_sprite()

func _build_sprite() -> void:
	if sprite != null:
		sprite.queue_free()
		sprite = null
	var frames = SpriteFrames.new()
	frames.add_animation("idle")
	frames.add_animation("walk")
	frames.add_animation("run")
	frames.set_animation_loop("idle", true)
	frames.set_animation_loop("walk", true)
	frames.set_animation_loop("run", true)
	frames.set_animation_speed("idle", 6.0)
	frames.set_animation_speed("walk", 8.0)
	frames.set_animation_speed("run", 10.0)
	var child = (_era == "child" or _era == "memory")
	if child:
		var t = AshChildPack.tex("child_idle_se")
		if t != null:
			frames.add_frame("idle", t)
			frames.add_frame("walk", t)
			frames.add_frame("run", t)
	else:
		var idle = AshIdlePack.tex("idle_se")
		var front = AshIdlePack.tex("idle_front")
		var back = AshIdlePack.tex("idle_back")
		var w0 = AshWalkPack.tex("walk_se_0")
		var w1 = AshWalkPack.tex("walk_se_1")
		var r0 = AshWalkPack.tex("run_se_0")
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
		elif w0 != null:
			frames.add_frame("run", w0)
		# keep extras on the node for facing swaps
		set_meta("front", front)
		set_meta("back", back)
		set_meta("idle", idle)
	if frames.get_frame_count("idle") <= 0:
		if figure != null:
			figure.visible = true
		return
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	sprite.texture_filter = 1
	sprite.centered = true
	sprite.offset = Vector2(0, -18)
	sprite.play("idle")
	add_child(sprite)
	if figure != null:
		figure.visible = false

func play_gait(gait, facing_left, world_y, face_y = 0.0) -> void:
	var s = DepthRig.scale_at(world_y) * BASE
	scale = Vector2(s, s)
	DepthRig.shade(self, world_y)
	if sprite == null:
		if figure != null:
			figure.gait = gait
			figure.walking = gait != "idle"
			figure.set_facing(Vector2(-1.0 if facing_left else 1.0, 0.0))
		return
	var use = gait
	if sprite.sprite_frames.has_animation(use) == false:
		use = "idle"
	if sprite.animation != use:
		sprite.play(use)
	sprite.flip_h = facing_left
	if abs(face_y) > 0.55 and has_meta("front"):
		var tex = null
		if face_y < 0.0:
			tex = get_meta("back")
		else:
			tex = get_meta("front")
		if tex != null and gait == "idle":
			sprite.sprite_frames.set_frame("idle", 0, tex)

func tick(delta) -> void:
	if figure != null and figure.visible:
		figure.tick(delta)
