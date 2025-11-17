class_name Skill extends Resource

enum TargetType {
	SELF,
	SINGLE,
	MULTI,
	GROUP,
}

enum TargetUnitType {
	ALLY 	= 1 << 0,
	ENEMY 	= 1 << 1,
}


@export var effects : Array[SkillEffect]
@export var cost : int = 0
@export var target_type : TargetType
@export_flags("ALLY", "ENEMY") var target_unit_type : int = 0


func activate_skill(caster : Unit, targets : Array[Unit]) -> void:
	for effect in effects:
		effect.activate_effect(caster, targets)
