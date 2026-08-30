extends Node
class_name CutsceneDirector

signal finished
signal plate_changed(id: String)
var _beats: Array = []
var _i := 0
var _playing := false
var _busy := false
var camera: Camera2DDirector
var stack: LayerStack
var plate: Sprite2D
var actor: Node2D
var world: Node2D
var entities: Node2D
var fade: ColorRect
var griffin: Node2D
var crowd: Node2D

func _ready() -> void:
	EventBus.dialogue_finished.connect(_on_line)
	_ensure_fade()

func _ensure_fade() -> void:
	if fade:
		return
	var layer := CanvasLayer.new()
	layer.layer = 80
	add_child(layer)
	fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 1)
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(fade)

func play(beats: Array) -> void:
	_beats = beats
	_i = 0
	_playing = true
	_busy = false
	GameState.in_dialogue = true
	if stack:
		stack.freeze()
	if camera:
		camera.directed = true
	_step()

func abort() -> void:
	_playing = false
	_busy = false
	GameState.in_dialogue = false
	if stack:
		stack.thaw()
	if camera:
		camera.directed = false
		camera.set_mode(Camera2DDirector.Mode.EXPLORE)

func _step() -> void:
	if not _playing or _busy:
		return
	if _i >= _beats.size():
		_playing = false
		GameState.in_dialogue = false
	if stack:
			stack.thaw()
		if camera:
			camera.directed = false
			camera.set_mode(Camera2DDirector.Mode.EXPLORE)
		finished.emit()
		return
	var beat: Dictionary = _beats[_i]
	_i += 1
	_run(beat)

func _run(beat: Dictionary) -> void:
	match String(beat.get("type", "say")):
		"lock":
			GameState.in_dialogue = true
			_step()
		"unlock":
			GameState.in_dialogue = false
			_step()
		"wait":
			_busy = true
			get_tree().create_timer(float(beat.get("sec", 0.4))).timeout.connect(_resume)
		"fade":
			_busy = true
			var tw := create_tween()
			tw.tween_property(fade, "color:a", float(beat.get("a", 1.0)), float(beat.get("sec", 0.5)))
			tw.finished.connect(_resume)
		"cam_shot":
			if camera:
				camera.shot_to(beat.get("pos", Vector2(480, 320)), float(beat.get("zoom", 1.0)), float(beat.get("sec", 0.8)))
			_busy = true
			get_tree().create_timer(float(beat.get("sec", 0.8))).timeout.connect(_resume)
		"cam":
			if camera:
				camera.set_mode(beat.get("mode", Camera2DDirector.Mode.EXPLORE))
			_step()
		"shake":
			if camera:
				camera.punch(float(beat.get("amt", 0.25)))
			_step()
		"walk":
			var who := _who(String(beat.get("who", "ash")))
			if who:
				_busy = true
				var tw2 := create_tween()
				tw2.tween_property(who, "global_position", beat.get("to", who.global_position), float(beat.get("sec", 1.2)))
				tw2.finished.connect(_resume)
			else:
				_step()
		"face":
			var w2 := _who(String(beat.get("who", "ash")))
			if w2 and w2 is Actor:
				(w2 as Actor).facing = beat.get("dir", Vector2.RIGHT)
			_step()
		"spawn_griffin":
			_spawn_griffin(beat.get("at", Vector2(560, 400)))
			_step()
		"spawn_crowd":
			_spawn_crowd()
			_step()
		"react_crowd":
			_react_crowd(String(beat.get("mood", "cheer")))
			_step()
		"react_griffin":
			_react_griffin(String(beat.get("mood", "idle")))
			_step()
		"seal":
			_seal(bool(beat.get("on", true)), float(beat.get("heat", 1.0)))
			_step()
		"spark":
			_spark(beat.get("at", Vector2(480, 420)))
			_step()
		"plate":
			var id := String(beat.get("id", "black"))
			if plate:
				plate.texture = World25.still(id)
			plate_changed.emit(id)
			_step()
		"toast":
			EventBus.toast.emit(String(beat.get("text", "")))
			_step()
		"mark":
			EventBus.toast.emit(String(beat.get("text", "")))
			_step()
		_:
			_busy = true
			EventBus.dialogue_requested.emit(String(beat.get("speaker", "")), beat.get("lines", []), [{"id": "cs_next", "text": "Continue"}])

func _resume() -> void:
	_busy = false
	_step()

func _on_line(choice_id: String) -> void:
	if not _playing or not _busy:
		return
	if choice_id == "cs_next" or choice_id == "":
		_resume()

func _who(id: String) -> Node2D:
	match id:
		"griffin":
			return griffin
		"crowd":
			return crowd
		_:
			return actor

func _spawn_griffin(at: Vector2) -> void:
	if griffin and is_instance_valid(griffin):
		griffin.queue_free()
	griffin = Griffin2D.new()
	griffin.position = at
	var root := entities if entities else self
	root.add_child(griffin)

func _spawn_crowd() -> void:
	if crowd and is_instance_valid(crowd):
		return
	crowd = Node2D.new()
	crowd.name = "Crowd"
var root2 := world if world else self
	root2.add_child(crowd)
	for i in 10:
		var fig := Figure2D.new()
		fig.kind = "human"
		crowd.add_child(fig)
		fig._build()
		var left := i < 5
		fig.position = Vector2((90.0 if left else 820.0) + float(i % 5) * 22.0, 210.0 + float(i % 3) * 16.0)
		fig.scale = Vector2(0.55, 0.55)
		fig.modulate = Color(0.75, 0.72, 0.7)

func _react_crowd(mood: String) -> void:
	if crowd == null:
		return
	for c in crowd.get_children():
		if c is Node2D:
			var n := c as Node2D
			var tw := create_tween()
			var bump := 6.0 if mood == "cheer" or mood == "laugh" else 3.0
			tw.tween_property(n, "position:y", n.position.y - bump, 0.12)
			tw.tween_property(n, "position:y", n.position.y, 0.18)

func _react_griffin(mood: String) -> void:
	if griffin == null:
		return
	match mood:
		"fear":
			var tw := create_tween()
			tw.tween_property(griffin, "position", griffin.position + Vector2(36, -8), 0.35)
			griffin.modulate = Color(1.0, 0.85, 0.85)
		"idle":
			griffin.modulate = Color.WHITE

func _seal(on: bool, heat: float) -> void:
	if world == null:
		return
	var old := world.get_node_or_null("CineSeal")
	if old:
		old.queue_free()
	if not on:
		return
	var line := Line2D.new()
	line.name = "CineSeal"
	line.width = 3.0 + heat * 2.0
	line.default_color = Color(0.85, 0.16, 0.18, 0.95)
	var pts := PackedVector2Array()
	var at := Vector2(480, 420)
	for i in 36:
		var a := TAU * float(i) / 36.0
		pts.append(at + Vector2(cos(a), sin(a) * 0.55) * (42.0 + heat * 8.0))
	pts.append(pts[0])
	line.points = pts
	world.add_child(line)

func _spark(at: Vector2) -> void:
	var p := CPUParticles2D.new()
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
	get_tree().create_timer(0.6).timeout.connect(p.queue_free)
