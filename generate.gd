extends Node

@onready var room_scene : PackedScene = load("res://room.tscn")

var width : int = 7
var height : int = 7
var generate_room = 12
var count_room = 0
var room_inst: bool = false
var first_room_pos : Vector2

var map : Array
var room_nodes : Array

@export var enemy_spawn_chance : float
@export var coin_spawn_chance : float
@export var heart_spawn_chance : float

@export var max_enemies_in_room : int
@export var max_coins_in_room : int
@export var max_hearts_in_room : int

func _ready() -> void:
	for i in range(width):
		map.append([])
		for j in range(height):
			map[i].append(false)
	#seed(Global.seed)
	generate()

func generate() -> void:
	room_check(3, 3, 0, Vector2.ZERO, true)
	inst_rooms()
	$"../player".global_position = (first_room_pos*816) + Vector2(262, 262)

func room_check(x: int, y: int,remain: int, generalDir: Vector2, first_room: bool = false) -> void:
	if count_room>=generate_room:
		return
	
	if x<0 or x>width-1 or y<0 or y>height-1:
		return
	
	if first_room == false and remain<=0:
		return
		
	if map[x][y] == true:
		return
	
	if first_room:
		first_room_pos = Vector2(x,y)
	count_room+=1
	map[x][y] = true
	
	var north:bool = randf() > (0.2 if generalDir == Vector2.UP else 0.8)
	var south : bool = randf() > (0.2 if generalDir == Vector2.DOWN else 0.8)
	var east : bool = randf() > (0.2 if generalDir == Vector2.RIGHT else 0.8)
	var west : bool = randf() > (0.2 if generalDir == Vector2.LEFT else 0.8)
	
	var max_remain : int = generate_room
	
	if north or first_room:
		room_check(x, y+ 1, max_remain if first_room else remain - 1, Vector2.UP if first_room else generalDir)

	if south or first_room:
		room_check(x, y - 1, max_remain if first_room else remain - 1, Vector2.DOWN if first_room else generalDir)

	if east or first_room:
		room_check(x+1, y, max_remain if first_room else remain - 1, Vector2.RIGHT if first_room else generalDir)

	if west or first_room:
		room_check(x-1, y, max_remain if first_room else remain - 1, Vector2.LEFT if first_room else generalDir)

func inst_rooms() -> void:
	if room_inst:
		return
	room_inst = true
	
	for x in range(width):
		for y in range(height):
			if map[x][y] == false:
				continue
				
			var room = room_scene.instantiate()
			room.position = Vector2(x, y) * 816
			
			if y > 0 and map[x][y-1] == true:
				room.north()
				
			if y < height - 1 and map[x][y+1] == true:
				room.south()
			
			if x < width - 1 and map[x+1][y] == true:
				room.east()
			
			if x > 0 and map[x-1][y] == true:
				room.west()
				
			if first_room_pos != Vector2(x, y):
				room.generate = self
			
			$"..".call_deferred("add_child", room)
			room_nodes.append(room)
	
	get_tree().create_timer(1)
	calc_key_exit()

func calc_key_exit() -> void:
	var max_dist : float = 0
	var room_a : Node2D = null
	var room_b : Node2D = null
	
	for a : Node2D in room_nodes:
		for b : Node2D in room_nodes:
			var dis : float = a.position.distance_to(b.position)
			if dis > max_dist:
				room_a = a
				room_b = b
				max_dist = dis
	room_a.spawn_node(room_a.key_node)
	room_b.spawn_node(room_b.exit_node_door)
	
