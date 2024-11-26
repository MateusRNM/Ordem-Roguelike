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
	#print(GameVars.enemyQtd)
	if(GameVars.isGamePaused):
		return
		
		
	if(Input.is_action_just_pressed("ESC") && !GameVars.isGamePaused):
		add_child(PauseInstance.instantiate())
		GameVars.isGamePaused = true
	
	if(spawnerTimer >= 1):
		
		if(GameVars.enemyQtd < 500):
			spawnEnemy(10)
		spawnerTimer = 0
	else:
		spawnerTimer += delta
	
	if(GameVars.XPInstances.size() != 0):
		if(GameVars.XPInstances.size() >= 100):
			workerThread.add_task(Callable(processXPs).bind(0, GameVars.XPInstances.size()/4))
			workerThread.add_task(Callable(processXPs).bind(GameVars.XPInstances.size()/4, GameVars.XPInstances.size()/2))
			workerThread.add_task(Callable(processXPs).bind(GameVars.XPInstances.size()/2, GameVars.XPInstances.size()/2 + GameVars.XPInstances.size()/4))
			workerThread.add_task(Callable(processXPs).bind(GameVars.XPInstances.size()/2 + GameVars.XPInstances.size()/4, GameVars.XPInstances.size()))
		else:
			workerThread.add_task(Callable(processXPs).bind(0, GameVars.XPInstances.size()/2))
			workerThread.add_task(Callable(processXPs).bind(GameVars.XPInstances.size()/2, GameVars.XPInstances.size()))
		
	if(GameVars.enemies.size() != 0):
		if(GameVars.enemies.size() >= 100):
			workerThread.add_task(Callable(EnemyProcessing).bind(0, GameVars.enemies.size()/4))
			workerThread.add_task(Callable(EnemyProcessing).bind(GameVars.enemies.size()/4, GameVars.enemies.size()/2))
			workerThread.add_task(Callable(EnemyProcessing).bind(GameVars.enemies.size()/2, GameVars.enemies.size()/2 + GameVars.enemies.size()/4))
			workerThread.add_task(Callable(EnemyProcessing).bind(GameVars.enemies.size()/2 + GameVars.enemies.size()/4, GameVars.enemies.size()))
		else:
			workerThread.add_task(Callable(EnemyProcessing).bind(0, GameVars.enemies.size()/2))
			workerThread.add_task(Callable(EnemyProcessing).bind(GameVars.enemies.size()/2, GameVars.enemies.size()))

func spawnEnemy(qtd: int) -> void:
	for i: int in qtd:
		var ins : Area2D = load("res://Objects/Inimigos/Morcegosa/Morcegosa.tscn").instantiate()
		ins.position = ins.position + Vector2(RNG.randi_range(-800, 800), RNG.randi_range(-500, 500))
		add_child(ins)
		
func EnemyProcessing(i: int, qtd: int) -> void:
	for x: int in range(i, qtd):
		if(GameVars.enemies.size()-1 < x):
			return
		if(GameVars.enemies[x] != null):
			GameVars.enemies[x].IaProcess()

func processXPs(i: int, qtd: int) -> void:
	for x: int in range(i, qtd):
		if(GameVars.XPInstances.size()-1 < x):
			return
		if(GameVars.XPInstances[x] != null):
			GameVars.XPInstances[x].process()
