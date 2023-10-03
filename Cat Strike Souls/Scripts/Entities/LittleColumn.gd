extends Node2D

var playerAround
var player
var XKey

var symbols
var reversedSymbols = []
var currentEnergy = 0

#yield(get_tree().create_timer(attackTime), "timeout")

func charge():
	if currentEnergy < symbols.size():
		symbols[currentEnergy].visible = true
		currentEnergy += 1
	yield(get_tree().create_timer(5), 'timeout')
		
func _ready():
	player = get_tree().current_scene.get_node('Elements/YSort/Player')
	XKey = player.get_node('XKey')
	
	symbols = $TileMap/LightEffects.get_children()
	for symbol in symbols:
		reversedSymbols.insert(0, symbol)
	
func _process(delta):
	if playerAround:
		if Input.is_key_pressed(88): # 88 = x
			charge()
				
func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		XKey.visible = true
		playerAround = true

func _on_Area2D_body_exited(body):
	if body.name == 'Player':
		XKey.visible = false
		playerAround = false
