extends Area2D

var speed: int = 120
var direction: Vector2 = Vector2(0, 0)
var velocity : Vector2 = Vector2.ZERO
@export var HP: float = 5
@export var isOnScreen : bool = false
var damage: float = 1
var target : CharacterBody2D
var mutex : Mutex = Mutex.new()
@onready var XPInstance: PackedScene = preload("res://Objects/XP/XPAzul.tscn")
@onready var Sprite : AnimatedSprite2D = $sprite
@onready var colisor : CollisionShape2D = $Colisor

func _ready() -> void:
	target = GameVars.playerInstance
	GameVars.enemies.append(self)
	GameVars.enemyQtd += 1

func _process(delta: float) -> void:
	if(!isOnScreen):
		return
	
	if(GameVars.isGamePaused):
		Sprite.stop()
		return
	else:
		if(!Sprite.is_playing()):
			Sprite.play()
			
	if(HP <= 0):
		GameVars.enemyQtd -= 1
		if(GameVars.enemies.find(self) != -1):
			GameVars.enemies.remove_at(GameVars.enemies.find(self))
		
		dropXP()
		self.queue_free()

func dropXP():
	var xpIns = XPInstance.instantiate()
	xpIns.position = self.position
	get_parent().add_child(xpIns)

func IaProcess() -> void:
	call_deferred("updateDirection")
	call_deferred("move")
	call_deferred("checkAttacks")
	

func updateDirection() -> void:
	if(GameVars.playerInstance == null):
		direction = Vector2(0, 0)
		return
	direction = self.position.direction_to(target.position).normalized()
	Sprite.flip_h = true if direction.x < 0 else false
	
func checkAttacks() -> void:
	if(target.invincible):
		return
	if(target.position.distance_to(self.position) < 40):
		mutex.lock()
		target.HP -= damage
		target.invincible = true
		mutex.unlock()

func move():
	global_position += speed * direction * get_process_delta_time()

func _on_visible_notifier_screen_entered() -> void:
	Sprite.show()
	isOnScreen = true
	GameVars.enemiesOnScreen.append(self)


func _on_visible_notifier_screen_exited() -> void:
	Sprite.hide()
	isOnScreen = false
	GameVars.enemiesOnScreen.remove_at(GameVars.enemiesOnScreen.find(self))


func  _physics_process(delta: float) -> void:
	if(GameVars.isGamePaused):
		return
	global_position += velocity * delta
	get_overlapping_areas().all(moveOut)
	velocity *= 0.9
	

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("enemy")):
		velocity += (global_position - area.global_position).normalized() * speed

func moveOut(area : Area2D):
	area.global_position += direction * speed/10 * -1 * get_physics_process_delta_time()
