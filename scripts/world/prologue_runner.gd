extends Node2D

func _ready() -> void:
	GameState.era = "child"
	var cut := CutsceneDirector.new()
	add_child(cut)
	cut.finished.connect(_to_academy)
	cut.play(OriginCutscene.beats(GameState.player_name))

func _to_academy() -> void:
	GameState.set_flag("prologue_done")
	GameState.era = "academy"
	GameState.location = "courtyard"
	get_tree().change_scene_to_file("res://scenes/world/Academy.tscn")
