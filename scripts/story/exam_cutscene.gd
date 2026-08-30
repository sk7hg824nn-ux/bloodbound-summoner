extends RefCounted
class_name ExamCutscene

static func beats(name: String) -> Array:
	return [
		{"type": "cam", "mode": Camera2DDirector.Mode.EXPLORE},
		{"type": "say", "speaker": "Grand Hall", "lines": ["Bleachers packed. Teachers on the floor. One student at a time."]},
		{"type": "say", "speaker": "Instructor", "lines": ["Next. Blood to the seal."]},
		{"type": "say", "speaker": "A Student", "lines": ["The blade. A drop. The runes take it. The air moves."]},
		{"type": "mark", "text": "The circle answers someone else."},
		{"type": "say", "speaker": "The Hall", "lines": ["A griffin lands. Eagle head. Lion body. Alive. Not a trick of light."]},
		{"type": "say", "speaker": "Instructor", "lines": ["Successful pact."]},
		{"type": "say", "speaker": "The Crowd", "lines": ["They cheer. That is what this room is for."]},
		{"type": "cam", "mode": Camera2DDirector.Mode.ROMANCE},
		{"type": "say", "speaker": "Instructor", "lines": ["%s." % name]},
		{"type": "say", "speaker": "Whispers", "lines": ["Isn't that the one who keeps failing?", "He hasn't summoned anything yet.", "Why are they still letting him try?"]},
		{"type": "say", "speaker": name, "lines": ["Same blade. Same drop. Same seal."]},
		{"type": "say", "speaker": "The Seal", "lines": ["The hall gets heavy. The griffin steps back. Feathers up. Ash does not notice. The instructor does."]},
		{"type": "say", "speaker": name, "lines": ["Answer my call."]},
		{"type": "say", "speaker": "The Circle", "lines": ["It brightens. Wind. The crowd leans in. Then — nothing. He is alone."]},
		{"type": "say", "speaker": name, "lines": ["Again."]},
		{"type": "say", "speaker": "Instructor", "lines": ["Ash, the ritual has failed."]},
		{"type": "say", "speaker": name, "lines": ["One more time."]},
		{"type": "say", "speaker": "The Circle", "lines": ["More blood. Brighter. The griffin is afraid. Other summons crowd their owners. Then — nothing."]},
		{"type": "say", "speaker": "A Student", "lines": ["He can't summon anything."]},
		{"type": "say", "speaker": "Another", "lines": ["Maybe there isn't anything worth summoning."]},
		{"type": "say", "speaker": "Instructor", "lines": ["Ash. Step out of the circle."]},
		{"type": "say", "speaker": name, "lines": ["The hand is still bleeding. He leaves."]},
	]
