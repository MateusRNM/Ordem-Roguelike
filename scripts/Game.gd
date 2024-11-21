extends Node2D

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()
var spawnerTimer: float = 0
var HudInstance: PackedScene = preload("res://Objects/HUD/HUD.tscn")

func _ready() -> void:
	add_child(HudInstance.instantiate())
	
func _process(delta: float) -> void:
	#print(GameVars.enemyQtd)
	if(spawnerTimer >= 5):
		if(GameVars.enemyQtd < 800):
			spawnEnemy(50)
		spawnerTimer = 0
	else:
		spawnerTimer += delta
	
	if(GameVars.enemies != null):
		WorkerThreadPool.add_group_task(Callable(EnemyProcessing), GameVars.enemies.size())

func spawnEnemy(qtd: int) -> void:
	for i: int in qtd:
		var ins : CharacterBody2D = load("res://Objects/Inimigos/Morcegosa/Morcegosa.tscn").instantiate()
		ins.position = ins.position + Vector2(RNG.randi_range(-800, 800), RNG.randi_range(-500, 500))
		add_child(ins)
		
func EnemyProcessing(i: int) -> void:
	if(GameVars.enemies.size() > i):
		if(GameVars.enemies[i]):
			GameVars.enemies[i].IaProcess()
	else:
		return
