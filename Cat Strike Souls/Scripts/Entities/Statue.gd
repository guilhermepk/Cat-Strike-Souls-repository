extends KinematicBody2D

var columns = []
var columnsScenes = [
	'res://Scenes/Entities/Objetcs/Columns/BrokenColumn.tscn',
	'res://Scenes/Entities/Objetcs/Columns/Column.tscn',
	'res://Scenes/Entities/Objetcs/Columns/LittleColumn.tscn'
]
var activated = false
var broken = false
var breaking = false

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
	
	if broken:
		$AnimatedSprite.play("breaking")
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = $AnimatedSprite.frames.get_frame_count('breaking')-1
	elif breaking:
		breakStatue()
	elif activated:
		$AnimatedSprite.play("activated")
		$Light2D.visible = true

func breakStatue():
	$AnimatedSprite.play("breaking")
	var cur_anim = $AnimatedSprite.animation
	var anim_spd = $AnimatedSprite.frames.get_animation_speed(cur_anim)
	var anim_frames = $AnimatedSprite.frames.get_frame_count(cur_anim)
	var animTime = anim_frames / anim_spd
	
	yield(get_tree().create_timer(animTime), "timeout")
	breaking = false
	broken = true
	activated = false
	print('player venceu')
