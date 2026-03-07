extends StaticBody2D

func on_interact():
	# Check if they picked up the axe/saw in the GameManager
	if GameManager.has_saw == true: 
		SignalBus.display_interaction_text.emit("You chopped through the boards!")
		
		# This instantly deletes the entire StaticBody2D and ALL sprites inside it
		queue_free()
		
	else:
		# If they interact WITHOUT the axe
		SignalBus.display_interaction_text.emit("It's boarded up tight. I need an axe.")
