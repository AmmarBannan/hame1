extends Node

var scene_changed

func change_scene_with_data(path, data):
	scene_changed=data
	get_tree().change_scene_to_file(path)
