extends Control

func _ready():
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])

func on_button_pressed(button: Button):
	match button.name:
		"Play":
			var _game: bool = get_tree().change_scene("res://Scenes/Fase.tscn")
		"Controls":
			var _game: bool = get_tree().change_scene("res://Scenes/Menu/Controls.tscn")
		"Quit":
			get_tree().quit()
		
		"Developer":
			var _name_clicked: bool = OS.shell_open("https://github.com/guilhermepk")

func mouse_interaction(button: Button, state: String):
	match state:
		"exited":
			button.modulate.a = 1
		"entered":
			button.modulate.a = 0.5
