extends Control

signal resumeButtonPressed
signal settingsButtonPressed
signal exitButtonPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_game_manager_toggle_game_paused(is_paused):
	if (is_paused):
		show()
	else:
		hide()

func _on_resume_button_pressed():
	print("PauseMenu | _on_resume_button_pressed()")
	resumeButtonPressed.emit()

func _on_settings_button_pressed():
	print("PauseMenu | _on_settings_button_pressed()")
	settingsButtonPressed.emit()

func _on_exit_button_pressed():
	print("PauseMenu | _on_exit_button_pressed()")
	exitButtonPressed.emit()
