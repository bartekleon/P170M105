extends Node3D

@onready var state = $"../State"
@onready var game2048 = $"../Game2048"

func interact():
	game2048.visible = true
	state.in_2048_game = true

func is_interactable():
	return "interactable"
