extends CanvasLayer

@onready var HPBar = $Status/HPBar
@onready var HPLabel = $Status/HP

func _process(delta: float) -> void:
	if(GameVars.playerInstance != null):
		HPBar.max_value = GameVars.playerInstance.HPMax
		HPBar.value = GameVars.playerInstance.HP
		HPLabel.text = String.num_int64(GameVars.playerInstance.HP) + " / " + String.num_int64(GameVars.playerInstance.HPMax)
