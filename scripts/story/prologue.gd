extends RefCounted
class_name Prologue

static func morning(name: String) -> Dictionary:
	return {"speaker": "Mother", "lines": ["Sun's up, %s. Bread's still warm." % name, "Stay where I can see you.", "Come here first. I want to look at you."], "choices": [{"id": "pro_hug", "text": "Hug her."}, {"id": "pro_eat", "text": "Steal bread first."}]}
static func after_hug() -> Dictionary:
	return {"speaker": "Mother", "lines": ["She smells like soap and woodsmoke.", "Go be a menace. Come back before the light drops."], "choices": [{"id": "pro_play", "text": "Run the yard."}]}
static func creek() -> Dictionary:
	return {"speaker": "Creek", "lines": ["Minnows scatter before your shadow.", "The last one leaves a red ripple that isn't water."], "choices": [{"id": "pro_noticed", "text": "Tell Mother."}]}
static func box() -> Dictionary:
	return {"speaker": "Locked Box", "lines": ["Iron. Older than the house.", "A circle that is not a summoner's circle.", "Mother: Leave that. Please."], "choices": [{"id": "pro_leave_box", "text": "Put the board back."}, {"id": "pro_ask_box", "text": "What's in it?"}]}
static func watchers() -> Dictionary:
	return {"speaker": "The Road", "lines": ["A man watches the chimney. Then you.", "When Mother steps out he is gone."], "choices": [{"id": "pro_road_ok", "text": "Go inside."}]}
static func discovery(name: String) -> Dictionary:
	return {"speaker": "Mother", "lines": ["You have old blood. Older than the academy.", "People have died to keep it from coming back.", "%s, you do not know what to do with that." % name], "choices": [{"id": "pro_excited", "text": "Does that mean I can do magic?"}, {"id": "pro_scared", "text": "Are they going to hurt us?"}]}
static func incomplete() -> Dictionary:
	return {"speaker": "Mother", "lines": ["It means you are not ordinary. That is not the same as safe.", "If anyone asks — you are my child."], "choices": [{"id": "pro_night", "text": "Night comes anyway."}]}
static func assassin() -> Dictionary:
	return {"speaker": "The Door", "lines": ["The latch gives.", "The man from the road. A knife that hums.", "Run, she says."], "choices": [{"id": "pro_stay", "text": "I won't leave you."}]}
static func fight() -> Dictionary:
	return {"speaker": "Mother", "lines": ["She puts herself between you and the knife.", "The third time she drops."], "choices": [{"id": "pro_to_her", "text": "Go to her."}]}
static func last_words(name: String) -> Dictionary:
	return {"speaker": "Mother", "lines": ["This blood does not make you a monster.", "Survive. Do not let hunters write your name.", "You were loved, %s." % name], "choices": [{"id": "pro_wake", "text": "Don't go."}]}
static func awakening() -> Dictionary:
	return {"speaker": "The Blood", "lines": ["Something in you answers her going.", "It is not a summon. You do not know what you did."], "choices": [{"id": "pro_skip", "text": "Years pass."}]}
static func timeskip(name: String) -> Dictionary:
	return {"speaker": "Years Later", "lines": ["%s grows into the body the academy will judge." % name, "You enroll. You look like a first-year with bad luck."], "choices": [{"id": "pro_academy", "text": "Walk through the gate."}]}
