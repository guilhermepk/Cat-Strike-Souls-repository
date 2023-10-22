extends Button

func _ready():
	changeText()

func changeText():
	if OS.window_fullscreen:
		text = 'Colocar em modo janela'
	else:
		text = 'Colocar em modo tela cheia'

func _on_FullScreen_pressed():
	OS.window_fullscreen = not OS.window_fullscreen
	changeText()

func _on_FullScreen_mouse_entered():
	modulate.a = 0.5

func _on_FullScreen_mouse_exited():
	modulate.a = 1
