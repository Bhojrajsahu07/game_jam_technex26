extends StaticBody2D

func on_interact():
	# Check if they picked up the axe/saw in the GameManager
	if GameManager.has_hammer == true: 
		SignalBus.display_interaction_text.emit("You cleared the way chopping through the boards!")
		
		# This instantly deletes the entire StaticBody2D and ALL sprites inside it
		queue_free()
		
	else:
		# If they interact WITHOUT the hammer
		SignalBus.display_interaction_text.emit("The way is obstructed!...seems i need a tool....a hammer maybe!",GameManager.PLAYER_FACE)
		
