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
	_fence_yard()
	touch.joystick_moved.connect(player.set_joystick)
	touch.interact_pressed.connect(_talk)
	player.interact_pressed.connect(_talk)
	touch.attack_pressed.connect(func(): EventBus.toast.emit("Combat brick is not open."))
	touch.ability_pressed.connect(func(): EventBus.toast.emit("Pacts are not this brick."))
	touch.dodge_pressed.connect(func(): player.try_dodge())
	EventBus.toast.emit("Academy courtyard. Same body. Different clothes.")
	Campaign.set_objective("Walk. Confirm the era change. Combat comes later.")

func _fence_yard() -> void:
	var yard := Rect2(-20, 180, 1220, 540)
	camera.set_bounds(yard)
	var wall := StaticBody2D.new()
	wall.collision_layer = 2
	wall.collision_mask = 0
	$World.add_child(wall)
	var thick := 48.0
	var boxes: Array[Rect2] = [
		Rect2(yard.position.x - thick, yard.position.y - thick, yard.size.x + thick * 2.0, thick),
		Rect2(yard.position.x - thick, yard.end.y, yard.size.x + thick * 2.0, thick),
		Rect2(yard.position.x - thick, yard.position.y, thick, yard.size.y),
		Rect2(yard.end.x, yard.position.y, thick, yard.size.y),
	]
	for box in boxes:
		var shape := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = box.size
		shape.shape = rect
		shape.position = box.get_center()
		wall.add_child(shape)

func _talk() -> void:
	EventBus.toast.emit("Academy talk comes with later bricks.")
