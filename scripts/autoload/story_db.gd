extends Node

const CHAPTERS := [
	{"id": "pro0_home", "act": 0, "act_label": "Prologue", "title": "A Happy House", "objective": "Be a child. Talk to your mother. Walk the yard.", "blurb": "She loves you.", "playable": true},
	{"id": "pro1_signs", "act": 0, "act_label": "Prologue", "title": "Things That Watch", "objective": "Notice what she hides.", "blurb": "The box stays locked.", "playable": true},
	{"id": "pro2_truth", "act": 0, "act_label": "Prologue", "title": "What She Knew", "objective": "Ask her about the blood.", "blurb": "Ancient. Hunted.", "playable": true},
	{"id": "pro3_night", "act": 0, "act_label": "Prologue", "title": "The Night They Found You", "objective": "Survive the assassin.", "blurb": "They came for the bloodline.", "playable": true},
	{"id": "pro4_last", "act": 0, "act_label": "Prologue", "title": "Her Last Words", "objective": "Stay with her.", "blurb": "You are not a monster.", "playable": true},
	{"id": "pro5_wake", "act": 0, "act_label": "Prologue", "title": "First Blood", "objective": "Live through what you cannot control.", "blurb": "Not a pact.", "playable": true},
	{"id": "pro6_years", "act": 0, "act_label": "Prologue", "title": "Years Later", "objective": "Carry her warning into the academy.", "blurb": "You look ordinary.", "playable": true},
	{"id": "ch1_exam", "act": 1, "act_label": "Act I", "title": "The One Who Couldn't Summon", "objective": "Walk the courtyard.", "blurb": "Player brick ends here.", "playable": true},
]

func has_chapter(id: String) -> bool:
	return index_of(id) >= 0

func index_of(id: String) -> int:
	for i in CHAPTERS.size():
		if String(CHAPTERS[i]["id"]) == id:
			return i
	return -1

func chapter(id: String) -> Dictionary:
	for c in CHAPTERS:
		if String(c["id"]) == id:
			return c
	return {}
