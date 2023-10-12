extends Node

# Signals for Video Settings
signal displayFPS_changed(value)

# Signals for Level 1 Settings
signal pointsToWin_changed(value)
signal pointSpawnCount_changed(value)
signal mobSpawnCount_changed(value)
signal mobMinSpeed_changed(value)
signal mobMaxSpeed_changed(value)

# Video Settings
func toggle_fullscreen(value):
	if (value):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Save.game_data.fullscreen_on = value

func toggle_showFPS(value):
	displayFPS_changed.emit(value)
	Save.game_data.showFPS = value

# Audio Settings
func update_master_vol(vol):
	var master_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_index, linear_to_db(vol/100))
	Save.game_data.master_vol = int(vol)
	
func update_music_vol(vol):
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(vol/100))
	Save.game_data.music_vol = vol
	
func update_sfx_vol(vol):
	var sfx_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(vol/100))
	Save.game_data.sfx_vol = vol

# Level 1 Settings
func update_pointsToWin(value):
	print("GlobalSettings | update_pointsToWin: value = %s" % str(value))
	pointsToWin_changed.emit(value)
	Save.game_data.level_1_point_goal = value

func update_pointSpawnCount(value):
	print("GlobalSettings | update_pointSpawnCount: value = %s" % str(value))
	pointSpawnCount_changed.emit(value)
	Save.game_data.level_1_point_spawn_max = value
	
func update_mobSpawnCount(value):
	print("GlobalSettings | update_mobSpawnCount: value = %s" % str(value))
	mobSpawnCount_changed.emit(value)
	Save.game_data.level_1_mob_spawn_max = value
	
func update_mobMinSpeed(value):
	print("GlobalSettings | update_mobMinSpeed: value = %s" % str(value))
	mobMinSpeed_changed.emit(value)
	Save.game_data.level_1_mob_min_speed = value
	
func update_mobMaxSpeed(value):
	print("GlobalSettings | update_mobMaxSpeed: value = %s" % str(value))
	mobMaxSpeed_changed.emit(value)
	Save.game_data.level_1_mob_max_speed = value
