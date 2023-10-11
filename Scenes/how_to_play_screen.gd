extends Control

@onready var popup = $Window
@onready var initialPos = popup.get_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	popup_hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		popup.set_position(initialPos)

func _on_window_close_requested():
	popup_hide()

func _on_close_button_pressed():
	print("HowToPlayScreen | _on_close_button_pressed")
	popup_hide()

func popup_hide():
	popup.hide()
	$Window/Panel/PlayerIcon.stop()
	
func popup_show():
	popup.show()
	$Window/Panel/PlayerIcon.play()

