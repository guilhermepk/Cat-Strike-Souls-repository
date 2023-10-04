extends KinematicBody2D

var columns = []
var columnsScenes = [
	'res://Scenes/Entities/Objetcs/Columns/BrokenColumn.tscn',
	'res://Scenes/Entities/Objetcs/Columns/Column.tscn',
	'res://Scenes/Entities/Objetcs/Columns/LittleColumn.tscn'
]
var activated = false

func _ready():
	$AnimatedSprite.play("default")
	$Light2D.visible = false
	
	var sceneChildren = get_tree().current_scene.get_node('Elements/YSort').get_children()
	for child in sceneChildren:
		var fileName = child.get_filename()
		if fileName in columnsScenes:
			columns.append(child)
		
func _process(delta):
	var all_columns_on = true
	for column in columns:
		if column.fullyCharged == false:
			all_columns_on = false
			
	if all_columns_on:
		activated = true
		
	if activated:
		$AnimatedSprite.play("activated")
		$Light2D.visible = true
