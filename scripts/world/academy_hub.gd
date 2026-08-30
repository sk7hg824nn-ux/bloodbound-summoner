extends Node2D

@onready var player = $Entities/Player
@onready var touch = $TouchControls
@onready var camera = $CameraDirector
var _yard = Rect2(-20, 180, 1220, 540)
var _near = []
var akari
var wolf
var ring
var ambush
var _in_ring = false
var _in_ambush = false
var _waiting_walk = false
var _walk_from = Vector2.ZERO
var _strike_t = 0.0
var _cut
var _stack

func _ready() -> void:
	GameState.era = "academy"
	player.add_to_group("player")
	player.display_name = GameState.player_name
	player.sync_hp_from_state()
	player.apply_look("academy")
	touch.set_kit("academy")
	camera.set_target(player)
	camera.set_mode(0)
	_fence_yard()
	_stack = World25.compose($World, "hall")
	_spots()
	_cut = CutsceneDirector.new()
	World25.bind_cut(_cut, camera, _stack)
	_cut.actor = player
	_cut.world = $World
	_cut.entities = $Entities
	add_child(_cut)
	_cut.finished.connect(_on_exam_done)
	touch.joystick_moved.connect(player.set_joystick)
	touch.interact_pressed.connect(_interact)
	player.interact_pressed.connect(_interact)
	touch.attack_pressed.connect(_atk)
	touch.ability_pressed.connect(_pact_btn)
	touch.dodge_pressed.connect(player.try_dodge)
	EventBus.dialogue_finished.connect(_on_choice)
	EventBus.combat_ended.connect(_on_combat_ended)
	if PactSystem.is_pacted("kitsune"):
		_spawn_akari()
	_objective()
	if GameState.has_flag("exam_failed") == false and PactSystem.is_pacted("kitsune") == false:
		player.global_position = Vector2(200, 430)
		_cut.play(ExamCinematic.beats(GameState.player_name))

func _objective() -> void:
	if PactSystem.is_pacted("kitsune"):
		Campaign.set_objective("She answered in the trees. The ring is east when you mean it.")
	elif GameState.has_flag("week_later"):
		Campaign.set_objective("The woods. No crowd. Circle and drop. Hands unsteady.")
	elif GameState.has_flag("exam_failed"):
		Campaign.set_objective("A week of being the joke.")
	else:
		Campaign.set_objective("Watch the hall. Someone else goes first.")

func _spots() -> void:
	_make_spot("circle", "Summoning Hall", "The bleachers are full.", Vector2(480, 420))
	_make_spot("woods", "The Woods", "Leave their eyes.", Vector2(80, 430))
	_make_spot("ring", "Beginner Ring", "Sand. Later.", Vector2(900, 470))

func _make_spot(id, title, prompt, pos) -> void:
	var spot = Interactable.new()
	spot.interact_id = id
	spot.title = title
	spot.prompt = prompt
	spot.position = pos
	var shape = CollisionShape2D.new()
	var circ = CircleShape2D.new()
	circ.radius = 42.0
	shape.shape = circ
	spot.add_child(shape)
	$World.add_child(spot)
	spot.body_entered.connect(_on_enter.bind(spot))
	spot.body_exited.connect(_on_exit.bind(spot))

func _on_enter(body, spot) -> void:
	if body == player and _near.find(spot) < 0:
		_near.append(spot)
		EventBus.toast.emit(spot.prompt)

func _on_exit(body, spot) -> void:
	if body == player:
		_near.erase(spot)

func _interact() -> void:
	if GameState.in_dialogue or _in_ring or _in_ambush:
		return
	if _near.is_empty():
		return
	var id = _near[_near.size() - 1].interact_id
	if id == "circle":
		if GameState.has_flag("exam_failed"):
			EventBus.toast.emit("They already wrote insufficient.")
		else:
			player.global_position = Vector2(200, 430)
			_cut.play(ExamCinematic.beats(GameState.player_name))
	elif id == "woods":
		if PactSystem.is_pacted("kitsune"):
			EventBus.toast.emit("The sand is east.")
		elif GameState.has_flag("week_later"):
			_say(FirstSummon.woods_call(GameState.player_name))
		elif GameState.has_flag("exam_failed"):
			EventBus.toast.emit("Not today. A week.")
		else:
			EventBus.toast.emit("The hall is still watching.")
	elif id == "ring":
		if PactSystem.is_pacted("kitsune") == false:
			EventBus.toast.emit("You have no pact.")
		else:
			_start_ring()

func _on_exam_done() -> void:
	GameState.set_flag("exam_failed")
	camera.directed = false
	camera.set_mode(0)
	_say(FirstSummon.week_later())
	_objective()

