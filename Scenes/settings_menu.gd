extends Control

signal saveButton_pressed
signal closeButton_pressed

# Setup variables
# Video Settings
@onready var screen_mode = $MarginContainer/VBoxContainer/TabContainer/Video/MarginContainer/GridContainer/ScreenMode_List
@onready var displayFPS = $MarginContainer/VBoxContainer/TabContainer/Video/MarginContainer/GridContainer/DisplayFPS_Button

# Audio Settings
@onready var master_vol_slider = $MarginContainer/VBoxContainer/TabContainer/Audio/MarginContainer/GridContainer/HBoxContainer/MasterVolSlider
@onready var master_vol_value = $MarginContainer/VBoxContainer/TabContainer/Audio/MarginContainer/GridContainer/HBoxContainer/MasterVolValue
@onready var music_vol_slider = $MarginContainer/VBoxContainer/TabContainer/Audio/MarginContainer/GridContainer/HBoxContainer2/MusicVolSlider
@onready var music_vol_value = $MarginContainer/VBoxContainer/TabContainer/Audio/MarginContainer/GridContainer/HBoxContainer2/MusicVolValue
@onready var sfx_vol_slider = $MarginContainer/VBoxContainer/TabContainer/Audio/MarginContainer/GridContainer/HBoxContainer3/SFXVolSlider
@onready var sfx_vol_value = $MarginContainer/VBoxContainer/TabContainer/Audio/MarginContainer/GridContainer/HBoxContainer3/SFXVolValue

# Level 1 Settings
@onready var pointsToWin = $MarginContainer/VBoxContainer/TabContainer/Level_1/MarginContainer/GridContainer/PointsSpawnCountValue
@onready var pointsSpawnCount = $MarginContainer/VBoxContainer/TabContainer/Level_1/MarginContainer/GridContainer/PointsSpawnCountValue
@onready var mobSpawnCount = $MarginContainer/VBoxContainer/TabContainer/Level_1/MarginContainer/GridContainer/MobSpawnCountValue
@onready var mobMinSpeed = $MarginContainer/VBoxContainer/TabContainer/Level_1/MarginContainer/GridContainer/MobMinSpeedValue
@onready var mobMaxSpeed = $MarginContainer/VBoxContainer/TabContainer/Level_1/MarginContainer/GridContainer/MobMaxSpeedValue

func _ready():
	# On Settings Menu ready, set up the settings from save data
	# Video Settings
	screen_mode.selected = 1 if Save.game_data.fullscreen_on else 0
	# doing screen_mode.selected doesn't trigger an event, so need this command incase if fullscreen was last set as true
	GlobalSettings.toggle_fullscreen(Save.game_data.fullscreen_on) 
	displayFPS.button_pressed = true if Save.game_data.showFPS else false
	
	# Audio Settings
	master_vol_slider.value = Save.game_data.master_vol
	master_vol_value.text = str(master_vol_slider.value)
	music_vol_slider.value = Save.game_data.music_vol
	music_vol_value.text = str(music_vol_slider.value)
	sfx_vol_slider.value = Save.game_data.sfx_vol
	sfx_vol_value.text = str(sfx_vol_slider.value)
	
	# Level 1 Settings
	pointsToWin.text = str(Save.game_data.level_1_point_goal)
	pointsSpawnCount.text = str(Save.game_data.level_1_point_spawn_max)
	mobSpawnCount.text = str(Save.game_data.level_1_mob_spawn_max)
	mobMinSpeed.text = str(Save.game_data.level_1_mob_min_speed)
	mobMaxSpeed.text = str(Save.game_data.level_1_mob_max_speed)
#	hide()
	pass


# Connections
# Video Connections
func _on_screen_mode_list_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)
	
func _on_display_fps_button_toggled(button_pressed):
	GlobalSettings.toggle_showFPS(button_pressed)

# Audio Connections
func _on_master_vol_slider_value_changed(value):
	master_vol_value.text = str(value)
	GlobalSettings.update_master_vol(value)
	
func _on_music_vol_slider_value_changed(value):
	music_vol_value.text = str(value)
	GlobalSettings.update_music_vol(value)
	
func _on_sfx_vol_slider_value_changed(value):
	sfx_vol_value.text = str(value)
	GlobalSettings.update_sfx_vol(value)

# Level 1 Connections
func _on_point_to_win_value_text_changed(value):
	print("Settings Menu | _on_point_to_win_value_text_changed: value = %s" % str(value))
	GlobalSettings.update_pointsToWin(value)
	
func _on_points_spawn_count_value_text_changed(value):
	print("Settings Menu | _on_points_spawn_count_value_text_changed: value = %s" % str(value))
	GlobalSettings.update_pointSpawnCount(value)
	
func _on_mob_spawn_count_value_text_changed(value):
	print("Settings Menu | _on_mob_spawn_count_value_text_changed: value = %s" % str(value))
	GlobalSettings.update_mobSpawnCount(value)
	
func _on_mob_min_speed_value_text_changed(value):
	print("Settings Menu | _on_mob_min_speed_value_text_changed: value = %s" % str(value))
	GlobalSettings.update_mobMinSpeed(value)
	
func _on_mob_max_speed_value_text_changed(value):
	print("Settings Menu | _on_mob_max_speed_value_text_changed: value = %s" % str(value))
	GlobalSettings.update_mobMaxSpeed(value)

# Exit Buttons
func _on_save_button_pressed():
	Save.save_data()
	saveButton_pressed.emit()

func _on_close_button_pressed():
	closeButton_pressed.emit()

# Function to show or hide the settings menu
func _on_game_manager_toggle_show_settings(show_settings):
	if (show_settings):
		show()
	else:
		hide()
