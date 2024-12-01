extends Area2D

var speed: int = 100
var direction: Vector2 = Vector2(0, 0)
@export var knockback : Vector2 = Vector2.ZERO
@export var knockback_resistance : float = 1
@export var HP: float = 5
@export var isOnScreen : bool = false
var damage: float = 1
var target : CharacterBody2D
var mutex : Mutex = Mutex.new()
@onready var XPInstance: PackedScene = preload("res://Objects/XP/XP.tscn")
@onready var Sprite : AnimatedSprite2D = $sprite
@onready var colisor : CollisionShape2D = $Colisor
var RNG = RandomNumberGenerator.new()
var frameCount : int = RNG.randi_range(0, 16)

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
		GameVars.enemies.remove_at(GameVars.enemies.find(self))
		
		dropXP()
		self.queue_free()

func _physics_process(delta: float) -> void:
	if(GameVars.isGamePaused):
		return
	
	if(frameCount < 16):
		frameCount += 1
		return
	else:
		frameCount = 0
	
	for i : Area2D in get_overlapping_areas():
		i.knockback = global_position.direction_to(i.global_position) * speed*1.8 * delta

func dropXP():
	var xpIns = XPInstance.instantiate()
	xpIns.xpColor = "azul"
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

func move() -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_resistance)
	global_position += speed * direction * get_physics_process_delta_time() + knockback
		
func _on_visible_notifier_screen_entered() -> void:
	Sprite.show()
	isOnScreen = true
	GameVars.enemiesOnScreen.append(self)


func _on_visible_notifier_screen_exited() -> void:
	Sprite.hide()
	isOnScreen = false
