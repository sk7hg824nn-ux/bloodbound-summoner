extends Node2D

@onready var player: Player = $Entities/Player
@onready var touch: TouchControls = $TouchControls
@onready var camera: Camera2DDirector = $CameraDirector
var _yard := Rect2(-20, 180, 1220, 540)
var _near: Array[Interactable] = []
var akari: Akari
var wolf: WolfSummon
var ring: PactRing
var _in_ring := false

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
	_spots()
	touch.joystick_moved.connect(player.set_joystick)
	touch.interact_pressed.connect(_interact)
	player.interact_pressed.connect(_interact)
	touch.attack_pressed.connect(_atk)
	touch.ability_pressed.connect(_pact_btn)
	touch.dodge_pressed.connect(func(): player.try_dodge())
	EventBus.dialogue_finished.connect(_on_choice)
	EventBus.combat_ended.connect(_on_combat_ended)
	if PactSystem.is_pacted("kitsune"):
		_spawn_akari()
	EventBus.toast.emit("Academy courtyard. Foxwood is west. The ring is east.")
	if PactSystem.is_pacted("kitsune"):
		Campaign.set_objective("Take her to the beginner ring.")
	else:
		Campaign.set_objective("The circle was empty. Beg at Foxwood Gate.")

func _spots() -> void:
	_make_spot("foxwood", "Foxwood Gate", "Ask the trees.", Vector2(80, 430))
	_make_spot("ring", "Beginner Ring", "Step onto the sand.", Vector2(900, 470))

func _make_spot(id: String, title: String, prompt: String, pos: Vector2) -> void:
	var spot := Interactable.new()
	spot.interact_id = id
	spot.title = title
	spot.prompt = prompt
	spot.position = pos
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 42.0
	shape.shape = circle
	spot.add_child(shape)
	$World.add_child(spot)
	spot.body_entered.connect(_on_enter.bind(spot))
	spot.body_exited.connect(_on_exit.bind(spot))

func _on_enter(body: Node, spot: Interactable) -> void:
	if body == player and spot not in _near:
		_near.append(spot)
		EventBus.toast.emit(spot.prompt)

func _on_exit(body: Node, spot: Interactable) -> void:
	if body == player:
		_near.erase(spot)

func _interact() -> void:
	if GameState.in_dialogue or _in_ring:
		return
	if _near.is_empty():
		return
	match _near[_near.size() - 1].interact_id:
		"foxwood":
			if PactSystem.is_pacted("kitsune"):
				_say({"speaker": "Akari", "lines": ["\"You already spent your dignity. The ring is that way.\""], "choices": []})
			else:
				_say(Foxwood.arrive(GameState.player_name))
		"ring":
			if not PactSystem.is_pacted("kitsune"):
				EventBus.toast.emit("You have no pact.")
			else:
				_start_ring()

func _say(pack: Dictionary) -> void:
	EventBus.dialogue_requested.emit(pack["speaker"], pack["lines"], pack.get("choices", []))

func _on_choice(choice_id: String) -> void:
	match choice_id:
		"fw_call":
			_say(Foxwood.she_appears())
		"fw_beg":
			_say(Foxwood.beg_again())
		"fw_beg2":
			PactSystem.seal_akari()
			_spawn_akari()
			_say(Foxwood.seals())
			Campaign.set_objective("Take her to the beginner ring.")
		"fw_pride", "fw_empty":
			pass
		"fw_done":
			EventBus.toast.emit("Registered: Akari. Rank E. One tail. She does not smile.")

func _spawn_akari() -> void:
	if akari and is_instance_valid(akari):
		return
	akari = Akari.new()
	$Entities.add_child(akari)
	akari.global_position = player.global_position + Vector2(-40, 8)

func _start_ring() -> void:
	_in_ring = true
	GameState.in_combat = true
	camera.set_mode(Camera2DDirector.Mode.COMBAT)
	wolf = WolfSummon.new()
	$Entities.add_child(wolf)
	wolf.global_position = Vector2(980, 500)
	ring = PactRing.new()
	add_child(ring)
	ring.bind(player, akari, wolf)
	EventBus.combat_started.emit("beginner")
	EventBus.toast.emit("Call the lie. Let it bite the statue. Then cut.")
	Campaign.set_objective("PACT = lie. ATK = cut. Do not punch.")

func _atk() -> void:
	if ring and _in_ring:
		ring.commit()
	elif not PactSystem.has_any():
		EventBus.toast.emit("You have no pact.")
	else:
		EventBus.toast.emit("The ring is east.")

func _pact_btn() -> void:
	if ring and _in_ring:
		ring.call_lie()
	elif not PactSystem.has_any():
		EventBus.toast.emit("You have no pact.")
	else:
		EventBus.toast.emit("Save it for the sand.")

func _on_combat_ended(win: bool) -> void:
	_in_ring = false
	GameState.in_combat = false
	camera.set_mode(Camera2DDirector.Mode.EXPLORE)
	if wolf and is_instance_valid(wolf):
		wolf.queue_free()
	wolf = null
	if akari:
		akari.clear_lie()
		akari.hp = akari.max_hp
	if ring:
		ring.queue_free()
		ring = null
	if win:
		GameState.set_flag("first_ring")
		EventBus.toast.emit("The ledger writes a win. She yawns.")
		Campaign.set_objective("You fought because she answered. Walk the courtyard.")
	else:
		GameState.hp = max(1, GameState.max_hp)
		player.sync_hp_from_state()
		EventBus.toast.emit("Down. She hauls you off the sand. Again when you mean it.")

func _fence_yard() -> void:
	var yard := _yard
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

func _physics_process(delta: float) -> void:
	var pad := Vector2(18, 22)
	player.global_position = player.global_position.clamp(_yard.position + pad, _yard.end - pad)
	if akari and is_instance_valid(akari) and not _in_ring:
		akari.follow(player, delta)
	if ring and _in_ring:
		ring.tick(delta)
