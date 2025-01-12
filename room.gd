extends Node2D

var in_width: int = 9
var in_height : int = 9

@onready var generate : Node

@export var enemy_node : PackedScene
@export var coin_node : PackedScene
@export var heart_node : PackedScene
@export var key_node : PackedScene
@export var exit_node_door : PackedScene

var used_pos : Array

func _ready() -> void:
	if generate:
		gen_interior()

func north():
	$NorthDoor.visible = true
	$NorthWall.queue_free()

func east():
	$EastDoor.visible = true
	$EastWall.queue_free()

func west():
	$WestDoor.visible = true
	$WestWall.queue_free()

func south():
	$SouthDoor.visible = true
	$SouthWall.queue_free()

func gen_interior() -> void:
	if randf_range(0, 1) < generate.enemy_spawn_chance:
		spawn_node(enemy_node, 1, generate.max_enemies_in_room)
	if randf_range(0, 1) < generate.coin_spawn_chance:
		spawn_node(coin_node, 1, generate.max_coins_in_room)
	if randf_range(0, 1) < generate.heart_spawn_chance:
		spawn_node(heart_node, 1, generate.max_hearts_in_room)

func spawn_node(nodeScene : PackedScene, min_ins : int = 0, max_ins : int = 0) -> void:
	var num : int = 1
	if min_ins != 0 or max_ins != 0:
		num = randi_range(min_ins, max_ins)
	
	for i in range(num):
		var node_obj = nodeScene.instantiate()
		var pos : Vector2 = Vector2(48*randi_range(2, in_width-1) -24, 48*randi_range(2, in_height-1) - 24)
		while pos in used_pos:
			pos = Vector2(48*randi_range(2, in_width-1) -24, 48*randi_range(2, in_height-1) - 24)
		
		node_obj.position = pos
		used_pos.append(pos)
		add_child(node_obj)
	
	if nodeScene == enemy_node:
		get_tree().get_first_node_in_group("Enemy_Manager").enemies_check()
