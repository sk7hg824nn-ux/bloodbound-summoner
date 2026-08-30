extends Node2D

func _ready() -> void:
	GameState.era = "memory"
	GameState.change_location("before")
	Campaign.set_objective("He will not be told who he is.")
	var plate := Sprite2D.new()
	plate.name = "Plate"
	plate.centered = false
	plate.position = Vector2.ZERO
	plate.z_index = 2
	plate.texture = OriginArt.tex("castle")
	add_child(plate)
	var cut := CutsceneDirector.new()
	cut.plate = plate
	add_child(cut)
	cut.finished.connect(_to_academy)
	cut.play(OriginCutscene.beats(GameState.player_name))

func _to_academy() -> void:
	GameState.set_flag("prologue_done")
	GameState.era = "academy"
	GameState.change_location("hall")
	SaveSystem.write()
	get_tree().change_scene_to_file("res://scenes/world/Academy.tscn")
