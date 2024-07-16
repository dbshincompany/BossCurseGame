extends CharacterBody2D


@export var speed = 1000
var ogSpeed = speed
var sprintSpeed = speed*2
const DISTANCE = 500

var playerPositionX = 0
var playerPositionY = 0

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		$Camera2D.enabled = true

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
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
		
	move_and_slide()
func getPlayerPosition(posX, posY):
	playerPositionX = posX
	playerPositionY = posY
func inDistance():
	return abs(playerPositionX - position.x) < DISTANCE and abs(playerPositionY - position.y) < DISTANCE
