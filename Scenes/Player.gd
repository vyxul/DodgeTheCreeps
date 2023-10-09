extends Area2D

# How fast the player will move (pixels/sec).
# The export keyword allows us to modify the variable in the Inspector panel
@export var speed = 400 
# Size of the game window
var screen_size
signal hit

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$CollisionShape2D.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
#	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# The player's movement vector
	# Initialize as zero for if play didn't give input during a frame to prevent movement
	var velocity = Vector2.ZERO
	
	# Check for if input was given and perform action
	# Max of (1, 1) for if up and right and min of (-1, -1) for if down and left
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x += -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y += -1
		
	# If both x and y have a absolute value of 1, then the player would move faster diagonally
	# then if it was horizontal. To prevent this, we normalize the vector, which sets the length to 1,
	# then multiply by the speed
	# Also checks if the player is moving to choose to play animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $ is shorthand for get_node()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# Use clamp() to restrict the range of the node in a certain range
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# if moving left or right
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# if velocity.x == -1, then it is moving left, flip horizontally
		$AnimatedSprite2D.flip_h = velocity.x < 0
	# if moving up or down
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		# if velocity.y == 1, then it is moving down, flip vertically
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(body):
	hide() # Player disappears after being hit
	hit.emit() # Emit the custom hit signal
	# Must be deferred as we can't change physics properties on a physics callback
	# Disable the player's collision so we don't trigger the hit signal more than once
	# set_deferred() tells Godot to wait to disable the shape until it's safe to do so
	$CollisionShape2D.set_deferred("disabled", true)
