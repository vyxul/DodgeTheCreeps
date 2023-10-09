extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _input(event : InputEvent):
#	if (event.is_action_pressed("ui_cancel")):
#		hide()
#		print("Pause_Menu | _input(): Unpausing game")
#		get_tree().paused = false


func _on_game_manager_toggle_game_paused(is_paused):
	if (is_paused):
		show()
	else:
		hide()
