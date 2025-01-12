extends Node
var enemies : Array
var player : CharacterBody2D
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	player.connect("player_move", Callable(self, "on_player_move"))
	enemies_check()
func enemies_check() -> void:
	enemies = get_tree().get_nodes_in_group("enemy")
func on_player_move() -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.move()
