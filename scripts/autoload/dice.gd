extends Node
func modifier_from_score(score: int) -> int:
	return int(floor((score - 10) / 2.0))
func roll(sides: int, count: int = 1) -> int:
	var t := 0
	for i in count:
		t += randi_range(1, sides)
	return t
