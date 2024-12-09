extends MeshInstance3D

@onready var state = $"../State"

func interact():
	state.keys_found.key_club = true
	self.hide()

func is_interactable():
	return "interactable"
