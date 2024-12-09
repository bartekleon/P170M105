extends Node3D

@onready var state = $"../State"
var is_open: bool = false

func interact():
	$AnimationPlayer.play("Take 001")
	is_open = true

func is_interactable():
	if is_open:
		return "default"
	return "interactable" if state.keys_found.key_spade else "unavailable"
