extends Control

signal playButtonPressed(levelWon: bool)
signal menuButtonPressed
signal exitButtonPressed

var levelWon: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setLevelWon(value: bool):
	levelWon = value

func _on_game_manager_toggle_level_end(level_ended):
	if (level_ended):
		var message: String
		
		if (levelWon):
			message = "Level Won"
			setMessage(message)
			setButton("Next Level")
		else:
			message = "Level Lost"
			setMessage(message)
			setButton("Retry")
			
		show()
	else:
		hide()

func setMessage(text: String):
	$Panel/VBoxContainer/Message.text = text
	
func setButton(text: String):
	$Panel/VBoxContainer/PlayButton.text = text

func _on_play_button_pressed():
	print("LevelEndScreen | _on_play_button_pressed()")
	playButtonPressed.emit(levelWon)

func _on_menu_button_pressed():
	print("LevelEndScreen | _on_menu_button_pressed()")
	menuButtonPressed.emit()

func _on_exit_button_pressed():
	print("LevelEndScreen | _on_exit_button_pressed()")
	exitButtonPressed.emit()
