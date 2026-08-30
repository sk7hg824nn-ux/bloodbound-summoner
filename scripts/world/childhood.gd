extends Node2D
## Playable prologue. Happiness first. Do not skip to the knife.

@onready var player: Player = $Entities/Player
@onready var touch: TouchControls = $TouchControls
@onready var camera: Camera2DDirector = $CameraDirector

var _near: Array[Interactable] = []
var _seen: Dictionary = {}
var _yard := Rect2(-20, 160, 1000, 560)


func _ready() -> void:
	player.add_to_group("player")
	player.display_name = GameState.player_name
	player.sync_hp_from_state()
	GameState.era = "child"
	player.apply_look("child")
	touch.set_kit("child")
	camera.set_target(player)
	camera.set_mode(Camera2DDirector.Mode.EXPLORE)
	_fence_yard()
	World25.compose($World, "village")
	touch.joystick_moved.connect(player.set_joystick)
	touch.attack_pressed.connect(func(): EventBus.toast.emit("Not here. Not yet."))
	touch.dodge_pressed.connect(func(): player.try_dodge())
	touch.ability_pressed.connect(func(): EventBus.toast.emit("The air is just air."))
	touch.interact_pressed.connect(_interact)
	player.interact_pressed.connect(_interact)
	EventBus.dialogue_finished.connect(_on_choice)
	for node in $World/Hotspots.get_children():
		if node is Interactable:
			node.body_entered.connect(_on_enter.bind(node))
			node.body_exited.connect(_on_exit.bind(node))
	Campaign.set_chapter("pro0_home")
	_say(Prologue.morning(GameState.player_name))


func _fence_yard() -> void:
	## Keep the child on the grass.
	var yard := _yard
	camera.set_bounds(yard)
	var wall := StaticBody2D.new()
	wall.collision_layer = 2
	wall.collision_mask = 0
	$World.add_child(wall)
	var thick := 40.0
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


func _physics_process(_delta: float) -> void:
	var pad := Vector2(18, 22)
	player.global_position = player.global_position.clamp(_yard.position + pad, _yard.end - pad)


func _on_enter(body: Node, spot: Interactable) -> void:
	if body == player and spot not in _near:
		_near.append(spot)
		EventBus.toast.emit(spot.prompt)


func _on_exit(body: Node, spot: Interactable) -> void:
	if body == player:
		_near.erase(spot)


func _interact() -> void:
	if GameState.in_dialogue:
		return
	if _near.is_empty():
		return
	_use(_near[_near.size() - 1].interact_id)


func _use(id: String) -> void:
	match id:
		"mother":
			_seen["mother"] = true
			camera.set_mode(Camera2DDirector.Mode.ROMANCE)
			if _ready_to_leave():
				_say(_leave_pack())
			elif Campaign.chapter_id == "pro2_truth" or (_seen.get("box", false) and _seen.get("creek", false)):
				Campaign.set_chapter("pro2_truth")
				_say(Prologue.discovery(GameState.player_name))
			else:
				_say(Prologue.after_hug())
		"creek":
			_seen["creek"] = true
			Campaign.set_chapter("pro1_signs")
			_say(Prologue.creek())
			_nudge_leave()
		"box":
			_seen["box"] = true
			Campaign.set_chapter("pro1_signs")
			_say(Prologue.box())
			_nudge_leave()
		"road":
			_seen["road"] = true
			if _ready_to_leave():
				_say(_leave_pack())
			else:
				_say(Prologue.watchers())
		_:
			EventBus.toast.emit("A good day. Keep it.")


func _say(pack: Dictionary) -> void:
	EventBus.dialogue_requested.emit(pack["speaker"], pack["lines"], pack["choices"])


func _on_choice(choice_id: String) -> void:
	match choice_id:
		"pro_hug", "pro_eat":
			_say(Prologue.after_hug())
		"pro_play":
			camera.set_mode(Camera2DDirector.Mode.EXPLORE)
			Campaign.set_objective("Walk the yard. The creek. The floorboard. The road.")
		"pro_noticed":
			EventBus.toast.emit("\"Fish are shy,\" she says. Too fast.")
			_maybe_truth()
		"pro_leave_box":
			EventBus.toast.emit("The board fits. The mark does not leave your eye.")
			_maybe_truth()
		"pro_ask_box":
			EventBus.toast.emit("\"Later. When you are older.\" She takes the lamp away.")
			_maybe_truth()
		"pro_road_ok":
			_maybe_truth()
		"pro_excited", "pro_scared":
			_say(Prologue.incomplete())
		"pro_night":
			Campaign.set_chapter("pro3_night")
			camera.set_mode(Camera2DDirector.Mode.BOSS)
			_say(Prologue.assassin())
		"pro_stay", "pro_freeze":
			_say(Prologue.fight())
		"pro_to_her":
			Campaign.set_chapter("pro4_last")
			camera.set_mode(Camera2DDirector.Mode.ROMANCE)
			_say(Prologue.last_words(GameState.player_name))
		"pro_wake":
			Campaign.set_chapter("pro5_wake")
			camera.punch(0.55)
			_flash()
			_say(Prologue.awakening())
		"pro_skip":
			Campaign.set_chapter("pro6_years")
			_say(Prologue.timeskip(GameState.player_name))
		"pro_academy":
			GameState.set_flag("prologue_done")
			GameState.set_flag("mother_dead")
			GameState.set_flag("saw_awakening")
			GameState.era = "academy"
			GameState.inventory = ["Academy Uniform", "Empty Summoning Focus"]
			GameState.location = "courtyard"
			get_tree().change_scene_to_file("res://scenes/world/Academy.tscn")


func _ready_to_leave() -> bool:
	return bool(_seen.get("mother") and _seen.get("creek") and _seen.get("box") and _seen.get("road"))


func _nudge_leave() -> void:
	if _ready_to_leave():
		Campaign.set_objective("Talk to Mother or the road. Let the years pass.")
		EventBus.toast.emit("The yard is finished. Talk to Mother or the road.")


func _leave_pack() -> Dictionary:
	return {
		"speaker": "The Years",
		"lines": [
			"You have seen the house, the creek, the box, and the road.",
			"The night they find you can play out. Or the years can close.",
		],
		"choices": [
			{"id": "pro_night", "text": "Stay for that night."},
			{"id": "pro_skip", "text": "Let the years pass."},
		],
	}


func _maybe_truth() -> void:
	if _seen.get("creek") and _seen.get("box"):
		Campaign.set_chapter("pro2_truth")
		Campaign.set_objective("Go back to your mother.")
		EventBus.toast.emit("She is waiting at the table.")
	_nudge_leave()


func _flash() -> void:
	var veil := ColorRect.new()
	veil.color = Color(0.55, 0.05, 0.08, 0.0)
	veil.set_anchors_preset(Control.PRESET_FULL_RECT)
	var layer := CanvasLayer.new()
	add_child(layer)
	layer.add_child(veil)
	var tw := create_tween()
	tw.tween_property(veil, "color:a", 0.55, 0.15)
	tw.tween_property(veil, "color:a", 0.0, 0.8)
	tw.tween_callback(layer.queue_free)
