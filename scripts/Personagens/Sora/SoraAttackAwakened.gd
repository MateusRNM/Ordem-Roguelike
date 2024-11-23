extends Area2D

var timer : float = 0
var target : CharacterBody2D
var speed : float = 1000
var direction : Vector2
var canPass : bool = false
var passTimer : float = 0
@onready var damageTakenLabel : PackedScene = preload("res://Objects/HUD/DamageTakenLabel.tscn")

func _ready() -> void:
	defineTarget()
	if(target == null):
		direction = GameVars.playerInstance.attackDirectionPos

func _process(delta: float) -> void:
	defineTarget()
	moveToTarget(delta)
	
	if(timer >= 0.25 && target == null):
		self.queue_free()
		
	if(timer >= 2.5):
		self.queue_free()
	else:
		timer += delta
		
func defineTarget() -> void:
	var enemy : CharacterBody2D = null
	for i: int in GameVars.enemiesOnScreen.size():
		if(enemy == null):
			enemy = GameVars.enemiesOnScreen[i] if GameVars.enemiesOnScreen[i] != null else null
		else:
			if(self.global_position.distance_to(enemy.global_position) > self.global_position.distance_to(GameVars.enemiesOnScreen[i].global_position) if GameVars.enemiesOnScreen[i] != null else Vector2.ZERO):
				enemy = GameVars.enemiesOnScreen[i]
	
	target = enemy
		
func moveToTarget(delta: float):
	if(target == null):
		self.global_position += speed * direction * delta
		return
		
	rotation += get_angle_to(target.global_position)
	
	if(!canPass):
		if(self.global_position.distance_to(target.global_position) > 16):
			self.global_position += (target.global_position - global_position).normalized() * speed * delta 
	else:
		self.global_position += direction * speed * delta
		if(passTimer >= 0.4):
			passTimer = 0
			canPass = false
		else:
			passTimer += delta

func _on_body_entered(body: Node2D) -> void:
	if(target == null):
		self.global_position += speed * direction * get_process_delta_time()
		return
	if(body is CharacterBody2D):
		if(body.isEnemy):
			if(!canPass):
				direction = (self.global_position - target.global_position).normalized() 
			body.HP -= GameVars.playerInstance.damage
			var dmglbl = damageTakenLabel.instantiate()
			dmglbl.damage = GameVars.playerInstance.damage
			dmglbl.global_position = body.global_position + Vector2(0, -40)
			body.get_parent().add_child(dmglbl)
			canPass = true


func _on_visible_on_screen_notifier_screen_exited() -> void:
	self.queue_free()
