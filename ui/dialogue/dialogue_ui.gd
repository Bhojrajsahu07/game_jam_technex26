extends CanvasLayer

@onready var box = $DialogueBox
@onready var text_label = $DialogueBox/RichTextLabel 
@onready var portrait = $Portrait
@onready var timer = $Timer

const TYPE_SPEED = 0.03 

var is_active = false
var is_typing = false
var full_text = ""
var text_queue: Array = [] # This holds all our extra pages!

func _ready():
	box.visible = false
	portrait.visible = false
	SignalBus.display_interaction_text.connect(start_dialogue)
	
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)

# 'text_data' can now be a single String OR an Array of Strings
# We changed the name of the second parameter to 'default_face'
func start_dialogue(text_data: Variant, default_face: Texture2D = null):
	text_queue.clear() # Empty the queue from the last conversation
	
	# 1. Did we get a single string? (Like your saw)
	if typeof(text_data) == TYPE_STRING:
		text_queue.append({"text": text_data, "face": default_face})
		
	# 2. Did we get an Array? (Like your crushed paper)
	elif typeof(text_data) == TYPE_ARRAY:
		for item in text_data:
			if typeof(item) == TYPE_STRING:
				# It's just a basic string, use the default face
				text_queue.append({"text": item, "face": default_face})
			elif typeof(item) == TYPE_DICTIONARY:
				# It's a dictionary! Grab its specific face, or use null if it doesn't have one
				var specific_face = item.get("face", null)
				text_queue.append({"text": item["text"], "face": specific_face})
	
	box.visible = true
	is_active = true
	show_next_page()

func show_next_page():
	# Pop the dictionary for this specific page
	var current_page = text_queue.pop_front()
	full_text = current_page["text"]
	
	# Check if THIS page has a face!
	var face = current_page["face"]
	if face != null:
		portrait.texture = face
		portrait.visible = true
	else:
		portrait.visible = false
		
	text_label.text = full_text
	text_label.visible_characters = 0 
	
	is_typing = true
	timer.start(TYPE_SPEED)
	
	await get_tree().create_timer(0.1).timeout

func _on_timer_timeout():
	if is_typing:
		text_label.visible_characters += 1
		if text_label.visible_characters >= full_text.length():
			is_typing = false
			timer.stop()

func _process(_delta):
	if not is_active:
		return
		
	if Input.is_action_just_pressed("interact"):
		if is_typing:
			# If it's still typing, skip to the end of the current page
			is_typing = false
			timer.stop()
			text_label.visible_characters = full_text.length()
		else:
			# If done typing, check if we have more pages!
			if text_queue.size() > 0:
				show_next_page()
			else:
				close_dialogue()

func close_dialogue():
	box.visible = false
	portrait.visible = false
	is_active = false
	is_typing = false
	timer.stop()
	text_label.text = ""
