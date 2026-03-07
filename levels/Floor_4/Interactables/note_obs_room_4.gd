extends StaticBody2D

func on_interact():
	GameManager.has_crushed_paper = true
	
	# Look at this beautiful data structure!
	var pages = [
		{
			"text": "Picked up the note!", 
			"face": null # No portrait for this page
		},
		{
			"text": "What!...The Note says\n You shouldn't have found this!", 
			"face": GameManager.PLAYER_FACE # Pop the portrait up for this page!
		}
	]
	
	# Send our dictionary array to the UI!
	SignalBus.display_interaction_text.emit(pages, null)
	
	queue_free()
	
