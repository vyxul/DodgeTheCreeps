extends CanvasLayer

signal gameOverSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_message(text: String, time: int = 2):
	$Control/Panel/PanelMessage.text = text
	$Control/Panel.show()
	
	$Control/Panel/MessageTimer.wait_time = time
	$Control/Panel/MessageTimer.one_shot = true
	$Control/Panel/MessageTimer.start()
	
func hide_message():
	$Control/Panel.hide()
	
func show_game_over():
	show_message("Game Over")
	$Control/GameOverMessageTimer.start()
	
func update_score(score):
	$Control/ScoreLabel.text = str(score)

func _on_game_over_message_timer_timeout():
	gameOverSignal.emit()

func _on_message_timer_timeout():
	hide_message()
