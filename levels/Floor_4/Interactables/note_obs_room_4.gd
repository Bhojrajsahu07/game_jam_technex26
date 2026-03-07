extends StaticBody2D

func on_interact():
	# 1. Update the inventory in your Game Manager
	GameManager.has_note_obs_room_4 = true
	
	# 2. Tell the UI to pop up the text
	SignalBus.display_interaction_text.emit("Picked up the note!")
	SignalBus.display_interaction_text.emit("You shouldn't have found this!")
	
	# 3. Delete the note (This instantly deletes the Sprite, Collision, AND Light!)
	queue_free()
