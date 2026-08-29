extends Actor
class_name Player

signal attack_fired(origin: Vector2, facing: Vector2)
signal dodge_used
signal ability_used
signal interact_pressed

var joystick_dir: Vector2 = Vector2.ZERO
var attack_cooldown: float = 0.0
var dodge_cooldown: float = 0.0
var dodge_time: float = 0.0
var dodge_dir: Vector2 = Vector2.RIGHT

const DODGE_CD := 0.85
const DODGE_DURATION := 0.16
const DODGE_SPEED := 420.0
const WALK_SPEED := 150.0
const RUN_SPEED := 236.0
const RUN_STICK := 0.72

func _ready() -> void:
	display_name = GameState.player_name
	team = "player"
	body_color = Color(0.36, 0.55, 0.92) if GameState.player_sex == GameState.Sex.MALE else Color(0.72, 0.48, 0.86)
	max_hp = GameState.max_hp
	hp = GameState.hp
	figure_kind = "human"
	super._ready()
	apply_look(GameState.era)
	if label:
		label.text = GameState.player_name
	var old_cam := get_node_or_null("Camera2D")
	if old_cam:
		old_cam.enabled = false

func _physics_process(_delta: float) -> void:
	if GameState.in_dialogue:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if dodge_time > 0.0:
		dodge_time -= _delta
		velocity = dodge_dir * DODGE_SPEED
		move_and_slide()
		return
	var kb := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var dir := joystick_dir if joystick_dir.length() > 0.15 else kb
	var dex := Dice.modifier_from_score(GameState.ability("dex"))
	var running := dir.length() >= RUN_STICK
	var walk := 118.0 if GameState.era == "child" else WALK_SPEED
	var run := 188.0 if GameState.era == "child" else RUN_SPEED
	move_speed = (run if running else walk) + dex * 6
	if figure:
		figure.gait = "run" if running else ("walk" if dir.length() > 0.15 else "idle")
	apply_velocity(dir)
	if Input.is_action_just_pressed("interact"):
		interact_pressed.emit()
	if Input.is_action_just_pressed("dodge"):
		try_dodge()

func set_joystick(dir: Vector2) -> void:
	joystick_dir = dir

func apply_look(era: String) -> void:
	if figure:
		figure.apply_look(era)

func try_dodge() -> bool:
	if dodge_cooldown > 0.0 or GameState.in_dialogue:
		return false
	dodge_cooldown = DODGE_CD
	dodge_time = DODGE_DURATION
	var dir := joystick_dir
	dodge_dir = dir.normalized() if dir.length() > 0.1 else facing
	invuln_time = DODGE_DURATION + 0.05
	if figure:
		figure.dodge_smear()
	return true

func sync_hp_from_state() -> void:
	max_hp = GameState.max_hp
	hp = GameState.hp
	_refresh_hp()
