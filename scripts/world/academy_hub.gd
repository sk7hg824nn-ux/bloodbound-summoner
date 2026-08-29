extends Node2D

@onready var player: Player = $Entities/Player
@onready var touch: TouchControls = $TouchControls
@onready var camera: Camera2DDirector = $CameraDirector
var _yard := Rect2(-20, 180, 1220, 540)
var _near: Array[Interactable] = []
var akari: Akari
var wolf: WolfSummon
var ring: PactRing
var ambush: WolfSummon
var _in_ring := false
var _in_ambush := false
var _waiting_walk := false
var _walk_from := Vector2.ZERO
var _strike_t := 0.0

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
	EventBus.toast.emit("The woods are west. That is where you call.")
	_objective()

func _objective() -> void:
	if PactSystem.is_pacted("kitsune"):
		Campaign.set_objective("She answered in the trees. The ring is east when you mean it.")
	else:
		Campaign.set_objective("Call in the wilderness. Not in their circle.")

func _spots() -> void:
	_make_spot("circle", "Examination Circle", "Step in.", Vector2(480, 420))
	_make_spot("woods", "The Woods", "Leave their eyes.", Vector2(80, 430))
	_make_spot("ring", "Beginner Ring", "Sand. Later.", Vector2(900, 470))

func _make_spot(id: String, title: String, prompt: String, pos: Vector2) -> void:
	var spot := Interactable.new()
	spot.interact_id = id
	spot.title = title
	spot.prompt = prompt
	spot.position = pos
	var shape := CollisionShape2D.new()
	var circ := CircleShape2D.new()
	circ.radius = 42.0
	shape.shape = circ
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
	if GameState.in_dialogue or _in_ring or _in_ambush:
		return
	if _near.is_empty():
		return
	match _near[_near.size() - 1].interact_id:
		"circle":
			EventBus.toast.emit("That slate is not where you call. The woods are.")
		"woods":
			if PactSystem.is_pacted("kitsune"):
				_say({"speaker": "Akari", "lines": ["\"You already almost died. The sand is that way if you insist on repeating it.\""], "choices": []})
			else:
				_say(FirstSummon.woods_call(GameState.player_name))
		"ring":
			if not PactSystem.is_pacted("kitsune"):
				EventBus.toast.emit("You have no pact.")
			else:
				_start_ring()

func _say(pack: Dictionary) -> void:
	EventBus.dialogue_requested.emit(pack["speaker"], pack["lines"], pack.get("choices", []))

func _on_choice(choice_id: String) -> void:
	match choice_id:
		"wd_call":
			_say(FirstSummon.woods_fail())
		"wd_walk":
			_waiting_walk = true
			_walk_from = player.global_position
			Campaign.set_objective("Walk away. You failed.")
			EventBus.toast.emit("Nothing answered. Leave.")
		"sm_done":
			EventBus.toast.emit("She is not a pet. Something opened anyway.")
			_objective()

func _begin_ambush() -> void:
	_waiting_walk = false
	_in_ambush = true
	_strike_t = 0.55
	camera.set_mode(Camera2DDirector.Mode.COMBAT)
	ambush = WolfSummon.new()
	ambush.display_name = "Whelp"
	$Entities.add_child(ambush)
	ambush.global_position = player.global_position + Vector2(80, -8)
	if ambush.label:
		ambush.label.text = "Whelp"
	EventBus.toast.emit("It moves. The strike is coming.")

func _resolve_arrival() -> void:
	if not _in_ambush:
		return
	_in_ambush = false
	if ambush and is_instance_valid(ambush):
		ambush.queue_free()
	ambush = null
	PactSystem.seal_akari()
	_spawn_akari()
	camera.set_mode(Camera2DDirector.Mode.EXPLORE)
	_say(FirstSummon.after_save())

func _spawn_akari() -> void:
	if akari and is_instance_valid(akari):
		return
	akari = Akari.new()
	$Entities.add_child(akari)
	akari.global_position = player.global_position + Vector2(-36, 6)

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
	Campaign.set_objective("PACT = lie. ATK = cut.")

func _atk() -> void:
	if _in_ambush or _waiting_walk:
		EventBus.toast.emit("You have no pact.")
		return
	if ring and _in_ring:
		ring.commit()
	elif not PactSystem.has_any():
		EventBus.toast.emit("You have no pact.")
	else:
		EventBus.toast.emit("The ring is east.")

func _pact_btn() -> void:
	if _in_ambush or _waiting_walk:
		EventBus.toast.emit("You have no pact.")
		return
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
	else:
		GameState.hp = max(1, GameState.max_hp)
		player.sync_hp_from_state()
		EventBus.toast.emit("Down. She hauls you off the sand.")

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
	if _waiting_walk and player.global_position.distance_to(_walk_from) > 70.0:
		_begin_ambush()
	if _in_ambush:
		_strike_t -= delta
		if _strike_t <= 0.0:
			_resolve_arrival()
