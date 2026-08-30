extends Control

var _confirm := -1

func _ready() -> void:
	$Center/Start.visible = false
	$Center/ContinueHint.text = "Empty slot = new life. Occupied = continue or delete."
	var slots := $Center.get_node_or_null("Slots") as VBoxContainer
	if slots == null:
		slots = VBoxContainer.new()
		slots.name = "Slots"
		slots.add_theme_constant_override("separation", 10)
		$Center.add_child(slots)
	_paint()

func _slots() -> VBoxContainer:
	return $Center/Slots as VBoxContainer

func _paint() -> void:
	var slots := _slots()
	for c in slots.get_children():
		slots.remove_child(c)
		c.free()
	var last := SaveSystem.current_slot
	for i in SaveSystem.SLOT_COUNT:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		var info := SaveSystem.peek(i)
		var main := Button.new()
		main.custom_minimum_size = Vector2(0, 44)
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
			wipe.text = "Sure?" if _confirm == i else "Delete"
			wipe.pressed.connect(_wipe.bind(i))
			row.add_child(main)
			row.add_child(wipe)
		slots.add_child(row)

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
