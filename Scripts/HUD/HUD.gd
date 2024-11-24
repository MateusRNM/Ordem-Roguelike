extends CanvasLayer

@onready var HPBar = $Status/HPBar
@onready var HPLabel = $Status/HP
@onready var XPBar = $Status/XPBar
@onready var LvlLabel = $Status/LVL
@onready var FPS = $FPS

func _process(delta: float) -> void:
	FPS.text = "FPS: " + String.num_int64(Engine.get_frames_per_second())
	if(GameVars.playerInstance != null):
		HPBar.max_value = GameVars.playerInstance.HPMax
		HPBar.value = GameVars.playerInstance.HP
		XPBar.max_value = GameVars.playerInstance.XpToUp
		XPBar.value = GameVars.playerInstance.XP
		LvlLabel.text = "LVL " + String.num_int64(GameVars.playerInstance.LVL)
		HPLabel.text = String.num_int64(GameVars.playerInstance.HP) + " / " + String.num_int64(GameVars.playerInstance.HPMax)
