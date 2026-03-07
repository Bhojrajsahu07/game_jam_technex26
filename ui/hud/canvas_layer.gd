extends CanvasLayer

# Grab the Label node
@onready var interaction_label = $InteractionLabel

func _ready():
	# 1. Make the text invisible the moment the game starts
	interaction_label.modulate.a = 0
	
	# 2. Tell the HUD to listen to the SignalBus for any incoming messages
	SignalBus.display_interaction_text.connect(_on_display_interaction_text)

func _on_display_interaction_text(message: String):
	# Change the label's text to whatever the Saw or Door sent
	interaction_label.text = message
	
	# Create a Tween to handle the fading animation
	var tween = create_tween()
	
	# Step A: Fade the text IN super fast (0.2 seconds)
	tween.tween_property(interaction_label, "modulate:a", 1.0, 0.2)
	
	# Step B: Leave it fully visible on screen for 2.5 seconds so they can read it
	tween.tween_interval(2.5)
	
	# Step C: Fade the text OUT smoothly (0.5 seconds)
	tween.tween_property(interaction_label, "modulate:a", 0.0, 0.5)
