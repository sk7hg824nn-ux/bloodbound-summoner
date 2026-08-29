extends Node
## D&D-inspired dice used for attacks, dialogue checks, traps, and events.
## Combat itself stays real-time; dice tilt outcomes instead of replacing action.

func roll(sides: int, count: int = 1) -> int:
	var total := 0
	for _i in count:
		total += randi_range(1, sides)
	return total


func d20() -> int:
	return roll(20)


func d6(count: int = 1) -> int:
	return roll(6, count)


func check(ability_score: int, dc: int, advantage: bool = false) -> Dictionary:
	var first := d20()
	var second := d20()
	var raw := max(first, second) if advantage else first
	var modifier := modifier_from_score(ability_score)
	var total := raw + modifier
	return {
		"raw": raw,
		"modifier": modifier,
		"total": total,
		"dc": dc,
		"success": total >= dc,
		"crit": raw == 20,
		"fumble": raw == 1,
	}


func modifier_from_score(score: int) -> int:
	return int(floor((score - 10) / 2.0))


func attack_roll(attack_bonus: int, armor_class: int) -> Dictionary:
	var raw := d20()
	var total := raw + attack_bonus
	var crit := raw == 20
	var fumble := raw == 1
	var hit := crit or (not fumble and total >= armor_class)
	return {
		"raw": raw,
		"bonus": attack_bonus,
		"total": total,
		"ac": armor_class,
		"hit": hit,
		"crit": crit,
		"fumble": fumble,
	}


func damage(dice_count: int, dice_sides: int, bonus: int = 0, crit: bool = false) -> int:
	var count := dice_count * (2 if crit else 1)
	return max(1, roll(dice_sides, count) + bonus)
