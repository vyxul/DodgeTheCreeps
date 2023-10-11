extends Node

const SAVEFILE = "user://SAVEFILE.save"

var game_data = {}

func _ready():
	load_data()
	
func load_data():
	if not FileAccess.file_exists(SAVEFILE):
		game_data = {
			"fullscreen_on": false,
			"showFPS": false,
			"master_vol": 100,
			"music_vol": 100,
			"sfx_vol": 100,
			"level_1_point_goal": 7,
			"level_1_point_spawn_max": 1,
			"level_1_mob_spawn_max": 5,
			"level_1_mob_min_speed": 150,
			"level_1_mob_max_speed": 250
		}
		save_data()
		
	else:
		var file = FileAccess.open(SAVEFILE, FileAccess.READ)
		game_data = file.get_var()
		file.close()
	
func save_data():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	file.store_var(game_data)
	file.close()
