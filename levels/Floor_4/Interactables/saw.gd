extends StaticBody2D

func on_interact():
	# 1. Update the inventory in your Game Manager
	GameManager.has_saw = true
	
	# 2. Tell the UI to pop up the text
	SignalBus.display_interaction_text.emit("Picked up the saw!")
	
	# 3. Delete the saw (This instantly deletes the Sprite, Collision, AND Light!)
	queue_free()
