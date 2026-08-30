extends RefCounted
class_name OriginCutscene

static func beats(name: String) -> Array:
	return [
		{"type": "plate", "id": "castle"},
		{"type": "say", "speaker": "A Continent That Is Gone", "lines": ["A king. A queen. A castle that thought it would last."]},
		{"type": "plate", "id": "fire"},
		{"type": "say", "speaker": "The Night", "lines": ["The gates do not hold. Fire takes the courts. The king falls where he stands."]},
		{"type": "plate", "id": "road"},
		{"type": "say", "speaker": "His Mother", "lines": ["She does not stay to name the reason. She runs with what she can carry."]},
		{"type": "plate", "id": "house"},
		{"type": "say", "speaker": "A Quiet House", "lines": ["Years. Bread. A creek. A woman who loves him and does not explain the road she took."]},
		{"type": "plate", "id": "years"},
		{"type": "say", "speaker": "The Years", "lines": ["He grows. He is called %s. He is not told the rest."]},
		{"type": "say", "speaker": name, "lines": ["Eighteen. The academy will take anyone who can bleed on a seal."]},
		{"type": "say", "speaker": "His Mother", "lines": ["Go. Do not look back the way I look back."]},
		{"type": "plate", "id": "black"},
		{"type": "say", "speaker": "", "lines": ["—"]},
	]
