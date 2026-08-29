extends RefCounted
class_name FirstSummon

static func circle_open(name: String) -> Dictionary:
	return {
		"speaker": "Proctor",
		"lines": [
			"Step in. The rite. Everyone is watching.",
			"The boy before you pulled a wolf. Draw the circle. Give the drop.",
			"%s. They already expect nothing." % name,
		],
		"choices": [{"id": "ex_try", "text": "…Do it anyway."}],
	}

static func circle_fail() -> Dictionary:
	return {
		"speaker": "The Circle",
		"lines": [
			"The drop hits the mark. Nothing stands up.",
			"The proctor marks a slate. Insufficient. Someone laughs like they practiced.",
			"You keep your eyes on the dirt.",
		],
		"choices": [{"id": "ex_leave", "text": "Leave before they say it again."}],
	}

static func week_later() -> Dictionary:
	return {
		"speaker": "A Week Later",
		"lines": [
			"Seven days of being the joke.",
			"You wait until no one follows. The woods do not have a crowd.",
		],
		"choices": [{"id": "wk_ok", "text": "Go where they cannot watch."}],
	}

static func woods_call(name: String) -> Dictionary:
	return {
		"speaker": "The Woods",
		"lines": [
			"No slate. Still the same rite. Circle. Drop. Ask.",
			"%s, your hands are not steady." % name,
		],
		"choices": [{"id": "wd_call", "text": "Draw the circle. Give the drop."}],
	}

static func woods_fail() -> Dictionary:
	return {
		"speaker": "The Woods",
		"lines": [
			"The circle is there. The drop hits the mark. The rite closes on nothing. Again.",
			"Maybe there is nothing special about you.",
		],
		"choices": [{"id": "wd_walk", "text": "Walk away."}],
	}

static func after_save() -> Dictionary:
	return {
		"speaker": "Akari",
		"lines": [
			"The strike does not land.",
			"Purple hair. One tail. The whelp is already down.",
			"\"You failed in front of them, hid for a week, whispered the rite in the weeds, and turned your back. Cute.\"",
			"You think both rituals failed. She knows something happened. Neither of you can name it.",
		],
		"choices": [{"id": "sm_done", "text": "…Thank you."}],
	}
