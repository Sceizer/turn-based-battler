class_name Stat extends Object

# Whenever the stat value has changed call this
signal stat_changed(old_value : float, new_value : float, increased : bool)
# Whenever the stat value is changed and reached min_stat call this
signal stat_depleted()
# Whenever the stat value is changed and reached max_stat call this
signal stat_restored()
# Whenever the stat's min value is changed call this
signal stat_min_changed(old_min : float, new_min : float)
# Whenever the stat's max value is changed call this
signal stat_max_changed(old_max : float, new_max : float)

const FLOAT_MAX =  1.79769e308
const FLOAT_MIN = -1.79769e308

var base_value : float:
	get:
		return base_value
	set(value):
		var clamped_value = clampf(value, min_value, max_value)
		if clamped_value == base_value:
			return
			
		base_value = clamped_value
		calc_stat_modifiers()
		
		if base_value == min_value:
			stat_depleted.emit()
		elif base_value == max_value:
			stat_restored.emit()
		
		
# Stat value cannot fall under this number
var min_value : float:
	get:
		return min_value
	set(value):
		if value == min_value:
			return
	
		stat_min_changed.emit(min_value, value)
		min_value = value
	
		if min_value >= max_value:
			max_value = min_value + 1
			
		if base_value < min_value:
			base_value = min_value
		
		
# Stat value cannot go above this number
var max_value : float:
	get:
		return max_value
	set(value):
		if value == max_value:
			return
	
		stat_max_changed.emit(max_value, value)
		max_value = value
	
		if max_value <= min_value:
			min_value = max_value - 1
			
		if base_value > max_value:
			base_value = max_value
		
var _modifiers : Array[StatModifier]
var _modifier_value : float


func initialize(in_base : float= 0, in_min : float = FLOAT_MIN, in_max : float = FLOAT_MAX) -> void:
	min_value = in_min
	max_value = in_max
	base_value = clampf(in_base, in_min, in_max)
	_modifier_value = base_value	


func get_base_value() -> float:
	return base_value


func get_modified_value() -> float:
	return _modifier_value


func set_value_delta(delta : float) -> void:
	if delta == 0:
		return
		
	var NewValue = base_value + delta
	base_value = NewValue


func apply_modifier(stat_modifier : StatModifier) -> void:
	_modifiers.append(stat_modifier)
	calc_stat_modifiers()


func remove_modifier(stat_modifier : StatModifier) -> void:
	_modifiers.erase(stat_modifier)
	calc_stat_modifiers()


func calc_stat_modifiers() -> void:
	var new_modifier_value = base_value
	for modifier in _modifiers:
		new_modifier_value = modifier.apply_modifier(new_modifier_value)
	new_modifier_value = clampf(new_modifier_value, min_value, max_value)
	
	if new_modifier_value != _modifier_value:
		stat_changed.emit(_modifier_value, new_modifier_value, new_modifier_value > _modifier_value)
		_modifier_value = new_modifier_value
