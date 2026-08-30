extends Control

func _ready() -> void:
	$Center/Start.pressed.connect(_start)
	if SaveSystem.has_save():
		var cont := Button.new()
		cont.text = "Continue"
		cont.custom_minimum_size = Vector2(0, 48)
		$Center.add_child(cont)
		$Center.move_child(cont, 3)
		cont.pressed.connect(_continue)
		$Center/ContinueHint.text = "A pact remembers."
	else:
		$Center/ContinueHint.text = "Xogot / Godot 4.6  •  844x390"

func _start() -> void:
	get_tree().change_scene_to_file("res://scenes/boot/CharacterCreate.tscn")

func _continue() -> void:
	if SaveSystem.load_save():
		get_tree().change_scene_to_file(SaveSystem.continue_scene())
