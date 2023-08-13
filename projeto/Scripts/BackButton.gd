extends Button

export(String) var scene_path

func _on_back_button_pressed():
	var _change_scene: bool = get_tree().change_scene(scene_path)	

func _on_mouse_exited():
	modulate.a = 1

func _on_mouse_entered():
	modulate.a = 0.5
