extends Control

var GameTitleLength: int
var charsShown: int = 0

signal StartButtonPressed
signal SettingsButtonPressed
signal HowToPlayButtonPressed
signal ExitButtonPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	GameTitleLength = $GameTitle.get_total_character_count()
	$GameTitle.visible_characters = 0
	$GameTitleTimer.start()
	$Panel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_title_timer_timeout():
	if (charsShown == GameTitleLength):
		$GameTitleTimer.stop()
#		print("charsShown = %d, GameTitleLength = %d" % [charsShown, GameTitleLength])
#		print("Stopping timer")
	else:
		charsShown += 1
#		print("charsShown = %d, GameTitleLength = %d" % [charsShown, GameTitleLength])
#		print("Keep going")
		$GameTitle.visible_characters = charsShown
		$PanelTimer.start()


func _on_start_button_pressed():
	print("StartMenu | StartButton pressed")
	emit_signal("StartButtonPressed")
	pass # Replace with function body.


func _on_settings_button_pressed():
	print("StartMenu | SettingsButton pressed")
	emit_signal("SettingsButtonPressed")
	pass # Replace with function body.


func _on_how_to_play_button_pressed():
	print("StartMenu | HowToPlayButton pressed")
	emit_signal("HowToPlayButtonPressed")
	pass # Replace with function body.


func _on_exit_button_pressed():
	print("StartMenu | ExitButton pressed")
	emit_signal("ExitButtonPressed")
	pass # Replace with function body.


func _on_panel_timer_timeout():
	$Panel.show()
