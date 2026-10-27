extends CharacterBody3D

#@onready var camera_pivot: Node3D = $"../CameraPivot"
#@onready var camera: Camera3D = $"../CameraPivot/SpringArm3D/Camera3D"

@export var SPEED = 5.0
@export var ACCEL = 8.0
@export var GRAVITY = 9.81
@export var JUMP_VELOCITY = 5.0

var target_velocity = Vector3.ZERO

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
