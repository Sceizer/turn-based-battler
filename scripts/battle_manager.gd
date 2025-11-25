class_name BattleManager extends Node

@export var load_in_fighters: Array[Dictionary]
@export var turn_manager: TurnManager
@export var background: BattleScene

var current_units: Array[Unit]

func _ready() -> void:
	for fighter in load_in_fighters:
		var new_fighter = Unit.new()
		new_fighter.unit_stats = fighter["stats"]
		new_fighter.unit_anim_scene = fighter["anim"]
		new_fighter.unit_control_scene = fighter["controller"]
		new_fighter.team = fighter["team"]
		new_fighter.battle_manager = self
		
		var slots = background.get_slots(fighter["team"])
		for slot in slots:
			if slot.get_occupier() == null:
				slot.add_child(new_fighter)
				slot.occupier = weakref(new_fighter)
				break
		current_units.append(new_fighter)
	
	turn_manager.load_trackers_from_array(current_units)
	
	
func get_units(selected_team: int = -1) -> Array[Unit]:
	if selected_team == -1:
		return current_units
	return current_units.filter(func(unit): return unit.team == selected_team)
	
	
func remove_unit(unit_to_remove: Unit):
	var unit_id = current_units.find(unit_to_remove)
	if unit_id != -1:
		current_units.remove_at(unit_id)
		turn_manager.remove_tracker(unit_to_remove)
