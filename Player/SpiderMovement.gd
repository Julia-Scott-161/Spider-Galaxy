extends CharacterBody3D


@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $"CameraPivot/SpringArm3D/SpiderCam"
@onready var ray: RayCast3D = $SpiderRay
@onready var model: Node3D = $ModelMesh

@export var SPEED = 5.0
@export var ACCEL = 8.0
@export var JUMP_VELOCITY = 5.0
@export var GRAVITY = 9.81
@export_range(0.0, 1.0) var mouse_sensitivity = 0.004
#Note: Currently set so that the camera cant clip through the floor.
#If the camera position or rotation changes, this will likely need to be changed too.
@export var tilt_limit = deg_to_rad(40)

var target_velocity = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	#Mouselook implemented using 'screen_relative' for resolution-independent sensitivity
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		camera_pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		#Prevent the camera from rotating to far up or down.
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		camera_pivot.rotation.y += -event.screen_relative.x * mouse_sensitivity
	

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("Forward") :
		direction.z -= 1
	if Input.is_action_pressed("Left") :
		direction.x -= 1
	if Input.is_action_pressed("Right") :
		direction.x += 1
	if Input.is_action_pressed("Backward") :
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		direction = direction.rotated(Vector3.UP, camera_pivot.global_rotation.y)
		#Rotate the model to face whatever "forwards" is
		#Currently a hard snap, can be fixed later if time allows
		model.global_rotation.y = atan2(
			-direction.x,
			-direction.z
		)
	
	if direction != Vector3.ZERO:
		var ray_length: float = 0.75
		var target_area = ray.global_position + direction * ray_length
		ray.target_position = ray.to_local(target_area)
		ray.force_raycast_update()
		print("ray global position: ", ray.global_basis * ray.target_position.normalized())
	
	#Ground Velocity (no accel)
	#target_velocity.x = direction.x * SPEED
	#target_velocity.z = direction.z * SPEED
	
	#Ground Velocity (with accel)
	var horizontal := Vector3(target_velocity.x, 0, target_velocity.z)
	horizontal = horizontal.move_toward(direction * SPEED, ACCEL * delta)
	target_velocity.x = horizontal.x
	target_velocity.z = horizontal.z
	
	#Vertical Velocity
	if not is_on_floor() :
		target_velocity.y -= GRAVITY * delta
	else :
		target_velocity.y = 0.0
		if Input.is_action_just_pressed("Jump"):
			target_velocity.y += JUMP_VELOCITY
		
	#Moving the Player
	velocity = target_velocity
	move_and_slide()
	#Verify the RayCast3D is working (for debug purposes)
	if ray.is_colliding():
		print("Direction: ", direction,
		" | Normal: ", ray.get_collision_normal(),
		" | Point: ", ray.get_collision_point()
		)
