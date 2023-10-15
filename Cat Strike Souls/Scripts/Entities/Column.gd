extends Node2D

var playerAround
var player
var XKey

var symbols
var reversedSymbols = []
var maxEnergy = 0.6
var currentSymbolIndex = 0
var fullyCharged = false

func charge():
	var currentSymbol = reversedSymbols[currentSymbolIndex]
	var currentLight = currentSymbol.get_node('Light2D')
	var currentEnergy = currentLight.energy
	if currentEnergy >= maxEnergy == false:
		currentLight.energy += 0.03
		var energyPercent = (currentEnergy * 100) / maxEnergy
		var currentAlpha = (1 * energyPercent) / 100
		currentSymbol.modulate.a = currentAlpha
		
	else:
		$Fx.pitch_scale = $Fx.pitch_scale + currentSymbolIndex/10
		$Fx.play()
		currentSymbolIndex += 1
		
func _ready():
	player = get_tree().current_scene.get_node('Elements/YSort/Player')
	XKey = player.get_node('HUD/XKey')
	
	symbols = $TileMap/LightEffects.get_children()
	for symbol in symbols:
		reversedSymbols.insert(0, symbol)
		symbol.visible = true
		symbol.modulate.a = 0
		symbol.get_node('Light2D').energy = 0
		symbol.scale.x = 1
		symbol.scale.y = 1
	
func _process(delta):
	if fullyCharged:
		$AnimationPlayer.play("charged")
	elif playerAround:
		if currentSymbolIndex < symbols.size():
			if Input.is_key_pressed(88): # 88 = x
				charge()
		else:
			XKey.visible = false
			fullyCharged = true
		
				
func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		playerAround = true
		if !fullyCharged:
			XKey.visible = true
		

func _on_Area2D_body_exited(body):
	if body.name == 'Player':
		playerAround = false
		XKey.visible = false
