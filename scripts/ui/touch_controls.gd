extends CanvasLayer
class_name TouchControls

signal attack_pressed
signal dodge_pressed
signal ability_pressed
signal interact_pressed
signal joystick_moved(dir: Vector2)

@onready var joystick: VirtualJoystick = $Root/Joystick
@onready var atk: Button = $Root/Buttons/Attack
@onready var dodge: Button = $Root/Buttons/Dodge
@onready var ability: Button = $Root/Buttons/Ability
@onready var interact: Button = $Root/Buttons/Interact

func _ready() -> void:
	joystick.direction_changed.connect(func(d): joystick_moved.emit(d))
	atk.button_down.connect(func(): attack_pressed.emit())
	dodge.button_down.connect(func(): dodge_pressed.emit())
	ability.button_down.connect(func(): ability_pressed.emit())
	interact.pressed.connect(func(): interact_pressed.emit())

func set_kit(mode: String) -> void:
	var combat := mode != "child"
	atk.visible = combat
	ability.visible = combat
	dodge.visible = true
	interact.visible = true
