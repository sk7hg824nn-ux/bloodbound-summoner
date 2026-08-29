extends Control

func _ready() -> void:
	$Center/Start.pressed.connect(_start)
	$Center/ContinueHint.text = "Xogot / Godot 4  •  landscape 844x390  •  Player brick"

func _start() -> void:
	get_tree().change_scene_to_file("res://scenes/boot/CharacterCreate.tscn")
