@abstract
class_name SkillEffect extends Resource

signal skill_effect_finished


var effect_running: bool


func activate_effect(_caster : Unit, _targets : Array[Unit]) -> void:
	skill_effect_finished.emit()
