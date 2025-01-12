extends Area2D


func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		if body.has_key:
			Sounds.get_child(3).play()
			Global.level += 1
			Global.seed+=randi_range(1, 40000)
			
			get_tree().reload_current_scene()
