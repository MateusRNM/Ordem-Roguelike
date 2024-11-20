extends Node

@export var playerInstance : CharacterBody2D 
@export var enemyQtd : int = 0
@export var enemies : Array
@export var enemiesOnScreen : Array

func resetGameVars():
	playerInstance = null
	enemyQtd = 0
	enemies.clear()
	enemiesOnScreen.clear()
