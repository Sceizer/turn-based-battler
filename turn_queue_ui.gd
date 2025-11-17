extends HBoxContainer

func display_turn_queue(turn_order : Array[TurnNotifier]) -> void:
	
	var current_labels = get_children().filter(func(child): return child is Label)
	while current_labels.size() < turn_order.size():
		var new_label = Label.new()
		current_labels.append(new_label)
		add_child(new_label)
	
	for index in turn_order.size():
		current_labels[index].text = turn_order[index].name
