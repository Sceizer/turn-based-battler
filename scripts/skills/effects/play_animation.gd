class_name PlayAnimation extends SkillEffect

@export var animation_name: String
@export var on_caster: bool
@export var pause_until_finished: bool

func activate_effect(caster : Unit, targets : Array[Unit]) -> void:
	effect_running = pause_until_finished
	if on_caster:
		var caster_unit_anim = caster.anim as UnitAnim
		if caster_unit_anim != null and caster_unit_anim.animation_player != null:
			if not caster_unit_anim.animation_player.has_animation(animation_name):
				push_warning("%s Does not have an animation named %s" % [caster.name, animation_name])
			else:
				caster_unit_anim.animation_player.play(animation_name)
				if pause_until_finished:
					await caster_unit_anim.animation_player.animation_finished
	else:
		for target in targets:
			var target_unit_anim = target.anim as UnitAnim
			if target_unit_anim != null and target_unit_anim.animation_player != null:
				if not target_unit_anim.animation_player.has_animation(animation_name):
					push_warning("%s Does not have an animation named %s" % [target.name, animation_name])
					continue
				target_unit_anim.animation_player.play(animation_name)
				if pause_until_finished:
					await target_unit_anim.animation_player.animation_finished
	effect_running = false
	skill_effect_finished.emit()
