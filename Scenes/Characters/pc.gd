extends CharacterBody2D

var can_pogo = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if(is_on_floor()):
			velocity.y = JUMP_VELOCITY
		elif(can_pogo):
			velocity.y = JUMP_VELOCITY

	velocity.x = SPEED

	move_and_slide()
