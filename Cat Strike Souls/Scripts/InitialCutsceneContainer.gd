extends NinePatchRect

onready var text = get_node("Text")
onready var timer = get_node("Timer")
onready var bgDialog = get_node("DialogBoxBG")

var spaceAlreadyPressed = false

var msg_queue = [
	'é o fodase-man?'
]

func _ready():
	bgDialog.hide()
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE:
			if event.is_pressed():
				if !spaceAlreadyPressed:
					spaceAlreadyPressed = true
					bgDialog.show()
					showMessage()
			else:
				spaceAlreadyPressed = false

func showMessage():
	if not timer.is_stopped():
		text.visible_characters = text.bbcode_text.length()
		return
	
	if msg_queue.size() == 0:
		hide()
		return
	
	var msg = msg_queue.pop_front()
	text.visible_characters = 0
	text.bbcode_text = msg
	timer.start()


func _on_Timer_timeout():
	if text.visible_characters == text.bbcode_text.length():
		timer.stop()
	text.visible_characters += 1
