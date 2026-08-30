extends Control

func _ready() -> void:
	$Center/Start.visible = false
	$Center/ContinueHint.text = "Three slots. Empty starts a life. Occupied continues it."
	var last := SaveSystem.current_slot
	for i in SaveSystem.SLOT_COUNT:
		var b := Button.new()
		b.custom_minimum_size = Vector2(0, 44)
		var info := SaveSystem.peek(i)
		var mark := "  · last" if i == last and not info.is_empty() else ""
		if info.is_empty():
			b.text = "Slot %d  —  empty" % (i + 1)
			b.pressed.connect(_new_in.bind(i))
		else:
			var n := str(info.get("player_name", "Ash"))
			var loc := str(info.get("location", ""))
			b.text = "Slot %d  —  %s  ·  %s%s" % [i + 1, n, loc, mark]
			b.pressed.connect(_load_in.bind(i))
		$Center.add_child(b)
		$Center.move_child(b, 3 + i)

func _new_in(slot: int) -> void:
	SaveSystem.current_slot = slot
	SaveSystem.clear_slot(slot)
	get_tree().change_scene_to_file("res://scenes/boot/CharacterCreate.tscn")

func _load_in(slot: int) -> void:
	if SaveSystem.load_slot(slot):
		get_tree().change_scene_to_file(SaveSystem.continue_scene())
