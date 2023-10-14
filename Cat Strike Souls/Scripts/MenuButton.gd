extends Button

func _on_MenuButton_pressed():
	get_tree().change_scene("res://Scenes/Menu/Menu.tscn")


func _on_MenuButton_mouse_entered():
	modulate.a = 0.5


func _on_MenuButton_mouse_exited():
	modulate.a = 1
