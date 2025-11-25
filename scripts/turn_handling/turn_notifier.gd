@abstract
class_name TurnNotifier extends Node2D

signal on_start_turn()
signal on_finish_turn()

@abstract
func get_speed() -> float


func start_turn() -> void:
	on_start_turn.emit()
	
	
func finish_turn() -> void:
	on_finish_turn.emit()
