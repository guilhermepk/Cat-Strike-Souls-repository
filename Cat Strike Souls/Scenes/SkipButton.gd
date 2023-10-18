extends Button

func _on_SkipButton_mouse_entered():
	modulate.a = 1


func _on_SkipButton_mouse_exited():
	modulate.a = 0.59


func _on_SkipButton_pressed():
	get_tree().change_scene("res://Scenes/StartHall.tscn")
