extends Node2D

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()
var spawnerTimer: float = 0
var HudInstance: PackedScene = preload("res://Objects/HUD/HUD.tscn")

func _ready() -> void:
	add_child(HudInstance.instantiate())
	
func _process(delta: float) -> void:
	#print(GameVars.enemyQtd)
	if(spawnerTimer >= 2):
		if(GameVars.enemyQtd < 500):
			spawnEnemy(50)
		spawnerTimer = 0
	else:
		spawnerTimer += delta
	
	if(GameVars.XPInstances.size() != 0):
		WorkerThreadPool.add_task(Callable(GameVars.XPInstances.all).bind(processXPs))
	
	if(GameVars.enemies.size() != 0):
		WorkerThreadPool.add_task(Callable(GameVars.enemies.all).bind(EnemyProcessing))

func spawnEnemy(qtd: int) -> void:
	for i: int in qtd:
		var ins : CharacterBody2D = load("res://Objects/Inimigos/Morcegosa/Morcegosa.tscn").instantiate()
		ins.position = ins.position + Vector2(RNG.randi_range(-800, 800), RNG.randi_range(-500, 500))
		add_child(ins)
		
func EnemyProcessing(enemy: CharacterBody2D):
	if(enemy != null):
		enemy.IaProcess()
		return true
	else:
		return false

func processXPs(xp: Node2D):
	if(xp != null):
		xp.process()
		return true
	else:
		return false