extends RefCounted
class_name FirstSummon

static func circle_open(name: String) -> Dictionary:
	return {
		"speaker": "Proctor",
		"lines": [
			"Step in. Call something that will answer.",
			"The boy before you pulled a wolf. The girl after you will pull a whelp.",
			"%s of the outskirts. The circle is waiting." % name,
		],
		"choices": [{"id": "ex_try", "text": "Call."}],
	}

static func circle_fail() -> Dictionary:
	return {
		"speaker": "The Circle",
		"lines": [
			"Nothing stands up.",
			"The proctor marks a slate. Insufficient. Someone laughs like they practiced.",
			"Whatever you did, the instructors do not have a word for it. They have a joke.",
		],
		"choices": [{"id": "ex_leave", "text": "Get out of their sight."}],
	}

static func woods_alone() -> Dictionary:
	return {
		"speaker": "The Woods",
		"lines": [
			"No drill. No next try. Maybe there is nothing special about you.",
			"The academy lawn stops. The trees do not grade.",
			"Brush moves that is not wind.",
		],
		"choices": [{"id": "wd_stay", "text": "You can't go back yet."}],
	}

static func after_save() -> Dictionary:
	return {
		"speaker": "Akari",
		"lines": [
			"One tail. Orange like a warning.",
			"\"Outskirts. Empty circle. And you still walked into teeth. Impressive stupidity.\"",
			"She did not come when they clapped. She came when you were about to die.",
			"You think you failed. She knows something happened. Neither of you can name it.",
		],
		"choices": [{"id": "sm_done", "text": "…Thank you."}],
	}
