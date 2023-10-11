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

func toggle_showFPS(value):
	displayFPS_changed.emit(value)

# Audio Settings
func update_master_vol(vol):
	var master_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_index, linear_to_db(vol/100))
	
func update_music_vol(vol):
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(vol/100))
	
func update_sfx_vol(vol):
	var sfx_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(vol/100))

# Level 1 Settings
func update_pointsToWin(value):
	pointsToWin_changed.emit(value)

func update_pointSpawnCount(value):
	pointSpawnCount_changed.emit(value)
	
func update_mobSpawnCount(value):
	mobSpawnCount_changed.emit(value)
	
func update_mobMinSpeed(value):
	mobMinSpeed_changed.emit(value)
	
func update_mobMaxSpeed(value):
	mobMaxSpeed_changed.emit(value)
