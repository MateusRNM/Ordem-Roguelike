extends Area2D

var reversedX : bool = false
@onready var spritePart1 : AnimatedSprite2D = $spritePart1
@onready var spritePart2 : AnimatedSprite2D = $spritePart2
@onready var spritePart3 : AnimatedSprite2D = $spritePart3
@onready var damageTakenLabel : PackedScene = preload("res://Objects/HUD/DamageTakenLabel.tscn")

func _ready() -> void:
	reversedX = true if GameVars.playerInstance.attackDirection.x == -1 else false
	if(reversedX):
		spritePart1.visible = false
		spritePart2.visible = false
		spritePart3.visible = true
		spritePart3.play("default")
		spritePart1.position.x += 90
	else:
		spritePart1.visible = true
		spritePart2.visible = false
		spritePart3.visible = false
		spritePart1.play("default")

func _process(delta: float) -> void:
	if(GameVars.isGamePaused):
		if(spritePart1.is_playing()):
			spritePart1.pause()
		elif(spritePart2.is_playing()):
			spritePart2.pause()
		elif(spritePart3.is_playing()):
			spritePart3.pause()
	else:
		if(!spritePart1.is_playing()):
			spritePart1.play()
		elif(!spritePart2.is_playing()):
			spritePart2.play()
		elif(!spritePart3.is_playing()):
			spritePart3.play()

func _on_body_entered(body: Node2D) -> void:
	if(body is CharacterBody2D):
		if(body.isEnemy):
			body.HP -= GameVars.playerInstance.damage
			var dmglbl = damageTakenLabel.instantiate()
			dmglbl.damage = GameVars.playerInstance.damage
			dmglbl.global_position = body.global_position + Vector2(0, -40)
			body.get_parent().add_child(dmglbl)

func _on_sprite_part_1_animation_finished() -> void:
	if(reversedX):
		self.queue_free()
	else:
		spritePart1.visible = false
		spritePart2.visible = true
		spritePart3.play("default")


func _on_sprite_part_2_animation_finished() -> void:
	if(reversedX):
		spritePart2.visible = false
		spritePart3.visible = true
		spritePart1.play("default")
	else:
		spritePart2.visible = false
		spritePart3.visible = true
		spritePart3.play("default")


func _on_sprite_part_3_animation_finished() -> void:
	if(reversedX):
		spritePart3.visible = false
		spritePart2.visible = true
		spritePart2.play("default")
	else:
		self.queue_free()
