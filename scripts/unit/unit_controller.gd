@abstract
class_name UnitController extends Node


@onready var unit= get_parent() as Unit


func _ready() -> void:
	if unit == null:
		push_error("%s Does not have a valid Unit parent!" % name)
		return
	unit.connect("on_start_turn", start_turn)


@abstract
func start_turn() -> void
