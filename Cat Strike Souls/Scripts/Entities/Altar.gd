extends StaticBody2D

onready var symbols = get_node("TileMap/LightEffects").get_children()

func _ready():
	for symbol in symbols:
		symbol.visible = false
		var light = symbol.get_node('Light2D')
		light.visible = true
		light.energy = 0.6

func _process(delta):
	if Global.victory:
		for symbol in symbols:
			symbol.visible = true
