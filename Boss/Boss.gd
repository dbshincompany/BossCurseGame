extends CharacterBody2D


const SPEED = 600.0
const DISTANCE = 500

var playerPositionX = 0
var playerPositionY = 0

func _physics_process(delta):
	if(position.x > playerPositionX):
		position.x -= SPEED * delta
	else:
		position.x += SPEED * delta
	if(position.y > playerPositionY):
		position.y -= SPEED * delta
	else:
		position.y += SPEED * delta
func getPlayerPosition(posX, posY):
	playerPositionX = posX
	playerPositionY = posY
func inDistance():
	return abs(playerPositionX - position.x) < DISTANCE and abs(playerPositionY - position.y) < DISTANCE