func _say(pack) -> void:
	EventBus.dialogue_requested.emit(pack["speaker"], pack["lines"], pack.get("choices", []))

func _on_choice(choice_id) -> void:
	var id = str(choice_id)
	if id == "wk_ok":
		GameState.set_flag("week_later")
		_objective()
		EventBus.toast.emit("Seven days. The woods are west.")
	elif id == "wd_call":
		_draw_rite(player.global_position)
		_say(FirstSummon.woods_fail())
	elif id == "wd_walk":
		_waiting_walk = true
		_walk_from = player.global_position
		Campaign.set_objective("Walk away. You failed.")
		EventBus.toast.emit("Nothing answered. Leave.")
	elif id == "sm_done":
		EventBus.toast.emit("She is not a pet. Something opened anyway.")
		_objective()

func _draw_rite(at) -> void:
	var line = Line2D.new()
	line.name = "RiteCircle"
	line.width = 3.0
	line.default_color = Color(0.62, 0.14, 0.16, 0.9)
	var pts = PackedVector2Array()
	var i = 0
	while i < 28:
		var a = TAU * float(i) / 28.0
		pts.append(at + Vector2(cos(a), sin(a)) * 38.0)
		i += 1
	pts.append(pts[0])
	line.points = pts
	$World.add_child(line)

func _begin_ambush() -> void:
	_waiting_walk = false
	_in_ambush = true
	_strike_t = 0.55
	camera.set_mode(1)
	ambush = WolfSummon.new()
	ambush.display_name = "Whelp"
	$Entities.add_child(ambush)
	ambush.global_position = player.global_position + Vector2(80, -8)
	EventBus.toast.emit("It moves. The strike is coming.")

func _resolve_arrival() -> void:
	if _in_ambush == false:
		return
	_in_ambush = false
	if ambush != null and is_instance_valid(ambush):
		ambush.queue_free()
	ambush = null
	PactSystem.seal_akari()
	_spawn_akari()
	camera.set_mode(0)
	_say(FirstSummon.after_save())

func _spawn_akari() -> void:
	if akari != null and is_instance_valid(akari):
		return
	akari = Akari.new()
	$Entities.add_child(akari)
	akari.global_position = player.global_position + Vector2(-36, 6)

func _start_ring() -> void:
	_in_ring = true
	GameState.in_combat = true
	camera.set_mode(1)
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
	if ring != null and _in_ring:
		ring.commit()
	elif PactSystem.has_any() == false:
		EventBus.toast.emit("You have no pact.")
	else:
		EventBus.toast.emit("The ring is east.")

func _pact_btn() -> void:
	if _in_ambush or _waiting_walk:
		EventBus.toast.emit("You have no pact.")
		return
	if ring != null and _in_ring:
		ring.call_lie()
	elif PactSystem.has_any() == false:
		EventBus.toast.emit("You have no pact.")
	else:
		EventBus.toast.emit("Save it for the sand.")

func _on_combat_ended(win) -> void:
	_in_ring = false
	GameState.in_combat = false
	camera.set_mode(0)
	if wolf != null and is_instance_valid(wolf):
		wolf.queue_free()
	wolf = null
	if akari != null:
		akari.clear_lie()
		akari.hp = akari.max_hp
	if ring != null:
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
	camera.set_bounds(_yard)
	var wall = StaticBody2D.new()
	wall.collision_layer = 2
	wall.collision_mask = 0
	$World.add_child(wall)
	var thick = 48.0
	var boxes = []
	boxes.append(Rect2(_yard.position.x - thick, _yard.position.y - thick, _yard.size.x + thick * 2.0, thick))
	boxes.append(Rect2(_yard.position.x - thick, _yard.end.y, _yard.size.x + thick * 2.0, thick))
	boxes.append(Rect2(_yard.position.x - thick, _yard.position.y, thick, _yard.size.y))
	boxes.append(Rect2(_yard.end.x, _yard.position.y, thick, _yard.size.y))
	for box in boxes:
		var shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = box.size
		shape.shape = rect
		shape.position = box.get_center()
		wall.add_child(shape)

func _physics_process(delta) -> void:
	if GameState.in_dialogue == false and GameState.in_cutscene == false:
		var pad = Vector2(18, 22)
		player.global_position = player.global_position.clamp(_yard.position + pad, _yard.end - pad)
	if akari != null and is_instance_valid(akari) and _in_ring == false:
		akari.follow(player, delta)
	if ring != null and _in_ring:
		ring.tick(delta)
	if _waiting_walk and player.global_position.distance_to(_walk_from) > 70.0:
		_begin_ambush()
	if _in_ambush:
		_strike_t -= delta
		if _strike_t <= 0.0:
			_resolve_arrival()
