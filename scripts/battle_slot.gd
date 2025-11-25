class_name BattleSlot extends Marker2D


signal occupier_changed(new_occupier: WeakRef)
signal mouse_enter()
signal mouse_exit()
signal pressed()


enum Direction{LEFT = -1, RIGHT = 1}

@export var direction: Direction = Direction.RIGHT:
	set = set_direction
@export var team: int= 0

@onready var static_body = $UICollision


var occupier: WeakRef:
	set = set_occupier


func _ready() -> void:
	set_direction(direction)


func get_occupier():
	if occupier == null or occupier.get_ref() == null:
		return null
	return occupier.get_ref()


func set_occupier(new_occupier: WeakRef) -> void:
	occupier = new_occupier
	if occupier != null and occupier.get_ref() != null:
		occupier.get_ref().connect("tree_exiting", set_occupier.bind(null))
	occupier_changed.emit(occupier)


func set_direction(new_dir) -> void:
	direction = new_dir
	scale.x = abs(scale.x) * direction


func _on_mouse_entered() -> void:
	if occupier != null and occupier.get_ref() != null:
		#print("%s Mouse Enter" % occupier.get_ref().name)
		mouse_enter.emit()


func _on_mouse_exited() -> void:
	if occupier != null and occupier.get_ref() != null:
		#print("%s Mouse Exit" % occupier.get_ref().name)
		mouse_exit.emit()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if occupier != null and occupier.get_ref() != null:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("%s Mouse Click!" % occupier.get_ref().name)
			pressed.emit()
