class_name BattleScene extends Node


func get_slots(team = null) -> Array[BattleSlot]:
	var result: Array[BattleSlot]
	for child in get_children(true):
		if child is BattleSlot and (team == null or child.team == team):
			result.append(child)
	return result
