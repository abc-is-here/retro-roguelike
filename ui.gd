extends CanvasLayer

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var generate :Node = $"../generate"
@onready var grid: PackedScene = load("res://map_grid.tscn")

func _ready() -> void:
	gen_min_map()
	$pause_screen.visible = false

func _process(delta: float) -> void:
	$StatBar/coinLabel.text = str(Global.coins)
	
	if player.has_key:
		$StatBar/key.modulate = "ffffff"
	else:
		$StatBar/key.modulate = "45413b"
			
	match Global.health:
		8:
			$"healthbar/heart 1".frame = 2
			$"healthbar/heart 2".frame = 2
			$"healthbar/heart 3".frame = 2
			$"healthbar/heart 4".frame = 2
		7:
			$"healthbar/heart 1".frame = 2
			$"healthbar/heart 2".frame = 2
			$"healthbar/heart 3".frame = 2
			$"healthbar/heart 4".frame = 1
		6:
			$"healthbar/heart 1".frame = 2
			$"healthbar/heart 2".frame = 2
			$"healthbar/heart 3".frame = 2
			$"healthbar/heart 4".frame = 0
		5:
			$"healthbar/heart 1".frame = 2
			$"healthbar/heart 2".frame = 2
			$"healthbar/heart 3".frame = 1
			$"healthbar/heart 4".frame = 0
		4:
			$"healthbar/heart 1".frame = 2
			$"healthbar/heart 2".frame = 2
			$"healthbar/heart 3".frame = 0
			$"healthbar/heart 4".frame = 0
		3:
			$"healthbar/heart 1".frame = 2
			$"healthbar/heart 2".frame = 1
			$"healthbar/heart 3".frame = 0
			$"healthbar/heart 4".frame = 0
		2:
			$"healthbar/heart 1".frame = 2
			$"healthbar/heart 2".frame = 0
			$"healthbar/heart 3".frame = 0
			$"healthbar/heart 4".frame = 0
		1:
			$"healthbar/heart 1".frame = 1
			$"healthbar/heart 2".frame = 0
			$"healthbar/heart 3".frame = 0
			$"healthbar/heart 4".frame = 0
		0:
			$"healthbar/heart 1".frame = 0
			$"healthbar/heart 2".frame = 0
			$"healthbar/heart 3".frame = 0
			$"healthbar/heart 4".frame = 0
	
	$miniMap/Label.text = "Level " + str(Global.level)
	update_min_map()
	
	if Input.is_action_just_pressed("escape"):
		$pause_screen.visible = !$pause_screen.visible

func update_min_map() -> void:
	var pos : Vector2i = (player.global_position / 816)
	var panels = $miniMap/GridContainer.get_children()
	for panel in panels:
		if panel.is_room:
			panel.modulate = "ffffff"
		if panel.pos == pos:
			panel.modulate = "007a27"

func gen_min_map() -> void:
	$miniMap/GridContainer.columns = generate.width
	for i in range(generate.height):
		for j in range(generate.width):
			var panel = grid.instantiate()
			if generate.map[j][i] == false:
				panel.modulate = "ffffff00"
			else:
				panel.is_room = true
			panel.pos = Vector2i(j, i)
			$miniMap/GridContainer.add_child(panel)

func _on_resume_button_pressed() -> void:
	$pause_screen.visible = false

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
