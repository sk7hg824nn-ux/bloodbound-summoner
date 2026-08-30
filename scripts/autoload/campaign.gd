extends Node
signal chapter_started(chapter_id: String, title: String)
signal objective_changed(text: String)

var chapter_id: String = "pro0_memory"
var act: int = 0
var objective: String = "He will not be told who he is."
var journal: Array[Dictionary] = []

func current() -> Dictionary:
	return StoryDB.chapter(chapter_id)

func title() -> String:
	var c := current()
	return "%s — %s" % [c.get("act_label", "Prologue"), c.get("title", "")]

func set_chapter(id: String, announce: bool = true) -> void:
	if not StoryDB.has_chapter(id):
		return
	chapter_id = id
	var c := StoryDB.chapter(id)
	act = int(c.get("act", 0))
	objective = str(c.get("objective", objective))
	GameState.set_flag("chapter_" + id)
	if announce:
		chapter_started.emit(id, title())
		objective_changed.emit(objective)
		EventBus.toast.emit(title())

func set_objective(text: String) -> void:
	objective = text
	objective_changed.emit(text)

func reset() -> void:
	chapter_id = "pro0_memory"
	act = 0
	objective = "He will not be told who he is."
	journal.clear()
