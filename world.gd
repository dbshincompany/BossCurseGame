extends Node2D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var pX = get_node("Player").position.x
	#var pY = get_node("Player").position.y
	#get_node("Boss").getPlayerPosition(pX, pY)
	#if get_node("Boss").inDistance():
	#	get_node("Player").curse += delta * 2
	pass
