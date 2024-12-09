extends CharacterBody3D


const SPEED = 4.5
const JUMP_VELOCITY = 4.5
const SENSIBILITY = 0.01


@onready var head := $Head
@onready var camera := $Head/Camera3D

const BOB_FREQ = 3
const BOB_AMP = 0.08
var bob_pos = 0.0
var can_play = true
signal step

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSIBILITY)
		camera.rotate_x(-event.relative.y * SENSIBILITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

	if event is InputEventMouseButton:
		camera.interact_with_world()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Audio stuff
	bob_pos += delta * velocity.length()
	var pos_y = sin(bob_pos * BOB_FREQ) * BOB_AMP
	var low_pos = -(BOB_AMP - 0.05)
	if pos_y > low_pos:
		can_play = true
	if pos_y < low_pos and can_play:
		can_play = false
		emit_signal("step")

	move_and_slide()
