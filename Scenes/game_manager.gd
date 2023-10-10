extends Node

"""
To pause a game, need to set the tree's paused property to true.
When it is paused, child nodes within that tree won't execute their
_process(), _physics_process(), and _input() methods anymore until unpaused.

Nodes can choose to have their process modes set as:
	Inherit
		Same process mode as it's immediate parent node
	Pausable
		Runs the above methods when game is not paused
	When Paused
		Runs the above methods when game is paused
	Always
		Runs the above methods without caring about if game is paused or not
	Disable
		Doesn't run the above methods ever
		
This game implements pause by checking within the GameManager root node's _input() for if the pause
button is pressed to change the GameManager's boolean property (game_paused) to its opposite value.

The setter for game_paused has been overriden to change the tree's paused property to whatever the
new game_paused value is and also emits a signal "toggle_game_paused" along with an argument, the
new value of game_paused, to allow any interested components to execute code based on that signal.

For this implementation, the pause_menu component will have a function that checks for when that
signal is emitted and checks the argument and based on if it is true or false, it will either show
or hide everything within that component.
""" 

"""
To Do List:
	Make mobs spawn from outer edge instead of inside screen (DONE)
	Start Menu
		Start Button (done, goes to level_1, can be adjusted)
		Settings Button
		How to Play Button
		Exit Button (done)
	Pause Menu
		Pause game when pressing ESCAPE (done)
		Resume Button (done)
		Settings Button
		Exit Button (done)
	Level End Screen
		Different text based off of win/loss condition (done)
		Continue/Retry Button
			Continue (need to make level2 or redirect to start)
			Retry (Done, deathsound is messed up)
		Main Menu Button (done)
		Exit Button (done)
		
	Restructure the game to fit better with GameManager root node, 
		ie Music being managed there, allowing multiple levels, etc
		Level Switch (done)
		Music being managed in GameManager (done)
	Add ability to slow down mobs
	Add settings to adjust music volume and mob speed
		Create settings menu
		Link settings menu changes to actual nodes
	Create how to play menu
	Make dragon ball have a shiny animation on spawn
	???
"""

signal toggle_game_paused(is_paused: bool)
signal toggle_level_end(level_ended: bool)

var next_level_resource
var next_level
var currentlevelNum
var currentlyInGame: bool

var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

var level_ended: bool = false:
	get:
		return level_ended
	set(value):
		level_ended = value
		get_tree().paused = level_ended
		toggle_level_end.emit(level_ended)

# Called when the node enters the scene tree for the first time.
func _ready():
	currentlyInGame = false
	var music = $Music
	music.set_volume_db(-20)
	music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called every time there is an input event
func _input(event : InputEvent):
	"""
	Another way to implement is within the _process() method, can use
	Input.is_action_just_released("ui_cancel") to check for input instead.
	That way is not as efficient since process() is called every frame and will
	be checking for an input that doesn't happen often, whereas _input() isn't
	called as often which works good for this case
	"""
	if (event.is_action_pressed("ui_cancel") && currentlyInGame):
		print("GameManager | _input(): Toggling game state")
		game_paused = !game_paused
		print("game_paused: %s" % game_paused)

# When the player successfully completes a level
func levelCompleted(levelNum):
	print("Received the levelWon signal with a level num of %d"  % levelNum)
	$CanvasLayer/LevelEndScreen.setLevelWon(true)
	currentlevelNum = levelNum
	currentlyInGame = false
	level_ended = true

func levelFailed(levelNum):
	print("Received the levelLost signal with a level num of %d"  % levelNum)
	$CanvasLayer/LevelEndScreen.setLevelWon(false)
	currentlevelNum = levelNum
	currentlyInGame = false
	level_ended = true
	
func goBackToStartMenu():
	# Remove the current level scene
	var currentLevel = $Level.get_child(0)
	currentLevel.queue_free()
	
	# Load the start menu with the signal connections
	next_level_resource = load("res://Scenes/start_menu.tscn")
	next_level = next_level_resource.instantiate()
	next_level.StartButtonPressed.connect(_on_start_menu_start_button_pressed)
	next_level.SettingsButtonPressed.connect(_on_start_menu_settings_button_pressed)
	next_level.HowToPlayButtonPressed.connect(_on_start_menu_how_to_play_button_pressed)
	next_level.ExitButtonPressed.connect(_on_start_menu_exit_button_pressed)
	$Level.add_child(next_level)
	
	# Toggle the pause and level end flags to false
	currentlyInGame = false
	level_ended = false

""" Start Menu Events """
func _on_start_menu_start_button_pressed():
	print("GameManager | StartButton pressed")
	$Level/StartMenu.queue_free()
	next_level_resource = load("res://Scenes/level_1.tscn")
	next_level = next_level_resource.instantiate()
	next_level.levelWon.connect(levelCompleted.bind())
	next_level.levelLost.connect(levelFailed.bind())
	$Level.add_child(next_level)
	currentlyInGame = true
	
func _on_start_menu_settings_button_pressed():
	print("GameManager | StartMenu.SettingsButtonPressed received")

func _on_start_menu_how_to_play_button_pressed():
	print("GameManager | StartMenu.HowToPlayButtonPressed received")

func _on_start_menu_exit_button_pressed():
	print("GameManager | StartMenu.ExitButtonPressed received")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


""" Pause Menu Events """
func _on_pause_menu_resume_button_pressed():
	print("GameManager | PauseMenu.ResumeButtonPressed received")
	print("GameManager | _on_pause_menu_resume_button_pressed(): Toggling game state")
	game_paused = !game_paused
	print("game_paused: %s" % game_paused)

func _on_pause_menu_settings_button_pressed():
	print("GameManager | PauseMenu.SettingsButtonPressed received")

func _on_pause_menu_exit_button_pressed():
	print("GameManager | PauseMenu.ExitButtonPressed received")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
	
	
""" Level End Events """
func _on_level_end_screen_play_button_pressed(levelWon: bool):
	print("GameManager | PauseMenu.ResumeButtonPressed received with parameter of %s" % str(levelWon))
	# Check if level won is true or false
	# If player completed level, move onto next level
	if (levelWon):
		print("GameManager | _on_level_end_screen_play_button_pressed(): Next level not implemented yet")
	# If player failed level, reset the current level
	else:
		print("GameManager | _on_level_end_screen_play_button_pressed(): Resetting level and unpausing")
		next_level.newGame()
		level_ended = false
		currentlyInGame = true

func _on_level_end_screen_menu_button_pressed():
	print("GameManager | PauseMenu.ResumeButtonPressed received")
	goBackToStartMenu()
	

func _on_level_end_screen_exit_button_pressed():
	print("GameManager | PauseMenu.ResumeButtonPressed received")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
