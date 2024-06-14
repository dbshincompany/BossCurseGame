extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pX = get_node("Player").position.x
	var pY = get_node("Player").position.y
	get_node("Boss").getPlayerPosition(pX, pY)
	if get_node("Boss").inDistance():
		get_node("Player").curse += delta * 2
