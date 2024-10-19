extends CharacterBody2D

@onready var camera = %Camera2D

var can_pogo = false
var got_hit = false
var bird = ''

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

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
	# Detach the camera by reparenting it to the scene root
	var current_camera_position = camera.global_transform
	camera.get_parent().remove_child(camera)
	get_tree().root.add_child(camera) 
	camera.global_transform = current_camera_position 
	
	# Remove PC node
	queue_free()
	
