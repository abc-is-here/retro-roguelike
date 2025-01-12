extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("player")[0]

var health : int = 3
var damage : int = 1

var attack_chance : float = 0.5

func move() -> void:
	if randf() < 0.5:
		return
	
	var direction : Vector2 = Vector2.ZERO
	var can_move : bool = false
	
	while(can_move == false):
		direction = get_random_dir()
		
		var rid_space = get_world_2d().space
		var state_space = PhysicsServer2D.space_get_direct_state(rid_space)
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position+Vector2(48,48)*direction)
		var res = state_space.intersect_ray(query)
		
		if not res and position+48*direction != player.position:
			can_move = true
	
	position+=48*direction
	
func get_random_dir() -> Vector2:
	var ran : int = randi_range(0,3)
	
	match ran:
		0:
			return Vector2.UP
		1:
			return Vector2.DOWN
		2:
			return Vector2.RIGHT
		3:
			return Vector2.LEFT
		
	return Vector2.ZERO
	
func take_damage(damage : int) -> void:
	health -= damage
	$sound.stream = load("res://SFX/Hit.wav")
	$sound.play()
	
	if health <= 0:
		Global.enemies_def += 1
		queue_free()
	
	$AnimationPlayer.play("flash")
	
	if randf() > attack_chance:
		player.take_damage(1)
