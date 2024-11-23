extends Node2D

var XPValue: int = 10
@onready var initialPos: Vector2 = position
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
var anim : Animation
var isOnScreen : bool = true

func _ready() -> void:
	anim = animationPlayer.get_animation("flutuar").duplicate()
	anim.track_set_key_value(0, 0, initialPos)
	anim.track_set_key_value(0, 1, initialPos + Vector2(0, 10))
	anim.track_set_key_value(0, 2, initialPos)
	animationPlayer.get_animation_library("").add_animation("other", anim)
	animationPlayer.play("other")
	GameVars.XPInstances.append(self)

func process():
	if(!isOnScreen):
		return
	call_deferred("verify")

func verify():
	if(GameVars.playerInstance != null):
		if(self.global_position.distance_to(GameVars.playerInstance.global_position) <= GameVars.playerInstance.XPGrabRange):
			GameVars.playerInstance.XP += XPValue
			if(GameVars.XPInstances.find(self) != -1):
				GameVars.XPInstances.remove_at(GameVars.XPInstances.find(self))
			self.queue_free()


func _on_visible_on_screen_notifier_screen_entered() -> void:
	isOnScreen = true
	set_physics_process(true)
	animationPlayer.play("other")


func _on_visible_on_screen_notifier_screen_exited() -> void:
	isOnScreen = false
	set_physics_process(false)
	animationPlayer.stop()
