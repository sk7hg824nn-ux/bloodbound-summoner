extends Control

@onready var name_edit: LineEdit = $Panel/NameEdit
@onready var male_btn: Button = $Panel/SexRow/Male
@onready var female_btn: Button = $Panel/SexRow/Female
@onready var preview: Label = $Panel/Preview

var _sex: GameState.Sex = GameState.Sex.MALE

func _ready() -> void:
	male_btn.pressed.connect(func(): _set_sex(GameState.Sex.MALE))
	female_btn.pressed.connect(func(): _set_sex(GameState.Sex.FEMALE))
	$Panel/Enter.pressed.connect(_enter)
	name_edit.text = "Ash"
	_refresh()

func _set_sex(sex: GameState.Sex) -> void:
	_sex = sex
	_refresh()

func _refresh() -> void:
	male_btn.modulate = Color(1.2, 1.2, 1.2) if _sex == GameState.Sex.MALE else Color(0.7, 0.7, 0.75)
	female_btn.modulate = Color(1.2, 1.2, 1.2) if _sex == GameState.Sex.FEMALE else Color(0.7, 0.7, 0.75)
	var n := name_edit.text.strip_edges()
	if n.is_empty():
		n = "Ash"
	preview.text = "%s  •  %s\nHe will not be told who he is." % [n, "Male" if _sex == GameState.Sex.MALE else "Female"]

func _process(_delta: float) -> void:
	_refresh()

func _enter() -> void:
	var n := name_edit.text.strip_edges()
	GameState.reset_run()
	PactSystem.pacted = {"kitsune": false, "dragoness": false, "bunny": false}
	PactSystem.bonds = {"kitsune": 0, "dragoness": 0, "bunny": 0}
	Relationships.reset()
	Campaign.reset()
	Bricks.reset()
	GameState.set_identity(n, _sex)
	get_tree().change_scene_to_file("res://scenes/world/Prologue.tscn")
