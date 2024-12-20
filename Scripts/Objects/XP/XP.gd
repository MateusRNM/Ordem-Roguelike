extends Node2D

var XPValue: int = 0
@export var xpColor : String = ""
@onready var initialPos: Vector2 = position
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var Sprite : AnimatedSprite2D
@onready var SpriteAzul : AnimatedSprite2D = $AnimationPlayer/spriteAzul
@onready var SpriteVermelho : AnimatedSprite2D = $AnimationPlayer/spriteVermelho
var anim : Animation
var isOnScreen : bool = true

func _ready() -> void:
	if(xpColor == "azul"):
		XPValue = 10
		SpriteAzul.visible = true
		animationPlayer.root_node = SpriteAzul.get_path()
		Sprite = SpriteAzul
	elif(xpColor == "vermelho"):
		XPValue = 75
		SpriteVermelho.visible = true
		animationPlayer.root_node = SpriteVermelho.get_path()
		Sprite = SpriteVermelho
	
	anim = animationPlayer.get_animation("flutuar").duplicate()
	anim.track_set_key_value(0, 0, initialPos)
	anim.track_set_key_value(0, 1, initialPos + Vector2(0, 10))
	anim.track_set_key_value(0, 2, initialPos)
	animationPlayer.get_animation_library("").add_animation("other", anim)
	animationPlayer.play("other")
	GameVars.XPInstances.append(self)

func _process(delta: float) -> void:
	if(!isOnScreen):
		return
	if(GameVars.isGamePaused):
		animationPlayer.pause()
		Sprite.pause()
	else:
		if(!animationPlayer.is_playing()):
			animationPlayer.play()
		
		if(!Sprite.is_playing()):
			Sprite.play()

func process():
	if(!isOnScreen):
		return
	call_deferred("verify")

func verify():
	if(GameVars.playerInstance != null):
		if(self.global_position.distance_to(GameVars.playerInstance.global_position) <= GameVars.playerInstance.GrabRange):
			GameVars.playerInstance.XP += XPValue
			if(GameVars.XPInstances.find(self) != -1):
				GameVars.XPInstances.remove_at(GameVars.XPInstances.find(self))
			self.queue_free()


func _on_visible_on_screen_notifier_screen_entered() -> void:
	Sprite.show()
	isOnScreen = true
	set_physics_process(true)
	animationPlayer.play("other")


func _on_visible_on_screen_notifier_screen_exited() -> void:
	Sprite.hide()
	isOnScreen = false
	set_physics_process(false)
	animationPlayer.pause()
