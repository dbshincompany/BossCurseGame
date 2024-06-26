extends CharacterBody2D

const speed = 1500
var curse = 0

func _physics_process(delta):
	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
	position.x += directionX * delta * speed
	position.y += directionY * delta * speed
	
	get_node("CurseMeter").scale.x = curse
	
	if curse > 10:
		get_tree().change_scene_to_file("res://main.tscn")
