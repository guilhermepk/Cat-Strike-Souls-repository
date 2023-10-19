extends NinePatchRect

onready var currentScene = get_tree().current_scene

onready var player = currentScene.get_node("Characters/Player")
onready var witch = currentScene.get_node("Characters/Witch")
onready var golem = currentScene.get_node("Characters/Golem")
onready var golem2 = currentScene.get_node("Characters/Golem2")
onready var golem3 = currentScene.get_node("Characters/Golem3")

onready var characters = [ player, witch, golem, golem2, golem3 ]
onready var golens = [ golem, golem2, golem3 ]

onready var statue = currentScene.get_node("StatueAndColumns/Statue")
onready var columns = [
	currentScene.get_node("StatueAndColumns/Column"),
	currentScene.get_node("StatueAndColumns/LittleColumn"),
	currentScene.get_node("StatueAndColumns/LittleColumn5"),
	currentScene.get_node("StatueAndColumns/LittleColumn8"),
	currentScene.get_node("StatueAndColumns/BrokenColumn"),
	currentScene.get_node("StatueAndColumns/BrokenColumn2")
]

onready var text = get_node("Text")
onready var timer = get_node("Timer")
onready var bgDialog = get_node("DialogBoxBG")

var spaceAlreadyPressed = false

onready var msg_queue = [
	' Havia uma bruxa, com seu belo gato branco. Ela era uma ótima dona para o gato e vivia o mimando.',
	' A bruxa tinha repúdio dos golens, que sempre a importunavam. Por conta disso, a bruxa e o gato estavam sempre em guerra contra eles.',
	' Um certo dia, o gato acordou e percebeu que a bruxa tinha simplesmente sumido. Com certeza isso era coisa dos golens.',
	' O gato jurou vingança.',
	' Ele sabia o ponto fraco deles: cada golem protegia uma estátua, que os mantinha vivo.',
	' O gato queria mais do que nunca destruir a estátua, mas ela era indestrutível por conta de um feitiço.',
	' Para quebrar o feitiço, cada um dos oito pilares ao redor dela deveria ser ativado.',
	' Porém, o gato era muito frágil e pequeno, jamais conseguiria destruir a estátua.',
	' Teria então que achar uma forma de enganar o golem para que ele mesmo a destruísse…'
]

onready var currentMsgIndex = 0

func _ready():
	for character in characters:
		character.modulate.a = 0
	statue.modulate.a = 0
	for column in columns:
		column.modulate.a = 0
	
	bgDialog.show()
	timer.stop()
	currentScene.play('WitchAndCat')
	showMessage()
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE:
			if event.is_pressed():
				if !spaceAlreadyPressed:
					spaceAlreadyPressed = true
					showMessage()
			else:
				spaceAlreadyPressed = false

func showMessage():
	if not timer.is_stopped():
		text.visible_characters = text.bbcode_text.length()
		return
	
	if msg_queue.size() == 0:
		get_tree().change_scene("res://Scenes/StartHall.tscn")
		return

	match currentMsgIndex:
		1:
			currentScene.play('Golens')
		2:
			currentScene.play('WitchDisappear')
		3:
			currentScene.play('CatRevenge')
		4:
			currentScene.play('StatueAppear')
		5:
			pass
		6:
			currentScene.play('ColumnsAppear')
		7:
			pass
		8:
			currentScene.play('GolemAppear')
	currentMsgIndex += 1
	var msg = msg_queue.pop_front()
	text.visible_characters = 0
	text.bbcode_text = '\n'
	text.bbcode_text += msg
	timer.start()

func _on_Timer_timeout():
	if text.visible_characters == text.bbcode_text.length():
		timer.stop()
	text.visible_characters += 1


func _on_InitialCutscene_animation_finished(anim_name):
	currentScene.stop()
