extends Button

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_QuitButton_mouse_entered():
	modulate.a = 0.5


func _on_QuitButton_mouse_exited():
	modulate.a = 1
