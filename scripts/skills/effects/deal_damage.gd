class_name DealDamage extends SkillEffect


@export var base_power : float = 5


func activate_effect(caster : Unit, targets : Array[Unit]) -> void:
	var calc_damage = base_power + caster.attack_stat.get_modified_value()
	for target in targets:
		target.health_stat.set_value_delta(-calc_damage)
	skill_effect_finished.emit()
