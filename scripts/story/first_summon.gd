extends RefCounted
class_name FirstSummon

static func woods_call(name: String) -> Dictionary:
	return {
		"speaker": "The Woods",
		"lines": [
			"No proctor. No slate. No one to laugh if it fails.",
			"%s of the outskirts. You came out here to call anyway." % name,
			"The trees do not grade. Ask them.",
		],
		"choices": [{"id": "wd_call", "text": "Call."}],
	}

static func woods_fail() -> Dictionary:
	return {
		"speaker": "The Woods",
		"lines": [
			"Nothing stands up.",
			"No drill. No next try. Maybe there is nothing special about you.",
			"Brush moves that is not wind.",
		],
		"choices": [{"id": "wd_stay", "text": "You can't even run right."}],
	}

static func after_save() -> Dictionary:
	return {
		"speaker": "Akari",
		"lines": [
			"One tail. Orange like a warning.",
			"\"You called in the weeds like the academy would hear you. Then you almost died. Cute.\"",
			"She did not come for a circle. She came when you were about to die.",
			"You think you failed. She knows something happened. Neither of you can name it.",
		],
		"choices": [{"id": "sm_done", "text": "…Thank you."}],
	}
