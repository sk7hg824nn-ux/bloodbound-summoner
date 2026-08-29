extends Node2D

@onready var player: Player = $Entities/Player
@onready var touch: TouchControls = $TouchControls
@onready var camera: Camera2DDirector = $CameraDirector

func _ready() -> void:
	GameState.era = "academy"
	player.add_to_group("player")
	player.display_name = GameState.player_name
	player.sync_hp_from_state()
	player.apply_look("academy")
	touch.set_kit("academy")
	camera.set_target(player)
	camera.set_mode(Camera2DDirector.Mode.EXPLORE)
	camera.set_bounds(Rect2(-20, 160, 1220, 580))
	touch.joystick_moved.connect(player.set_joystick)
	touch.interact_pressed.connect(_talk)
	player.interact_pressed.connect(_talk)
	touch.attack_pressed.connect(func(): EventBus.toast.emit("Combat brick is not open."))
	touch.ability_pressed.connect(func(): EventBus.toast.emit("Pacts are not this brick."))
	touch.dodge_pressed.connect(func(): player.try_dodge())
	EventBus.toast.emit("Academy courtyard. Same body. Different clothes.")
	Campaign.set_objective("Walk. Confirm the era change. Combat comes later.")

func _talk() -> void:
	EventBus.toast.emit("Academy talk comes with later bricks.")
