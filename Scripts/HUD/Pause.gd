extends CanvasLayer

var configMenu : PackedScene = load("res://Objects/HUD/ConfigMenu.tscn")

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ESC")):
		GameVars.isGamePaused = false
		self.queue_free()


func _on_continue_btn_pressed() -> void:
	GameVars.isGamePaused = false
	self.queue_free()


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_configs_btn_pressed() -> void:
	get_parent().add_child(configMenu.instantiate())
	self.queue_free()
