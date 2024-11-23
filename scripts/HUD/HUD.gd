extends CanvasLayer

@onready var HPBar = $Status/HPBar
@onready var HPLabel = $Status/HP
@onready var XPBar = $Status/XPBar
@onready var LvlLabel = $Status/LVL

func _process(delta: float) -> void:
	if(GameVars.playerInstance != null):
		HPBar.max_value = GameVars.playerInstance.HPMax
		HPBar.value = GameVars.playerInstance.HP
		XPBar.value = GameVars.playerInstance.XP
		LvlLabel.text = "LVL " + String.num_int64(GameVars.playerInstance.LVL)
		HPLabel.text = String.num_int64(GameVars.playerInstance.HP) + " / " + String.num_int64(GameVars.playerInstance.HPMax)
