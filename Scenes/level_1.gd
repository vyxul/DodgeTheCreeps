extends Node

signal levelWon(levelNum: int)
signal levelLost(levelNum: int)

@export var pointsToWin: int = 5
@export var mobSpawnMax: int = 5
@export var mobMinSpeed: int = 150
@export var mobMaxSpeed: int = 250
@export var pointSpawnMax: int = 1
@export var pointGoal: int = 7
@export var mob_scene: PackedScene

var levelNum = 1
var currentPoints: int
var mobsSpawned: int
var pointsSpawned: int
var pointsGained: int
var pointCounter: int
var screen_size

const DragonBall = preload("res://Scenes/dragon_ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
#	screen_size = DisplayServer.screen_get_size()
	screen_size = get_viewport().content_scale_size
	print("level_1 | _ready(): screen_size = (%s , %s)" % [str(screen_size.x), str(screen_size.y)])
	newGame()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func newGame():
	currentPoints = 0
	mobsSpawned = 0
	pointsSpawned = 0
	pointsGained = 0
	pointCounter = 0
	$Player.start($StartPosition.position)
	var message: String = "Collect %d dragon balls to complete level!" % pointGoal
	$HUD.show_message(message)
	$MessageTimer.start()
	
func _on_message_timer_timeout():
#	$HUD.hide_message()
	$StartTimer.start()

# How much breathing time to give player after message disappears before mob spawn system starts
func _on_start_timer_timeout():
	$MobSpawnTimer.start()
	$PointTimer.start()

# How often mobs spawn, limited by mobSpawnMax
func _on_mob_spawn_timer_timeout():
#	print("mobsSpawned = %d, mobSpawnMax = %d" % [mobsSpawned, mobSpawnMax])
	
	# Check if mob spawn count has reached the limit
	if (mobsSpawned >= mobSpawnMax):
#		print("mobsSpawned has reached the limit, not making any more, returning from function")
		return
	
	# Create instance of a mob
	var mob = mob_scene.instantiate()
	mobsSpawned += 1
	
	# Find where to spawn the mob
	var mobSpawnLocation = $MobPath/MobSpawnLocation
	mobSpawnLocation.progress_ratio = randf() # Choose a random point on the path
	mob.position = mobSpawnLocation.position # Give the randomly chosen point's coordinates to mob
	
	# Set the direction for the mob to face (90 degree or PI/2 to point directly within screen)
	var direction = mobSpawnLocation.rotation + (PI/2)
#	var direction = mobSpawnLocation.rotation + (deg_to_rad(90)/2) # Using degree instead of radians
	# Adjust the direction randomly based off of the base direction to add variety in gameplay
	direction += randf_range(-PI / 4, PI / 4) # Changes direction between -45 degrees to 45 degrees
	mob.rotation = direction
	
	# Randomly set the velocity for the instantiated mob
	var velocity = Vector2(randf_range(mobMinSpeed, mobMaxSpeed), 0) # This only gets the speed, not direction
	mob.linear_velocity = velocity.rotated(direction) # This adjusts velocity to account for direction
	
	add_child(mob)
	mob.mobExitedScreen.connect(mobExitedScreen) # Recommended way
#	mob.connect("mobExitedScreen", mobExitedScreen) # Alternative way, not recommended
#   Recommended way is to do Signal.connect(...) instead of Object.connect(signal, ...)

# When a mob exits the screen, decrement the counter watching over that
func mobExitedScreen():
#	print("Received signal that mob exited screen, decrementing mobsSpawned")
	mobsSpawned -= 1

# Spawn point node based on interval from PointTimer wait time
func _on_point_timer_timeout():
#	print("in point_timer_timeout")
#	print("pointsSpawned = %d, pointsSpawnMax = %d" % [pointsSpawned, pointSpawnMax])
	
	if (pointsSpawned >= pointSpawnMax):
#		print("pointsSpawned reached the limit, not creating any more")
		return
		
	var dragonball = DragonBall.instantiate()
	pointsSpawned += 1
	pointCounter += 1
	var position = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
	dragonball.position = position
	dragonball.name = "DragonBall_" + str(pointCounter)
	add_child(dragonball)

# Player touched point
func _on_player_hit_point(instanceId: int):
	print("Level_1 | _on_player_hit_point()")

	var pointNode = instance_from_id(instanceId)
	pointsGained += 1
	pointsSpawned -= 1
	$HUD.update_score(pointsGained)
	pointNode.queue_free()
	
	# Send signal that player finished level
	if (pointsGained >= pointGoal):
		print("%d Dragon Balls collected! Complete" % pointsGained)
		var message = "Level Complete!"
		$HUD.show_message(message, 2)
		emit_signal("levelWon", levelNum)
		return

# Player hit an enemy
func _on_player_hit_enemy():
	print("Level_1 | _on_player_hit_enemy()")
	$DeathSound.set_volume_db(1.0)
	$DeathSound.play()
	
	# Send signal that player finished level
	levelLost.emit(levelNum)
