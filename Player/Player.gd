extends CharacterBody2D

@export var speed = 1000
var ogSpeed = speed
var sprintSpeed = speed*2
var curse = 0

func _physics_process(delta):
	
	if(Input.is_action_pressed("sprint")):
		speed=sprintSpeed
	else:
		speed=ogSpeed
	
	if(Input.is_action_pressed("up")):
		velocity.y = Vector2.UP.y * speed
	if(Input.is_action_pressed("down")):
		velocity.y = Vector2.DOWN.y * speed
	if(Input.is_action_pressed("left")):
		velocity.x = Vector2.LEFT.x * speed
	if(Input.is_action_pressed("right")):
		velocity.x = Vector2.RIGHT.x * speed
	
	if(Input.is_action_just_released("up") || Input.is_action_just_released("down")):
		velocity.y=0 
	if(Input.is_action_just_released("left") || Input.is_action_just_released("right")):
		velocity.x=0 

	move_and_slide()
	
	get_node("CurseMeter").scale.x = curse
	
	if curse > 10:
		get_tree().change_scene_to_file("res://main.tscn")
