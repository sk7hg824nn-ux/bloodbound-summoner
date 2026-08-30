extends Control

var _confirm := -1

func _ready() -> void:
	$Center/Start.visible = false
	_paint()

func _paint() -> void:
	var box := $Center
	for c in box.get_children():
		if c.name.begins_with("Row") or c.name == "HintFresh":
			c.queue_free()
	$Center/ContinueHint.text = "Empty slot = new life. Occupied = continue or delete."
	var last := SaveSystem.current_slot
	for i in SaveSystem.SLOT_COUNT:
		var row := HBoxContainer.new()
		row.name = "Row%d" % i
		row.custom_minimum_size = Vector2(0, 44)
		row.add_theme_constant_override("separation", 8)
		var info := SaveSystem.peek(i)
		var main := Button.new()
		main.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if info.is_empty():
			main.text = "Slot %d  —  empty" % (i + 1)
			main.pressed.connect(_new_in.bind(i))
			row.add_child(main)
		else:
			var n := str(info.get("player_name", "Ash"))
			var loc := str(info.get("location", ""))
			var mark := "  · last" if i == last else ""
			main.text = "Continue  %d  —  %s  ·  %s%s" % [i + 1, n, loc, mark]
			main.pressed.connect(_load_in.bind(i))
			var wipe := Button.new()
			wipe.custom_minimum_size = Vector2(88, 44)
			if _confirm == i:
				wipe.text = "Sure?"
			else:
				wipe.text = "Delete"
			wipe.pressed.connect(_wipe.bind(i))
			row.add_child(main)
			row.add_child(wipe)
		box.add_child(row)

func _new_in(slot: int) -> void:
	SaveSystem.current_slot = slot
	SaveSystem.clear_slot(slot)
	get_tree().change_scene_to_file("res://scenes/boot/CharacterCreate.tscn")

func _load_in(slot: int) -> void:
	if SaveSystem.load_slot(slot):
		get_tree().change_scene_to_file(SaveSystem.continue_scene())

func _wipe(slot: int) -> void:
	if _confirm != slot:
		_confirm = slot
		_paint()
		return
	SaveSystem.clear_slot(slot)
	_confirm = -1
	_paint()
