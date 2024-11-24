extends CanvasLayer

var panelIndex : int = 0
var pauseInstance : PackedScene = load("res://Objects/HUD/Pause.tscn")
@onready var controlsContainer : VBoxContainer = $Panel/ControlsContainer
@onready var videoContainer : VBoxContainer = $Panel/VideoContainer
@onready var upBtn : Button = $Panel/ControlsContainer/HBoxContainer/upBtn
@onready var downBtn : Button = $Panel/ControlsContainer/HBoxContainer2/downBtn
@onready var leftBtn : Button = $Panel/ControlsContainer/HBoxContainer3/leftBtn
@onready var rightBtn : Button = $Panel/ControlsContainer/HBoxContainer4/rightBtn
@onready var aimBtn : Button = $Panel/ControlsContainer/HBoxContainer5/aimBtn
@onready var resolutionBtn : Button = $Panel/VideoContainer/HBoxContainer/resolutionBtn
@onready var windowBtn : Button = $Panel/VideoContainer/HBoxContainer2/windowBtn
var controlSettingUp : String  = ""
var isWaitingForInput : bool = false

func _ready() -> void:
	if(GameVars.gameConfigs.video.resolution == Vector2(1920, 1080)):
		resolutionBtn.selected = 0
	elif(GameVars.gameConfigs.video.resolution == Vector2(1600, 900)):
		resolutionBtn.selected = 1
	elif(GameVars.gameConfigs.video.resolution == Vector2(1280, 720)):
		resolutionBtn.selected = 2
	elif(GameVars.gameConfigs.video.resolution == Vector2(640, 480)):
		resolutionBtn.selected = 3
	
	if(GameVars.gameConfigs.video.windowType == DisplayServer.WINDOW_MODE_FULLSCREEN):
		windowBtn.selected = 0
	elif(GameVars.gameConfigs.video.windowType == DisplayServer.WINDOW_MODE_MAXIMIZED):
		windowBtn.selected = 1
	elif(GameVars.gameConfigs.video.windowType == DisplayServer.WINDOW_MODE_WINDOWED):
		windowBtn.selected = 2

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ESC")):
		get_parent().add_child(pauseInstance.instantiate())
		self.queue_free()
		
	if(panelIndex == 0):
		videoContainer.visible = false
		controlsContainer.visible = false
	elif(panelIndex == 1):
		videoContainer.visible = false
		controlsContainer.visible = true
		rightBtn.text = GameVars.gameConfigs.controls.right.as_text().replace("(Physical)", "")
		leftBtn.text = GameVars.gameConfigs.controls.left.as_text().replace("(Physical)", "")
		upBtn.text = GameVars.gameConfigs.controls.up.as_text().replace("(Physical)", "")
		downBtn.text = GameVars.gameConfigs.controls.down.as_text().replace("(Physical)", "")
		aimBtn.text = GameVars.gameConfigs.controls.changeAimType.as_text().replace("(Physical)", "")
	elif(panelIndex == 2):
		videoContainer.visible = true
		controlsContainer.visible = false

func _on_back_btn_pressed() -> void:
	get_parent().add_child(pauseInstance.instantiate())
	self.queue_free()


func _on_control_btn_pressed() -> void:
	panelIndex = 1

func _on_video_btn_pressed() -> void:
	panelIndex = 2


func _input(event: InputEvent) -> void:
	if(!event.is_pressed()):
		return
	if(isWaitingForInput):
		InputMap.erase_action(controlSettingUp)
		InputMap.add_action(controlSettingUp)
		InputMap.action_add_event(controlSettingUp, event)
		GameVars.gameConfigs.controls[controlSettingUp] = event
		GameVars.saveData()
		isWaitingForInput = false
		controlSettingUp = ""


func _on_up_btn_pressed() -> void:
	controlSettingUp = "up"
	isWaitingForInput = true


func _on_down_btn_pressed() -> void:
	controlSettingUp = "down"
	isWaitingForInput = true


func _on_left_btn_pressed() -> void:
	controlSettingUp = "left"
	isWaitingForInput = true


func _on_right_btn_pressed() -> void:
	controlSettingUp = "right"
	isWaitingForInput = true


func _on_aim_btn_pressed() -> void:
	controlSettingUp = "changeAimType"
	isWaitingForInput = true


func _on_resolution_btn_item_selected(index: int) -> void:
	if(index == 0):
		GameVars.gameConfigs.video.resolution = Vector2(1920, 1080)
	elif(index == 1):
		GameVars.gameConfigs.video.resolution = Vector2(1600, 900)
	elif(index == 2):
		GameVars.gameConfigs.video.resolution = Vector2(1280, 720)
	elif(index == 3):
		GameVars.gameConfigs.video.resolution = Vector2(640, 480)
	
	GameVars.saveData()
	DisplayServer.window_set_size(GameVars.gameConfigs.video.resolution)


func _on_window_btn_item_selected(index: int) -> void:
	if(index == 0):
		GameVars.gameConfigs.video.windowType = DisplayServer.WINDOW_MODE_FULLSCREEN
	elif(index == 1):
		GameVars.gameConfigs.video.windowType = DisplayServer.WINDOW_MODE_MAXIMIZED
	elif(index == 2):
		GameVars.gameConfigs.video.windowType = DisplayServer.WINDOW_MODE_WINDOWED
	
	GameVars.saveData()
	DisplayServer.window_set_mode(GameVars.gameConfigs.video.windowType)
