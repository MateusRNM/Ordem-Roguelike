extends CharacterBody2D

var speed: int = 200
var state : String = "IDLE"
var direction: Vector2 = Vector2(0, 0)
var attackDirection: Vector2 = Vector2(0, 1)
var attackDirectionPos: Vector2 = Vector2(0, 1)
var attackByKeyboard: bool = true
var attackTimer: float = 0
var BasicAttackInterval: float = 1.5
var AwakenedAttackInterval: float = 3
var isAttackAwakened : bool = true
var invincibleTimer: float = 0
@export var XPGrabRange: int = 100
@export var invincible: bool = false
@export var LVL: int = 1
@export var XP: int = 0
@export var XpToUp: int = 50
@export var HP: float = 200
@export var HPMax: float = 200
@export var damage: float = 5
@export var isEnemy: bool = false
@onready var attackInstance: PackedScene = preload("res://Objects/Personagens/Sora/Attacks/SoraAttackBasic.tscn")
@onready var awakenedAttackInstance : PackedScene = preload("res://Objects/Personagens/Sora/Attacks/SoraAttackAwakened.tscn")
@onready var Sprite : AnimatedSprite2D = $Sprite

func _ready() -> void:
	GameVars.playerInstance = self

func _process(delta: float) -> void:
	if(HP <= 0):
		pass
	verifyLvl()
	invincibleHandler(delta)
	checkInputs()
	updateSprite()
	verifyAttack(delta)
	move_and_collide(speed * direction * delta)


func verifyLvl():
	if(XP >= XpToUp):
		LVL += 1
		XP -= XpToUp
		XpToUp *= 1.25

func checkInputs() -> void:
	if(Input.is_action_just_pressed("ClickLeft")):
		attackByKeyboard = !attackByKeyboard
	direction = Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S"))
	if(attackByKeyboard):
		attackDirection = direction if direction != Vector2.ZERO else attackDirection
		attackDirectionPos = direction if direction != Vector2.ZERO else attackDirection
	else:
		attackDirectionPos = self.position.direction_to(get_global_mouse_position())
		attackDirection = attackDirectionPos.round()
	direction = direction.normalized()

func invincibleHandler(delta: float):
	if(invincible):
		if(invincibleTimer >= 0.5):
			invincible = false
			invincibleTimer = 0
		else:
			invincibleTimer += delta

func verifyAttack(delta) -> void:
	if(!isAttackAwakened):
		if(attackTimer >= BasicAttackInterval):
			attackTimer = 0
			attackBasic()
	else:
		if(attackTimer >= AwakenedAttackInterval):
			attackTimer = 0
			attackAwakened(4)
		
	attackTimer += delta

func attackBasic() -> void:
	var ins: Area2D = attackInstance.instantiate()
	var insSprite1 : AnimatedSprite2D = ins.get_child(1)
	var insSprite2 : AnimatedSprite2D = ins.get_child(2)
	var insSprite3 : AnimatedSprite2D = ins.get_child(3)
	if(attackDirection == Vector2(1, 0)):
		insSprite1.flip_h = false
		insSprite2.flip_h = false
		insSprite3.flip_h = false
		ins.rotation_degrees = 0
		ins.position += 40*attackDirectionPos
	elif(attackDirection == Vector2(-1, 0)):
		insSprite1.flip_h = true
		insSprite2.flip_h = true
		insSprite3.flip_h = true
		ins.rotation_degrees = 0
		ins.position += 160*attackDirectionPos
	elif(attackDirection == Vector2(0, 1)):
		ins.rotation_degrees = 90
		ins.position += 45*attackDirectionPos
	elif(attackDirection == Vector2(0, -1)):
		ins.rotation_degrees = -90
		ins.position += 45*attackDirectionPos
	elif(attackDirection == Vector2(-1, -1)):
		insSprite1.flip_h = true
		insSprite2.flip_h = true
		insSprite3.flip_h = true
		ins.position += Vector2(60*attackDirection.x, 120*attackDirection.y)
		ins.rotation_degrees = -300
	elif(attackDirection == Vector2(-1, 1)):
		insSprite1.flip_h = true
		insSprite2.flip_h = true
		insSprite3.flip_h = true
		ins.position += Vector2(60*attackDirection.x, 120*attackDirection.y)
		ins.rotation_degrees = 300
	elif(attackDirection == Vector2(1, -1)):
		insSprite1.flip_h = false
		insSprite2.flip_h = false
		insSprite3.flip_h = false
		ins.position += attackDirection * 30
		ins.rotation_degrees = 300
	elif(attackDirection == Vector2(1, 1)):
		insSprite1.flip_h = false
		insSprite2.flip_h = false
		insSprite3.flip_h = false
		ins.position += attackDirection * 30
		ins.rotation_degrees = -300
		
	if(!attackByKeyboard):
		ins.rotation_degrees += ins.global_position.angle_to(attackDirectionPos)
		
	add_child(ins)

func attackAwakened(qtd: int) -> void:
	for i in qtd:
		var ins : Area2D = awakenedAttackInstance.instantiate()
		var insSprite : AnimatedSprite2D = ins.get_child(0)
		ins.position += 160 * attackDirectionPos * i
		if(attackDirection == Vector2(1, 0)):
			insSprite.flip_h = false
			ins.rotation_degrees = 0
		elif(attackDirection == Vector2(-1, 0)):
			insSprite.flip_h = true
			ins.rotation_degrees = 0
		elif(attackDirection == Vector2(0, 1)):
			ins.rotation_degrees = 90
		elif(attackDirection == Vector2(0, -1)):
			ins.rotation_degrees = -90
		elif(attackDirection == Vector2(-1, -1)):
			insSprite.flip_h = true
			ins.rotation_degrees = -300
		elif(attackDirection == Vector2(-1, 1)):
			insSprite.flip_h = true
			ins.rotation_degrees = 300
		elif(attackDirection == Vector2(1, -1)):
			insSprite.flip_h = false
			ins.rotation_degrees = 300
		elif(attackDirection == Vector2(1, 1)):
			insSprite.flip_h = false
			ins.rotation_degrees = -300
		add_child(ins)
	

func updateSprite() -> void:
	if(direction == Vector2.ZERO):
		state = "IDLE"
	else:
		state = "RUNNING"
	
	Sprite.animation = state
	if(direction.x > 0):
		Sprite.flip_h = false
	elif(direction.x < 0):
		Sprite.flip_h = true


func _on_sprite_frame_changed() -> void:
	if(state == "IDLE"):
		return
	if(Sprite.frame == 3 || Sprite.frame == 0):
		Sprite.position.y += 4
	elif(Sprite.frame == 1 || Sprite.frame == 4):
		Sprite.position.y -= 2
	elif(Sprite.frame == 2 || Sprite.frame == 5):
		Sprite.position.y -= 2
