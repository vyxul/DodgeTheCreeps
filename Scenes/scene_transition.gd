extends CanvasLayer

func change_scene(newScene: Node, parent: Node) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	parent.add_child(newScene)
	$AnimationPlayer.play_backwards("dissolve")

func scene_transition_start():
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	
func scene_transition_end():
	$AnimationPlayer.play_backwards("dissolve")
