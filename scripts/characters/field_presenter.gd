extends Node2D
class_name FieldPresenter

var sheet: String = "ash_field"
var figure: Figure2D
var sprite: AnimatedSprite2D

static func attach(host: Node2D, sheet_name: String, kind: String, color: Color) -> FieldPresenter:
	var existing := host.get_node_or_null("Field") as FieldPresenter
	if existing:
		return existing
	var fp := FieldPresenter.new()
	fp.name = "Field"
	fp.sheet = sheet_name
	host.add_child(fp)
	fp.figure = Figure2D.attach(fp, kind, color)
	fp._try_sprite()
	return fp

func _try_sprite() -> void:
	var frames_path := "res://art/atlas/%s_frames.tres" % sheet
	if ResourceLoader.exists(frames_path):
		sprite = AnimatedSprite2D.new()
		sprite.sprite_frames = load(frames_path)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		add_child(sprite)
		sprite.play("idle")
		if figure:
			figure.visible = false
		return
	var tex := AtlasLib.tex(sheet, "idle_0")
	if tex:
		sprite = AnimatedSprite2D.new()
		var frames := SpriteFrames.new()
		frames.add_animation("idle")
		frames.add_frame("idle", tex)
		frames.set_animation_loop("idle", true)
		frames.set_animation_speed("idle", 8.0)
		sprite.sprite_frames = frames
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		add_child(sprite)
		sprite.play("idle")
		if figure:
			figure.visible = false

func play_gait(gait: String, facing_left: bool, world_y: float) -> void:
	var s := DepthRig.scale_at(world_y)
	scale = Vector2(s, s)
	DepthRig.shade(self, world_y)
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation(gait):
		if sprite.animation != gait:
			sprite.play(gait)
		sprite.flip_h = facing_left
	elif figure:
		figure.gait = gait
		figure.walking = gait != "idle"
		figure.set_facing(Vector2(-1.0 if facing_left else 1.0, 0.0))

func tick(delta: float) -> void:
	if figure and figure.visible:
		figure.tick(delta)
