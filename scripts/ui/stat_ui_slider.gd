class_name StatUISlider extends TextureProgressBar


@export var stat_name: String
@export var stat_object: StatObject


func _assign_stat_to_slider() -> void:
	if stat_object != null:
		var stat_to_show = stat_object.get_or_create_stat(stat_name)
		min_value = stat_to_show.min_value
		max_value = stat_to_show.max_value
		value = stat_to_show.get_modified_value()
		stat_to_show.connect("stat_changed", _stat_changed)
		stat_to_show.connect("stat_min_changed", _stat_min_changed)
		stat_to_show.connect("stat_max_changed", _stat_max_changed)
		self.visible = true


func _stat_changed(_old_value : float, new_value : float, _increased : bool) -> void:
	value = new_value
	

func _stat_min_changed(_old_min : float, new_min : float) -> void:
	min_value = new_min


func _stat_max_changed(_old_max : float, new_max : float) -> void:
	max_value = new_max


func _on_battle_slot_occupier_changed(new_occupier: WeakRef) -> void:
	if new_occupier == null or new_occupier.get_ref() == null:
		self.visible = false
		return
	var new_unit = new_occupier.get_ref() as Unit
	if new_unit != null:
		stat_object = new_unit.stat_object
		_assign_stat_to_slider()
