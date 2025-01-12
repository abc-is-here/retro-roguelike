extends CharacterBody2D

var has_key : bool = false

signal  player_move

func  _physics_process(delta: float) -> void:
	user_input()

func user_input() -> void:
	if Input.is_action_just_pressed("right"):
		velocity = Vector2.RIGHT
		move(velocity)
	elif  Input.is_action_just_pressed("up"):
		velocity = Vector2.UP
		move(velocity)
	elif  Input.is_action_just_pressed("left"):
		velocity = Vector2.LEFT
		move(velocity)
	elif  Input.is_action_just_pressed("down"):
		velocity = Vector2.DOWN
		move(velocity)
	
	if Input.is_action_just_pressed("att_right"):
		try_attack(Vector2.RIGHT)
	if Input.is_action_just_pressed("att_left"):
		try_attack(Vector2.LEFT)
	if Input.is_action_just_pressed("att_up"):
		try_attack(Vector2.UP)
	if Input.is_action_just_pressed("att_down"):
		try_attack(Vector2.DOWN)

func move(direction:Vector2) -> void:
	var rid_space = get_world_2d().space
	var state_space = PhysicsServer2D.space_get_direct_state(rid_space)
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position+Vector2(48,48)*direction)
	var res = state_space.intersect_ray(query)
	
	if res:
		if res.collider.is_in_group("wall"):
			return
	
	$sound.stream = load("res://SFX/walk.wav")
	$sound.play()
	position+=48*direction
	player_move.emit()
	
func try_attack(direction : Vector2) -> void:
	var rid_space = get_world_2d().space
	var state_space = PhysicsServer2D.space_get_direct_state(rid_space)
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position+Vector2(48,48)*direction)
	var res = state_space.intersect_ray(query)
	
	print(Global.health)
	
	if res:
		if res.collider.is_in_group("enemy"):
			res.collider.take_damage(1)

func take_damage(damage : int) -> void:
	Global.health -= damage
	
	$AnimationPlayer.play("player_flash")
	
	$sound.stream = load("res://SFX/Hit.wav")
	$sound.play()
	
	if Global.health <= 0:
		Sounds.get_child(4).play()
		get_tree().change_scene_to_file("res://death.tscn")
