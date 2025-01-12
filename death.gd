extends Control

var str_arrays : Array = ["death by a pesky alien", 'Live again!', "You can't live forever", "Do you even have a life?", "Touch some grass"]

func _ready() -> void:
	$start/buttons/Label2.text = "Levels Reached:  " + str(Global.level) + "\n\nEnemies Defeated:  " + str(Global.enemies_def) + "\n\nCoins Collected:  " + str(Global.coins)
	$start/Label2.text = str_arrays[randi_range(0, len(str_arrays) - 1)]
	

func _on_mainmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
