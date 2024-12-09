extends MeshInstance3D

@onready var state = $"../State"
@onready var game2048 = $"../Game2048"

func interact():
	game2048.visible = true
	state.in_2048_game = true
	state.keys_found.key_spade = true
	self.hide()

func is_interactable():
	return "interactable"
