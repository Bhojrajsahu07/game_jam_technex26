extends CharacterBody2D

const SPEED = 150.0

# Grab references to our child nodes
@onready var anim = $AnimatedSprite2D
@onready var interact_ray = $InteractRay

# We store this so the player knows which way to idle when they stop moving
var last_direction = "front" 

func _physics_process(_delta):
	# 1. Get movement input (returns a normalized Vector2)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Apply movement
	velocity = direction * SPEED
	move_and_slide()
	
	# 3. Handle visuals and raycast direction
	update_animation(direction)
	update_interact_ray(direction)

func _process(_delta):
	# 4. Check for the interact button press
	if Input.is_action_just_pressed("interact"):
		try_interact()

func update_animation(dir: Vector2):
	# If not moving, play the idle animation for our last known direction
	if dir == Vector2.ZERO:
		anim.play("idle_" + last_direction)
	else:
		# Determine the primary axis of movement to pick the right animation
		if abs(dir.x) > abs(dir.y):
			last_direction = "right" if dir.x > 0 else "left"
		else:
			last_direction = "front" if dir.y > 0 else "back"
			
		anim.play("run_" + last_direction)

func update_interact_ray(dir: Vector2):
	# If we are moving, point the raycast 20 pixels in that direction
	if dir != Vector2.ZERO:
		interact_ray.target_position = dir.normalized() * 20

func try_interact():
	# If the raycast is touching a physics body/area
	if interact_ray.is_colliding():
		# Get the specific object the raycast is hitting
		var target = interact_ray.get_collider()
		
		# Check if that object has a custom function called 'on_interact'
		if target.has_method("on_interact"):
			target.on_interact()
