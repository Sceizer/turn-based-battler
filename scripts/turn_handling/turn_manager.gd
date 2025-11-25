class_name TurnManager extends Node

signal new_turn_order(turn_order : Array[TurnNotifier])
signal next_turn(next_in_order : TurnNotifier)
signal on_tracker_removed(removed_tracker : TurnNotifier)

const CURR_ACTIVE_TURN = "Current Active Turn"
const TRACKER_REMAPPED_SPEEDS = "Tracker Remapped Speeds"
const INITIATIVE_TRACKERS = "Initiative Trackers"

@export var predict_turn_amount : int= 5

var highest_speed : float= 0
var active_trackers : Array[TurnNotifier]
var current_turn : Dictionary= {
	CURR_ACTIVE_TURN: null,
	TRACKER_REMAPPED_SPEEDS: {},
	INITIATIVE_TRACKERS: {},
}
var precalculated_turns : Array[Dictionary]

var turn_order : Array[TurnNotifier]


func load_trackers_from_array(trackers_to_load: Array) -> void:
	active_trackers.assign(trackers_to_load.filter(func(child): return child is TurnNotifier))
	active_trackers.sort_custom(func(trackA, trackB) : return trackA.get_speed() > trackB.get_speed())
	
	highest_speed = active_trackers[0].get_speed()
	current_turn[CURR_ACTIVE_TURN] = active_trackers[0]
	turn_order.append(active_trackers[0])
	for tracker in active_trackers:
		tracker.connect("on_finish_turn", finish_turn)
		current_turn[TRACKER_REMAPPED_SPEEDS][tracker] = tracker.get_speed() / highest_speed
		current_turn[INITIATIVE_TRACKERS][tracker] = current_turn[TRACKER_REMAPPED_SPEEDS][tracker]
	
	calc_turn_order_up_to_limit()
	start_current_turn()


func initialize() -> void:	
	active_trackers.assign(get_children().filter(func(child): return child is TurnNotifier))
	active_trackers.sort_custom(func(trackA, trackB) : return trackA.get_speed() > trackB.get_speed())
	
	highest_speed = active_trackers[0].get_speed()
	current_turn[CURR_ACTIVE_TURN] = active_trackers[0]
	turn_order.append(active_trackers[0])
	for tracker in active_trackers:
		current_turn[TRACKER_REMAPPED_SPEEDS][tracker] = tracker.get_speed() / highest_speed
		current_turn[INITIATIVE_TRACKERS][tracker] = current_turn[TRACKER_REMAPPED_SPEEDS][tracker]
	
	calc_turn_order_up_to_limit()
	start_current_turn()


func start_current_turn() -> void:
	current_turn[CURR_ACTIVE_TURN].start_turn()
	next_turn.emit(current_turn[CURR_ACTIVE_TURN])


func finish_turn() -> void:
	current_turn = precalculated_turns.pop_front()
	turn_order.pop_front()
	calc_turn_order_up_to_limit()
	start_current_turn()
	

func remove_tracker(tracker_to_remove: TurnNotifier) -> void:
	var tracker_id = active_trackers.find(tracker_to_remove)
	if tracker_id != -1:
		active_trackers.remove_at(tracker_id)
		calc_turn_order_up_to_limit(true)
		on_tracker_removed.emit(tracker_to_remove)
		

func calc_turn_order_up_to_limit(erase_prev_order: bool= false) -> void:
	if erase_prev_order:
		precalculated_turns.clear()
		turn_order.clear()
		turn_order.append(current_turn[CURR_ACTIVE_TURN])
	var prev_turn = precalculated_turns[precalculated_turns.size() - 1].duplicate(true) if not precalculated_turns.is_empty() else current_turn.duplicate(true)
	while precalculated_turns.size() < predict_turn_amount - 1:
		var curr_turn = prev_turn
		curr_turn[INITIATIVE_TRACKERS][curr_turn[CURR_ACTIVE_TURN]] = 0.0
		var fastest_time_to_ready = 999.0
		for tracker in active_trackers:
			var current_initiative = curr_turn[INITIATIVE_TRACKERS][tracker]
			var remapped_speed = curr_turn[TRACKER_REMAPPED_SPEEDS][tracker]
			var time_to_ready = (1.0 - current_initiative) / remapped_speed
			if time_to_ready < fastest_time_to_ready:
				curr_turn[CURR_ACTIVE_TURN] = tracker
				fastest_time_to_ready = time_to_ready
				
		for tracker in active_trackers:
			curr_turn[INITIATIVE_TRACKERS][tracker] += curr_turn[TRACKER_REMAPPED_SPEEDS][tracker] * fastest_time_to_ready
		precalculated_turns.append(curr_turn)
		
		turn_order.append(curr_turn[CURR_ACTIVE_TURN])
		prev_turn = curr_turn.duplicate(true)
	new_turn_order.emit(turn_order)
