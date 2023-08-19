extends Area2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.position.x = position.x
		body.position.y = position.y
		$AnimatedSprite.play("fulled")
		body.visible = false
		body.inBox = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		$AnimatedSprite.play("empty")
		body.visible = true
		body.inBox = false
