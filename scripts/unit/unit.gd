@tool
class_name Unit extends TurnNotifier

const HEALTH_STRING_ID : String= "HEALTH"
const ATTACK_STRING_ID : String= "ATTACK"
const DEFENSE_STRING_ID : String= "DEFENSE"
const SPEED_STRING_ID : String= "SPEED"

@export var stat_object : StatObject
@export var unit_stats : UnitStats

@export var unit_anim_scene : PackedScene:
	set(value):
		unit_anim_scene = value
		
		if not is_inside_tree():
			await ready
		
		if anim:
			anim.queue_free()
			anim = null
		
		if unit_anim_scene:
			var new_anim_scene = unit_anim_scene.instantiate()
			anim = new_anim_scene as UnitAnim
			if not anim:
				push_warning("Unit '%s' cannot accept '%s' as " % [name, unit_anim_scene.name],
					"unit_anim. '%s' is not a UnitAnim" % new_anim_scene.name)
				new_anim_scene.free()
				unit_anim_scene = null
				return
				
			add_child(anim)

var health_stat : Stat
var attack_stat : Stat
var defense_stat : Stat
var speed_stat : Stat

var anim : UnitAnim

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
	else:
		if not stat_object == null:
			health_stat = stat_object.get_or_create_stat(HEALTH_STRING_ID, 
														unit_stats.default_health, 
														0, 
														unit_stats.default_health)
			attack_stat = stat_object.get_or_create_stat(ATTACK_STRING_ID, unit_stats.default_attack)
			defense_stat = stat_object.get_or_create_stat(DEFENSE_STRING_ID, unit_stats.default_defense)
			speed_stat = stat_object.get_or_create_stat(SPEED_STRING_ID, unit_stats.default_speed)

func get_speed() -> float:
	return speed_stat.get_modified_value()


func start_turn() -> void:
	print("%s: Starting My Turn" % [name])


func finish_turn() -> void:
	pass
