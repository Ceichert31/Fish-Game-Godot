extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 30

@onready var camera_holder: Node3D = $CameraHolder
@onready var camera_3d: Camera3D = $CameraHolder/Camera3D

var isMouseCaptured = false

func _unhandled_input(event: InputEvent) -> void:
	#Lock mouse when clicked on window
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		isMouseCaptured = true
		print("Mouse Captured")
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		isMouseCaptured = false
		print("Mouse not Captured")
		
	#If mouse is in window, have camera follow mouse
	if isMouseCaptured:
		if event is InputEventMouseMotion:
			print("Following Camera")
			camera_holder.rotate_y(-event.relative.x * 0.01 * SENSITIVITY / 100)
			camera_3d.rotate_x(-event.relative.y * 0.01 * SENSITIVITY / 100)
			camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-60), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_foward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
