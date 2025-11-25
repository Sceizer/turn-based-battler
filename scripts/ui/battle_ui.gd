class_name BattleUI extends Control


@export var battle_scene: BattleScene


var current_unit: Unit
var stored_skill: Skill= null
var skill_targets = []

func _ready() -> void:
	self.visible = false
	if battle_scene:
		for target_slot in battle_scene.get_slots():
			target_slot.connect("pressed", _handle_on_slot_select.bind(target_slot))
	

func _on_next_turn(next_in_order: TurnNotifier):
	if next_in_order is Unit and next_in_order.team == 0:
		current_unit = next_in_order
		print("Show UI")
		self.visible = true


func _on_skip_pressed() -> void:
	current_unit.finish_turn()
	self.visible = false


func _on_attack_press() -> void:
	if current_unit != null:
		if current_unit.unit_stats == null or current_unit.unit_stats.default_skill == null:
			push_error("%s does not have a basic skill")
		stored_skill = current_unit.unit_stats.default_skill
		self.visible = false
		await stored_skill.skill_finished
		stored_skill = null
		current_unit.finish_turn()


func _handle_on_slot_select(selected_slot: BattleSlot) -> void:
	if stored_skill != null:
		var selected_unit = selected_slot.get_occupier() as Unit
		if selected_unit != null and (
		   (stored_skill.target_unit_type & Skill.TargetUnitType.ALLY and selected_unit.team == current_unit.team)
		or (stored_skill.target_unit_type & Skill.TargetUnitType.ENEMY and selected_unit.team != current_unit.team)):
				stored_skill.activate_skill(current_unit, [selected_unit])
