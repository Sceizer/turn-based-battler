class_name StatObject extends Node


# Stores all stats present on the stat object
var Stats : Dictionary[String, Stat]


# Returns a stat if it exists and creates one if it not yet exists
func get_or_create_stat(stat_name : String, 
						init_value : float=0, 
						min_value : float=Stat.FLOAT_MIN, 
						max_value : float=Stat.FLOAT_MAX,
						override : bool=false) -> Stat:
	if not Stats.has(stat_name):
		Stats[stat_name] = Stat.new()
		Stats[stat_name].initialize(init_value, min_value, max_value)
	elif override:
		Stats[stat_name].base_value = init_value
		Stats[stat_name].min_value = min_value
		Stats[stat_name].max_value = max_value
	return Stats[stat_name]
