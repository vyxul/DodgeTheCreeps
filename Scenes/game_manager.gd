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
signal toggle_game_paused(is_paused: bool)
var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	if (event.is_action_pressed("ui_cancel")):
		print("GameManager | _input(): Toggling game state")
		game_paused = !game_paused
		print("game_paused: %s" % game_paused)
