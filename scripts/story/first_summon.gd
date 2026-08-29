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
		],
		"choices": [{"id": "wd_walk", "text": "Walk away."}],
	}

static func after_save() -> Dictionary:
	return {
		"speaker": "Akari",
		"lines": [
			"The strike does not land.",
			"One tail. The whelp is already down. She did not ask the trees for permission.",
			"\"You called in the weeds, decided you were nothing, and turned your back. Cute.\"",
			"You think you failed. She knows something happened. Neither of you can name it.",
		],
		"choices": [{"id": "sm_done", "text": "…Thank you."}],
	}
