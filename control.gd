extends Control

var default_color := Color.WHITE
var interactable_color := Color.GREEN
var unavailable_color := Color.RED

@onready var crosshair_node: ColorRect = $ColorRect

func _ready():
	update_crosshair_color("default")

func update_crosshair_color(status: String):
	match status:
		"default":
			crosshair_node.color = default_color
		"interactable":
			crosshair_node.color = interactable_color
		"unavailable":
			crosshair_node.color = unavailable_color
