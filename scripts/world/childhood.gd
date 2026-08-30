extends Node2D
## Playable childhood is not canon. This scene only forwards to the cinematic prologue.

func _ready() -> void:
	get_tree().change_scene_to_file("res://scenes/world/Prologue.tscn")
