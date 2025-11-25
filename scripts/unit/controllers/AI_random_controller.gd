class_name AIRandomController extends UnitController


func start_turn() -> void:
	var default_skill = unit.unit_stats.default_skill
	if default_skill != null:
		var all_availabe_targets = unit.battle_manager.get_units().filter(
			func(target): return (
				(default_skill.target_unit_type & Skill.TargetUnitType.ALLY and target.team == unit.team) 
				or (default_skill.target_unit_type & Skill.TargetUnitType.ENEMY and target.team != unit.team)))
		var random_target = all_availabe_targets.pick_random()
		var unit_array: Array[Unit]
		unit_array.append(random_target)
		unit.unit_stats.default_skill.activate_skill(unit, unit_array)
		await unit.unit_stats.default_skill.skill_finished
	unit.finish_turn()
