extends CharacterBody2D


@export var SPEED = 600.0
const DISTANCE = 500

var playerPositionX = 0
var playerPositionY = 0

func _physics_process(delta):
	if(position.x > playerPositionX):
		velocity.x = Vector2.LEFT.x * SPEED
	else:
		velocity.x = Vector2.RIGHT.x * SPEED
	if(position.y > playerPositionY):
		velocity.y = Vector2.UP.y * SPEED
	else:
		velocity.y = Vector2.DOWN.y * SPEED
		
	move_and_slide()
func getPlayerPosition(posX, posY):
	playerPositionX = posX
	playerPositionY = posY
func inDistance():
	return abs(playerPositionX - position.x) < DISTANCE and abs(playerPositionY - position.y) < DISTANCE
