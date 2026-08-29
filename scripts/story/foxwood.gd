extends RefCounted
class_name Foxwood

static func arrive(name: String) -> Dictionary:
	return {
		"speaker": "Foxwood Gate",
		"lines": [
			"The academy lawn stops. The trees do not care about exam scores.",
			"You have asked the air for a partner until the air is bored.",
			"%s, this is the last time you intend to beg." % name,
		],
		"choices": [{"id": "fw_call", "text": "Ask anyway."}],
	}

static func she_appears() -> Dictionary:
	return {
		"speaker": "Akari",
		"lines": [
			"One tail. Orange like a warning, not a welcome.",
			"\"You stink of the outskirts. And you called like a drowning man.\"",
			"She looks through you. Whatever the blood is, she does not feel it.",
		],
		"choices": [{"id": "fw_beg", "text": "Please. I need a pact."}],
	}

static func beg_again() -> Dictionary:
	return {
		"speaker": "Akari",
		"lines": [
			"\"Need. Cute.\"",
			"\"Say it again. Slower. I want to remember how sad it sounded.\"",
		],
		"choices": [
			{"id": "fw_beg2", "text": "Please."},
			{"id": "fw_pride", "text": "Fine. Walk away."},
		],
	}

static func seals() -> Dictionary:
	return {
		"speaker": "The Pact",
		"lines": [
			"She clicks her tongue and takes your wrist like it owes her rent.",
			"Something two-way opens. Neither of you has a name for it.",
			"\"Don't grin. The ledger will call me your summon. I am not impressed.\"",
			"One tail. Rank E. She is the fighter. You are the fool who asked.",
		],
		"choices": [{"id": "fw_done", "text": "Walk her back."}],
	}

static func refused() -> Dictionary:
	return {
		"speaker": "Akari",
		"lines": [
			"\"Then starve.\" She is already in the trees.",
			"The air is empty again. ATK is still not a fist.",
		],
		"choices": [{"id": "fw_empty", "text": "Stay at the gate."}],
	}
