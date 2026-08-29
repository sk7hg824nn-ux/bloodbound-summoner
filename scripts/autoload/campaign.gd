extends Node
## Full main-campaign spine. Playable content unlocks chapter by chapter.
## The player and the protagonist learn the truth together — never early.

signal chapter_started(chapter_id: String, title: String)
signal objective_changed(text: String)

var chapter_id: String = "ch1_exam"
var act: int = 1
var objective: String = "Attend the entrance examination."
var journal: Array[Dictionary] = []


func current() -> Dictionary:
	return StoryDB.chapter(chapter_id)


func title() -> String:
	var c := current()
	return "%s — %s" % [c.get("act_label", "Act I"), c.get("title", "")]


func set_chapter(id: String, announce: bool = true) -> void:
	if not StoryDB.has_chapter(id):
		push_warning("Unknown chapter: " + id)
		return
	chapter_id = id
	var c := StoryDB.chapter(id)
	act = int(c.get("act", 1))
	objective = str(c.get("objective", objective))
	GameState.set_flag("chapter_" + id)
	GameState.flags["chapter_id"] = id
	if announce:
		chapter_started.emit(id, title())
		objective_changed.emit(objective)
		EventBus.toast.emit(title())
	_journal(title(), str(c.get("blurb", "")))


func set_objective(text: String) -> void:
	objective = text
	objective_changed.emit(text)


func advance_if(flag: String, next_chapter: String) -> void:
	GameState.set_flag(flag)
	if chapter_id != next_chapter:
		set_chapter(next_chapter)


func reset() -> void:
	chapter_id = "ch1_exam"
	act = 1
	objective = "Attend the entrance examination."
	journal.clear()


func _journal(head: String, body: String) -> void:
	journal.append({"day": GameState.day, "title": head, "body": body})
	if journal.size() > 40:
		journal.pop_front()


func is_at_least(id: String) -> bool:
	return StoryDB.index_of(chapter_id) >= StoryDB.index_of(id)
