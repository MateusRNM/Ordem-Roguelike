extends Node

@export var playerInstance : CharacterBody2D


@export var enemyQtd : int = 0
@export var enemiesOnScreen : Array
@export var enemies : Array
@export var XPInstances : Array


@export var isGamePaused : bool = false
@export var gameConfigs : Dictionary

func resetGameVars():
	playerInstance = null
	isGamePaused = false
	enemyQtd = 0
	enemies.clear()
	enemiesOnScreen.clear()
	XPInstances.clear()

func settingUp():
	InputMap.erase_action("up")
	InputMap.add_action("up")
	InputMap.action_add_event("up", gameConfigs.controls.up)
	InputMap.erase_action("down")
	InputMap.add_action("down")
	InputMap.action_add_event("down", gameConfigs.controls.down)
	InputMap.erase_action("left")
	InputMap.add_action("left")
	InputMap.action_add_event("left", gameConfigs.controls.left)
	InputMap.erase_action("right")
	InputMap.add_action("right")
	InputMap.action_add_event("right", gameConfigs.controls.right)
	InputMap.erase_action("changeAimType")
	InputMap.add_action("changeAimType")
	InputMap.action_add_event("changeAimType", gameConfigs.controls.changeAimType)
	DisplayServer.window_set_size(gameConfigs.video.resolution)
	DisplayServer.window_set_mode(gameConfigs.video.windowType)
	
func saveData():
	var save = FileAccess.open("user://save.data", FileAccess.WRITE)
	if save:
		save.store_var(gameConfigs, true)
	save.close()

func loadData():
	var save = FileAccess.open("user://save.data", FileAccess.READ)
	if save:
		gameConfigs = save.get_var(true)
		save.close()
	else:
		createData()
	
func createData():
	var save = FileAccess.open("user://save.data", FileAccess.WRITE)
	gameConfigs = {
		"controls": {
			"up": InputMap.action_get_events("up")[0],
			"down": InputMap.action_get_events("down")[0],
			"left": InputMap.action_get_events("left")[0],
			"right": InputMap.action_get_events("right")[0],
			"changeAimType": InputMap.action_get_events("changeAimType")[0]
		},
		"video": {
			"resolution": Vector2(1920, 1080),
			"windowType": DisplayServer.WINDOW_MODE_MAXIMIZED
		}
	}
	if save:
		save.store_var(gameConfigs, true)
	save.close()
