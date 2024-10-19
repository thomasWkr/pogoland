extends CharacterBody2D

@onready var camera = %Camera2D

var initial_position = 0
var can_pogo = false
var got_hit = false
var bird = ''

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _init() -> void:
	initial_position = global_position

func _physics_process(delta: float) -> void:
	if(got_hit):
		got_hit = false
		death()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if(is_on_floor()):
			velocity.y = JUMP_VELOCITY
		elif(can_pogo):
			velocity.y = JUMP_VELOCITY
			bird.pogoed = true
	
#if Input.is_action_just_pressed("Lift Layer"):
  
	velocity.x = SPEED

	move_and_slide()

func death() -> void:
	# Respawn the player to the original position
	global_position = initial_position
