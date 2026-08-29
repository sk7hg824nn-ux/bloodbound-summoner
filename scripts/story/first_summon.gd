extends RefCounted
class_name FirstSummon

static func woods_call(name: String) -> Dictionary:
	return {
		"speaker": "The Woods",
		"lines": [
			"No proctor. No slate. The rite still has a shape.",
			"%s of the outskirts. Draw the circle. Give a drop of your blood. Ask." % name,
			"The trees do not grade.",
		],
		"choices": [{"id": "wd_call", "text": "Draw the circle. Give the drop."}],
	}

static func woods_fail() -> Dictionary:
	return {
		"speaker": "The Woods",
		"lines": [
			"The circle is there. The drop hits the mark. The rite closes on nothing.",
			"No answer. No partner. Maybe there is nothing special about you.",
		],
		"choices": [{"id": "wd_walk", "text": "Walk away."}],
	}

static func after_save() -> Dictionary:
	return {
		"speaker": "Akari",
		"lines": [
			"The strike does not land.",
			"One tail. The whelp is already down. She did not wait for the circle to impress anyone.",
			"\"Nice dirt drawing. You paid the drop, decided you were nothing, and turned your back. Cute.\"",
			"You think the ritual failed. She knows something happened. Neither of you can name it.",
		],
		"choices": [{"id": "sm_done", "text": "…Thank you."}],
	}
