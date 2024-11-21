extends CharacterBody2D

var speed: int = 150
var direction: Vector2 = Vector2(0, 0)
@export var HP: float = 20
@export var isEnemy: bool = true
@export var canProcess : bool = true
@export var isOnScreen : bool = false
var damage: float = 1
var target : CharacterBody2D
var mutex : Mutex = Mutex.new()

func _ready() -> void:
	updateTarget()
	GameVars.enemyQtd += 1
	GameVars.enemies.append(self)

func _process(delta: float) -> void:
	if(HP <= 0):
		GameVars.enemyQtd -= 1
		GameVars.enemies.remove_at(GameVars.enemies.find(self))
		self.queue_free()
	
func IaProcess() -> void: 
	if(!canProcess):
		canProcess = true
		return
		
	if(!isOnScreen):
		canProcess = false
	call_deferred("updateDirection")
	call_deferred("checkAttacks")
	call_deferred("move_and_collide", direction * speed * get_process_delta_time())

func updateTarget() -> void:
	target = GameVars.playerInstance

func updateDirection() -> void:
	if(GameVars.playerInstance == null):
		direction = Vector2(0, 0)
		return
	direction = self.position.direction_to(target.position).normalized()
	$sprite.flip_h = true if direction.x < 0 else false
	
func checkAttacks() -> void:
	if(target.position.distance_to(self.position) < 40):
		mutex.lock()
		target.HP -= damage
		mutex.unlock()


func _on_visible_notifier_screen_entered() -> void:
	isOnScreen = true
	GameVars.enemiesOnScreen.append(self)


func _on_visible_notifier_screen_exited() -> void:
	isOnScreen = false
	GameVars.enemiesOnScreen.remove_at(GameVars.enemiesOnScreen.find(self))
