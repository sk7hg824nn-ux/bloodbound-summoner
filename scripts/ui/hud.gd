extends CanvasLayer
class_name HUD

@onready var hp_fill: ColorRect = $Root/Top/HpBar/Fill
@onready var hp_label: Label = $Root/Top/HpLabel
@onready var bond_label: Label = $Root/Top/BondLabel
@onready var loc_label: Label = $Root/Top/LocLabel
@onready var obj_label: Label = $Root/Top/ObjLabel
@onready var toast_label: Label = $Root/Toast
@onready var dialogue: Control = $Root/Dialogue
@onready var speaker_label: Label = $Root/Dialogue/Panel/Speaker
@onready var body_label: Label = $Root/Dialogue/Panel/Body
@onready var choices_box: VBoxContainer = $Root/Dialogue/Panel/Choices

var _lines: Array = []
var _choices: Array = []
var _line_i: int = 0
var _toast_time: float = 0.0

func _ready() -> void:
	dialogue.visible = false
	toast_label.modulate.a = 0.0
	EventBus.toast.connect(show_toast)
	EventBus.dialogue_requested.connect(open_dialogue)
	Campaign.objective_changed.connect(func(t): obj_label.text = t)
	refresh()

func _process(delta: float) -> void:
	if dialogue and not dialogue.visible and GameState.in_dialogue:
		GameState.in_dialogue = false
	if _toast_time > 0.0:
		_toast_time -= delta
		if _toast_time <= 0.0:
			toast_label.modulate.a = 0.0

func refresh() -> void:
	hp_label.text = "HP %d / %d" % [GameState.hp, GameState.max_hp]
	loc_label.text = GameState.location
	bond_label.text = GameState.era
	obj_label.text = Campaign.objective

func show_toast(message: String) -> void:
	toast_label.text = message
	toast_label.modulate.a = 1.0
	_toast_time = 2.4

func open_dialogue(speaker: String, lines: Array, choices: Array) -> void:
	GameState.in_dialogue = true
	_lines = lines.duplicate()
	_choices = choices.duplicate()
	_line_i = 0
	dialogue.visible = true
	speaker_label.text = speaker
	_render_line()

func _render_line() -> void:
	for c in choices_box.get_children():
		c.queue_free()
	if _line_i < _lines.size():
		body_label.text = str(_lines[_line_i])
		var tap := Button.new()
		tap.text = "Continue"
		tap.pressed.connect(_advance)
		choices_box.add_child(tap)
	else:
		body_label.text = ""
		for choice in _choices:
			var b := Button.new()
			b.text = str(choice.get("text", "..."))
			var cid := str(choice.get("id", ""))
			b.pressed.connect(_finish.bind(cid))
			choices_box.add_child(b)

func _advance() -> void:
	_line_i += 1
	_render_line()

func _finish(choice_id: String) -> void:
	dialogue.visible = false
	GameState.in_dialogue = false
	EventBus.dialogue_finished.emit(choice_id)
