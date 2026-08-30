extends Node
class_name CutsceneDirector

signal finished
signal plate_changed(id)
var _beats = []
var _i = 0
var _playing = false
var _busy = false
var camera
var stack
var plate
var actor
var world
var entities
var fade
var griffin
var crowd

func _ready() -> void:
	EventBus.dialogue_finished.connect(_on_line)
	_ensure_fade()

func _ensure_fade() -> void:
	if fade != null:
		return
	var layer = CanvasLayer.new()
	layer.layer = 80
	add_child(layer)
	fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	fade.set_anchors_preset(15)
	fade.mouse_filter = 2
	layer.add_child(fade)

func play(beats) -> void:
	_beats = beats
	_i = 0
	_playing = true
	_busy = false
	GameState.in_dialogue = true
	GameState.in_cutscene = true
	if stack != null:
		stack.freeze()
	if camera != null:
		camera.directed = true
	_step()

func abort() -> void:
	_end_film()

func _end_film() -> void:
	_playing = false
	_busy = false
	GameState.in_dialogue = false
	GameState.in_cutscene = false
	if stack != null:
		stack.thaw()
	if camera != null:
		camera.directed = false
		camera.set_mode(0)
	finished.emit()

func _step() -> void:
	if _playing == false or _busy:
		return
	if _i >= _beats.size():
		_end_film()
		return
	var beat = _beats[_i]
	_i += 1
	_run(beat)

func _run(beat) -> void:
	var kind = str(beat.get("type", "say"))
	if kind == "lock":
		GameState.in_dialogue = true
		GameState.in_cutscene = true
		_step()
	elif kind == "unlock":
		_step()
	elif kind == "wait":
		_busy = true
		get_tree().create_timer(float(beat.get("sec", 0.4))).timeout.connect(_resume)
	elif kind == "fade":
		_busy = true
		var tw = create_tween()
		tw.tween_property(fade, "color", Color(0, 0, 0, float(beat.get("a", 1.0))), float(beat.get("sec", 0.5)))
		tw.finished.connect(_resume)
	elif kind == "cam_named":
		if camera != null:
			var around = beat.get("around", Vector2(480, 320))
			if actor != null and beat.get("follow_actor", false):
				around = actor.global_position
			camera.named_shot(str(beat.get("shot", "medium")), around, float(beat.get("sec", 0.8)))
		_busy = true
		get_tree().create_timer(float(beat.get("sec", 0.8))).timeout.connect(_resume)
	elif kind == "cam_shot":
		if camera != null:
			camera.shot_to(beat.get("pos", Vector2(480, 320)), float(beat.get("zoom", 1.0)), float(beat.get("sec", 0.8)))
		_busy = true
		get_tree().create_timer(float(beat.get("sec", 0.8))).timeout.connect(_resume)
	elif kind == "cam":
		if camera != null:
			camera.set_mode(beat.get("mode", 0))
		_step()
	elif kind == "shake":
		if camera != null:
			camera.punch(float(beat.get("amt", 0.25)))
		_step()
	elif kind == "walk":
		var who = _who(str(beat.get("who", "ash")))
		if who != null:
			_busy = true
			var tw2 = create_tween()
			tw2.tween_property(who, "global_position", beat.get("to", who.global_position), float(beat.get("sec", 1.2)))
			tw2.finished.connect(_resume)
		else:
			_step()
	elif kind == "face":
		_step()
	elif kind == "spawn_griffin":
		_spawn_griffin(beat.get("at", Vector2(560, 400)))
		_step()
	elif kind == "spawn_crowd":
		_spawn_crowd()
		_step()
	elif kind == "react_crowd":
		_react_crowd(str(beat.get("mood", "cheer")))
		_step()
	elif kind == "react_griffin":
		_react_griffin(str(beat.get("mood", "fear")))
		_step()
	elif kind == "seal":
		_seal(bool(beat.get("on", true)), float(beat.get("heat", 1.0)))
		_step()
	elif kind == "spark":
		_spark(beat.get("at", Vector2(480, 420)))
		_step()
	elif kind == "plate":
		var pid = str(beat.get("id", "black"))
		if plate != null:
			plate.texture = World25.still(pid)
		plate_changed.emit(pid)
		_step()
	elif kind == "toast" or kind == "mark":
		EventBus.toast.emit(str(beat.get("text", "")))
		_step()
	else:
		_busy = true
		EventBus.dialogue_requested.emit(str(beat.get("speaker", "")), beat.get("lines", []), [{"id": "cs_next", "text": "Continue"}])

