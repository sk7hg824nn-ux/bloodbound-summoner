extends Node
class_name CutsceneDirector

signal finished
signal plate_changed(id: String)
var _beats: Array = []
var _i := 0
var _playing := false
var camera: Camera2DDirector
var stack: LayerStack
var plate: Sprite2D

func _ready() -> void:
	EventBus.dialogue_finished.connect(_on_line)

func play(beats: Array) -> void:
	_beats = beats
	_i = 0
	_playing = true
	GameState.in_dialogue = true
	if stack:
		stack.freeze()
	_step()

func _step() -> void:
	if not _playing:
		return
	if _i >= _beats.size():
		_playing = false
		GameState.in_dialogue = false
		if stack:
			stack.thaw()
		finished.emit()
		return
	var beat: Dictionary = _beats[_i]
	_i += 1
	var kind := String(beat.get("type", "say"))
	match kind:
		"plate":
			var id := String(beat.get("id", "black"))
			if plate:
				plate.texture = OriginArt.tex(id)
			plate_changed.emit(id)
			_step()
		"cam":
			if camera:
				camera.set_mode(beat.get("mode", Camera2DDirector.Mode.EXPLORE))
			_step()
		"toast":
			EventBus.toast.emit(String(beat.get("text", "")))
			_step()
		"mark":
			EventBus.toast.emit(String(beat.get("text", "")))
			_step()
		_:
			EventBus.dialogue_requested.emit(String(beat.get("speaker", "")), beat.get("lines", []), [{"id": "cs_next", "text": "Continue"}])

func _on_line(choice_id: String) -> void:
	if not _playing:
		return
	if choice_id == "cs_next" or choice_id == "":
		_step()
