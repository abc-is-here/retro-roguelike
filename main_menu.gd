extends Control

func _ready() -> void:
	$start.visible = true
	$seed.visible = false

func _on_start_button_pressed() -> void:
	$start.visible = false
	$seed.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	if $seed/buttons/SpinBox.value == 0:
		Global.seed = randi_range(1, 100000)
	else:
		Global.seed = $seed/buttons/SpinBox.value
	
	Global.health = Global.max_health
	Global.level = 1
	Global.coins = 0
	Global.enemies_def = 0
	get_tree().change_scene_to_file("res://world.tscn")


func _on_back_pressed() -> void:
	$start.visible = true
	$seed.visible = false
