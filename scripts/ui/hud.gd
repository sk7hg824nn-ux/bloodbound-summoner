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
var _quest_title: Label
var _quest_body: Label
var _map_dot: ColorRect

func _ready() -> void:
	dialogue.visible = false
	toast_label.modulate.a = 0.0
	_build_field_chrome()
	EventBus.toast.connect(show_toast)
	EventBus.dialogue_requested.connect(open_dialogue)
	EventBus.location_changed.connect(func(_id): refresh())
	Campaign.objective_changed.connect(func(t): _set_quest(t))
	refresh()

func _build_field_chrome() -> void:
	var root := $Root as Control
	if root == null or root.get_node_or_null("FieldChrome"):
		return
	var chrome := Control.new()
	chrome.name = "FieldChrome"
	chrome.set_anchors_preset(15)
	chrome.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(chrome)
	root.move_child(chrome, 0)
	var map := ColorRect.new()
	map.name = "MiniMap"
	map.color = Color(0.07, 0.09, 0.08, 0.78)
	map.set_anchors_preset(1)
	map.offset_left = -92.0
	map.offset_top = 10.0
	map.offset_right = -12.0
	map.offset_bottom = 90.0
	chrome.add_child(map)
	var ring := ColorRect.new()
	ring.color = Color(0.55, 0.48, 0.32, 0.55)
	ring.set_anchors_preset(15)
	ring.offset_left = 1.0
	ring.offset_top = 1.0
	ring.offset_right = -1.0
	ring.offset_bottom = -1.0
	map.add_child(ring)
	var inner := ColorRect.new()
	inner.color = Color(0.10, 0.14, 0.11, 0.92)
	inner.set_anchors_preset(15)
	inner.offset_left = 3.0
	inner.offset_top = 3.0
	inner.offset_right = -3.0
	inner.offset_bottom = -3.0
	map.add_child(inner)
	_map_dot = ColorRect.new()
	_map_dot.color = Color(0.85, 0.18, 0.20, 1)
	_map_dot.position = Vector2(36, 36)
	_map_dot.size = Vector2(6, 6)
	inner.add_child(_map_dot)
	var card := ColorRect.new()
	card.name = "QuestCard"
	card.color = Color(0.08, 0.07, 0.06, 0.82)
	card.set_anchors_preset(1)
	card.offset_left = -210.0
	card.offset_top = 96.0
	card.offset_right = -12.0
	card.offset_bottom = 148.0
	chrome.add_child(card)
	_quest_title = Label.new()
	_quest_title.text = "Current Quest"
	_quest_title.position = Vector2(8, 4)
	_quest_title.size = Vector2(180, 16)
	_quest_title.add_theme_font_size_override("font_size", 10)
	_quest_title.add_theme_color_override("font_color", Color(0.78, 0.72, 0.55, 1))
	card.add_child(_quest_title)
	_quest_body = Label.new()
	_quest_body.position = Vector2(8, 20)
	_quest_body.size = Vector2(186, 28)
	_quest_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_quest_body.add_theme_font_size_override("font_size", 11)
	_quest_body.add_theme_color_override("font_color", Color(0.92, 0.90, 0.86, 1))
	card.add_child(_quest_body)

func _process(delta: float) -> void:
	if dialogue and not dialogue.visible and GameState.in_dialogue and not GameState.in_cutscene:
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
	_set_quest(Campaign.objective)
	var top := $Root/Top
	if top:
		top.visible = GameState.era != "memory" and not GameState.in_cutscene
	var chrome := $Root.get_node_or_null("FieldChrome")
	if chrome:
		chrome.visible = GameState.era != "memory" and not GameState.in_cutscene

func _set_quest(text: String) -> void:
	if obj_label:
		obj_label.text = text
	if _quest_body:
		var t := text.strip_edges()
		if t.is_empty():
			t = "Attend the Summoning Examination"
		_quest_body.text = t

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
		if _choices.is_empty():
			_finish("")
			return
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
	if not GameState.in_cutscene:
		GameState.in_dialogue = false
	EventBus.dialogue_finished.emit(choice_id)
