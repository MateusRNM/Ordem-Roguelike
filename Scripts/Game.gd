extends Node2D

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()
var spawnerTimer: float = 0
var HudInstance: PackedScene = preload("res://Objects/HUD/HUD.tscn")
var PauseInstance: PackedScene = preload("res://Objects/HUD/Pause.tscn")
var workerThread = WorkerThreadPool

func _ready() -> void:
	GameVars.loadData()
	GameVars.settingUp()
	add_child(HudInstance.instantiate())
	
func _process(delta: float) -> void:
	print(GameVars.enemyQtd)
	if(GameVars.isGamePaused):
		return
		
		
	if(Input.is_action_just_pressed("ESC") && !GameVars.isGamePaused):
		add_child(PauseInstance.instantiate())
		GameVars.isGamePaused = true
	
	if(spawnerTimer >= 2):
		
		if(GameVars.enemyQtd < 600):
			workerThread.add_task(Callable(spawnEnemy).bind(5))
		spawnerTimer = 0
	else:
		spawnerTimer += delta
	
	workerThread.add_task(Callable(GameVars.XPInstances.all).bind(processXPs))
	workerThread.add_task(Callable(GameVars.enemies.all).bind(EnemyProcessing))

func spawnEnemy(qtd: int) -> void:
	for i: int in qtd:
		var ins : Area2D = load("res://Objects/Inimigos/Morcegosa/Morcegosa.tscn").instantiate()
		ins.position = ins.position + Vector2(RNG.randi_range(-800, 800), RNG.randi_range(-500, 500))
		call_deferred("add_child", ins)
		
func EnemyProcessing(enemy : Area2D) -> bool:
	if(enemy != null):
		enemy.IaProcess()
		return true
	else:
		return false

func processXPs(xp : Node2D) -> bool:
	if(xp != null):
		xp.process()
		return true
	else:
		return false
