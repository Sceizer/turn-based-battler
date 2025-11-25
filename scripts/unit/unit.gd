@tool
class_name Unit extends TurnNotifier

const HEALTH_STRING_ID : String= "HEALTH"
const ATTACK_STRING_ID : String= "ATTACK"
const DEFENSE_STRING_ID : String= "DEFENSE"
const SPEED_STRING_ID : String= "SPEED"

@export var stat_object : StatObject

@export var unit_stats : UnitStats:
	set(value):
		unit_stats = value
		name = unit_stats.unit_name
		if not Engine.is_editor_hint():
			if stat_object == null:
				stat_object = StatObject.new()
				add_child(stat_object)
			health_stat = stat_object.get_or_create_stat(HEALTH_STRING_ID, 
														unit_stats.default_health, 
														0, 
														unit_stats.default_health,
														true)
			attack_stat = stat_object.get_or_create_stat(ATTACK_STRING_ID, unit_stats.default_attack, 
														Stat.FLOAT_MIN, 
														Stat.FLOAT_MAX, 
														true)
			defense_stat = stat_object.get_or_create_stat(DEFENSE_STRING_ID, 
														unit_stats.default_defense, 
														Stat.FLOAT_MIN, 
														Stat.FLOAT_MAX, 
														true)
			speed_stat = stat_object.get_or_create_stat(SPEED_STRING_ID, 
														unit_stats.default_speed, 
														Stat.FLOAT_MIN, 
														Stat.FLOAT_MAX, 
														true)

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

@export var unit_control_scene: PackedScene:
	set(value):
		unit_control_scene = value
		if not is_inside_tree():
			await ready
		if controller:
			controller.queue_free()
			controller = null
		
		if unit_control_scene:
			var new_control_scene = unit_control_scene.instantiate()
			controller = new_control_scene as UnitController
			if not controller:
				push_warning("Unit '%s' cannot accept '%s' as " % [name, unit_control_scene.name],
					"unit_controller. '%s' is not a UnitAnim" % new_control_scene.name)
				new_control_scene.free()
				unit_control_scene = null
				return
				
			add_child(controller)

var battle_manager: BattleManager = null

var health_stat : Stat
var attack_stat : Stat
var defense_stat : Stat
var speed_stat : Stat
var team: int

var anim : UnitAnim
var controller: UnitController

func _init() -> void:
	if Engine.is_editor_hint():
		set_process(false)

func get_speed() -> float:
	return speed_stat.get_modified_value()


func start_turn() -> void:
	super.start_turn()
	print("%s: Starting My Turn" % [name])


func _ready() -> void:
	health_stat.connect("stat_depleted", _on_health_depleted)



func finish_turn() -> void:
	super.finish_turn()


func _on_health_depleted() -> void:
	battle_manager.remove_unit(self)
	if anim.animation_player.is_playing():
		await anim.animation_player.animation_finished
	self.queue_free()
