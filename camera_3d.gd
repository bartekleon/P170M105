extends Camera3D

@onready var crosshair := $Control
@onready var raycast = $RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_interaction()

func check_interaction():
	var collider = raycast.get_collider()
	if not collider:
		crosshair.update_crosshair_color("default")
		return

	var instance = collider.get_owner()
	if instance.has_method("is_interactable"):
		crosshair.update_crosshair_color(instance.is_interactable())

func interact_with_world():
	var collider = raycast.get_collider()
	if not collider:
		return
	var instance = collider.get_owner()
	if instance.has_method("is_interactable") and instance.is_interactable() == "interactable":
		raycast.add_exception(collider)
		instance.interact()
