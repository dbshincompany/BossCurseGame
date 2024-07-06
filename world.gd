extends Node2D

var Room = preload("res://room.tscn")

var tilesize = 32
var num_rooms = 50
var min_size = 6
var max_size = 20

var hSpread = 10

var cull = 0
var path

var external_path = 0.04
var Map

var mapScale = 3
var show = true

var tileLayer = 1
var openTile = Vector2i(0,7)
var closeTile = Vector2i(1,1)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	make_rooms()
	Map = $TileMap
	pass # Replace with function body.


func _draw():
	if show == true:
		for roomP in $Rooms.get_children():
			var room = roomP.get_children()[0]
			draw_rect(Rect2(roomP.position*3- room.get_shape().size*3/2, room.get_shape().size*3),
		Color(50,0,0),false)
			if path:
				for p in path.get_point_ids():
					for c in path.get_point_connections(p):
						var pp = path.get_point_position(p)*mapScale
						var cp = path.get_point_position(c)*mapScale
						draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 1, 0), 15, true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pX = get_node("Player").position.x
	var pY = get_node("Player").position.y
	get_node("Boss").getPlayerPosition(pX, pY)
	if get_node("Boss").inDistance():
		get_node("Player").curse += delta * 2
	queue_redraw()
		
		
		
func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(0,0)
		var r = Room.instantiate()
		var w = min_size + randi() % (max_size-min_size)
		var h = min_size + randi() % (max_size-min_size)
		r.make_room(pos,Vector2(w,h)*tilesize)
		$Rooms.add_child(r)
		
	await get_tree().create_timer(2).timeout
	
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
			
			room_positions.append(Vector2(room.position.x, room.position.y))
	await get_tree().process_frame
	#generate a MST
	path = await find_mst(room_positions)
		
func _input(event):
	if event.is_action_pressed('ui_select')	:
		for n in $Rooms.get_children():
			n.queue_free()
		path = null
		make_rooms()
	if event.is_action_pressed("ui_focus_next"):
		make_map()
		show = false

func find_mst(nodes):
	#Prim's algorithm
	path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	#repeat until no more node remains
	var tmp = 0
	while nodes:
		var minD = INF #minimum distance so far
		var minP = null #position of that node
		var p = null #current position
		
		
		#loop through all points in the path
		for p1 in path.get_point_ids():
			var p3
			p3 = path.get_point_position(p1)
			#loop though the remaining nodes
			var n = path.get_available_point_id()
			for p2 in nodes:
				tmp = tmp + 1
				if randf() < external_path and p3.distance_to(p2) < 1300:
					path.add_point(n, p2)
					path.connect_points(path.get_closest_point(p3), n)
				
				if p3.distance_to(p2) < minD:
					minD = p3.distance_to(p2)
					minP = p2
					p = p3
				
		var n = path.get_available_point_id()
		path.add_point(n, minP)
		path.connect_points(path.get_closest_point(p), n)
		print(tmp)
		
			
		nodes.erase(minP)
	print(path.get_property_list())
	return path





func make_map():
	Map.clear()
	
	var full_rect = Rect2()
	for roomP in $Rooms.get_children():
		var room = roomP.get_children()[0]
		var r = Rect2(roomP.position - room.get_shape().size, room.get_shape().size)
		full_rect = full_rect.merge(r)
		
	full_rect.size = full_rect.size 
	full_rect.position = full_rect.position - full_rect.size*0.055
	var top_left = Map.local_to_map(full_rect.position)
	var bottom_right = Map.local_to_map(full_rect.end)
	
	for x in range(top_left.x,bottom_right.x):
		for y in range(top_left.y,bottom_right.y):
			Map.set_cell(0,Vector2i(x,y),tileLayer,closeTile)
			
			
	var corridors = []  # One corridor per connection
		
	for roomP in $Rooms.get_children():
		var room = roomP.get_children()[0]
		var s = (roomP.size / 32).round()
		var pos = Map.local_to_map(roomP.position)
		
		var ul = (roomP.position / 32).round() - s
		for x in range(1, s.x*2 -1):
			for y in range(1, s.y*2 -1):
				Map.set_cell(0,Vector2i(ul.x+x-12/mapScale,ul.y+y-15/mapScale),tileLayer,openTile)
		
		var p = path.get_closest_point(Vector2(roomP.position.x  , 
											roomP.position.y ))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.local_to_map(Vector2(path.get_point_position(p).x ,
													path.get_point_position(p).y))
				var end = Map.local_to_map(Vector2(path.get_point_position(conn).x,
													path.get_point_position(conn).y))									
				carve_path(start, end)
		corridors.append(p)

func carve_path(pos1, pos2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	# choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(0,Vector2i(x,x_y.y+1),tileLayer,openTile)
		Map.set_cell(0,Vector2i(x,x_y.y),tileLayer,openTile)
		Map.set_cell(0,Vector2i(x,x_y.y + y_diff),tileLayer,openTile)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(0,Vector2i(y_x.x, y),tileLayer,openTile)
		Map.set_cell(0,Vector2i(y_x.x+1, y),tileLayer,openTile)
		Map.set_cell(0,Vector2i(y_x.x, y + x_diff),tileLayer,openTile)
			#draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 1, 0), 15, true)

				
	