func _resume() -> void:
	_busy = false
	_step()

func _on_line(choice_id) -> void:
	if _playing == false or _busy == false:
		return
	if str(choice_id) == "cs_next" or str(choice_id) == "":
		_resume()

func _who(id):
	if id == "griffin":
		return griffin
	if id == "crowd":
		return crowd
	return actor

func _spawn_griffin(at) -> void:
	if griffin != null and is_instance_valid(griffin):
		griffin.queue_free()
	griffin = Griffin2D.new()
	var root = entities
	if root == null:
		root = self
	root.add_child(griffin)
	griffin.global_position = at

func _spawn_crowd() -> void:
	if crowd != null and is_instance_valid(crowd):
		return
	crowd = Node2D.new()
	crowd.name = "Crowd"
	var root2 = world
	if root2 == null:
		root2 = self
	root2.add_child(crowd)
	var i = 0
	while i < 10:
		var fig = Figure2D.new()
		fig.kind = "human"
		crowd.add_child(fig)
		fig._build()
		var px = 90.0
		if i >= 5:
			px = 820.0
		fig.position = Vector2(px + float(i % 5) * 22.0, 210.0 + float(i % 3) * 16.0)
		fig.scale = Vector2(0.55, 0.55)
		fig.modulate = Color(0.75, 0.72, 0.7)
		i += 1

func _react_crowd(mood) -> void:
	if crowd == null:
		return
	for c in crowd.get_children():
		var n = c
		var tw = create_tween()
		var bump = 3.0
		if mood == "cheer" or mood == "laugh":
			bump = 6.0
		var y0 = n.position.y
		tw.tween_property(n, "position:y", y0 - bump, 0.12)
		tw.tween_property(n, "position:y", y0, 0.18)

func _react_griffin(mood) -> void:
	if griffin == null:
		return
	if mood == "fear":
		var tw = create_tween()
		tw.tween_property(griffin, "global_position", griffin.global_position + Vector2(36, -8), 0.35)
		griffin.modulate = Color(1.0, 0.85, 0.85)
	else:
		griffin.modulate = Color(1, 1, 1)

func _seal(on, heat) -> void:
	if world == null:
		return
	var old = world.get_node_or_null("CineSeal")
	if old != null:
		old.queue_free()
	if on == false:
		return
	var line = Line2D.new()
	line.name = "CineSeal"
	line.width = 3.0 + heat * 2.0
	line.default_color = Color(0.85, 0.16, 0.18, 0.95)
	var pts = PackedVector2Array()
	var at = Vector2(480, 420)
	var i = 0
	while i < 36:
		var a = TAU * float(i) / 36.0
		pts.append(at + Vector2(cos(a), sin(a) * 0.55) * (42.0 + heat * 8.0))
		i += 1
	pts.append(pts[0])
	line.points = pts
	world.add_child(line)

func _spark(at) -> void:
	var p = CPUParticles2D.new()
	p.emitting = true
	p.one_shot = true
	p.amount = 18
	p.lifetime = 0.45
	p.direction = Vector2(0, -1)
	p.spread = 80.0
	p.initial_velocity_min = 20.0
	p.initial_velocity_max = 70.0
	p.gravity = Vector2(0, 40)
	p.color = Color(0.85, 0.22, 0.18)
	p.global_position = at
	add_child(p)
