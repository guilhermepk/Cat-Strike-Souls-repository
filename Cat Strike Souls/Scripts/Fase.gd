extends Node2D

onready var fxWind = get_node("FxWind")

func _ready():
	fxWind.play()
