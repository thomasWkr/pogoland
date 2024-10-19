extends CharacterBody2D

@onready var camera = %Camera2D
@onready var main_scene = self.get_parent()
@onready var parallax_layer = %ParallaxLayer
@onready var parallax_layer2 = %ParallaxLayer2
@onready var parallax_layer3 = %ParallaxLayer3
@onready var parallax_layer4 = %ParallaxLayer4

var initial_position = 0
var can_pogo = false
var got_hit = false
var bird = ''

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 900.0
const ASCEND_MULTIPLIER = 2  # Controls the ascend speed (higher = faster)
const DESCEND_MULTIPLIER = 0.6 # Controls the descend speed (lower = slower)
const PARALLAXES_TOTAL = 4
const LAYERS_TOTAL = 4


func _init() -> void:
	initial_position = global_position

func _physics_process(delta: float) -> void:
	if(got_hit):
		got_hit = false
		death()
	
	if (global_position.y >= 500):
		death()
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	
	# Apply gravity only when not on the floor
	if not is_on_floor():
		if velocity.y < 0:  # Ascending
			velocity.y += GRAVITY * delta * ASCEND_MULTIPLIER
		else:  # Descending
			velocity.y += GRAVITY * delta * DESCEND_MULTIPLIER

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if(is_on_floor()):
			velocity.y = JUMP_VELOCITY
		elif(can_pogo):
			velocity.y = JUMP_VELOCITY
			bird.pogoed = true

	if Input.is_action_just_pressed("Drop Player"):
		drop_player()

	if Input.is_action_just_pressed('Lift Player'):
		lift_player()

	velocity.x = SPEED

	move_and_slide()

func drop_player() -> void:
	var layer1 = main_scene.get_child(2)
	var layer2 = parallax_layer.get_child(0)
	var layer3 = parallax_layer2.get_child(0)
	var layer4 = parallax_layer3.get_child(0)
	var layer5 = parallax_layer4.get_child(0)
	
	var buffer_position_1 = layer1.global_position
	
	layer1.global_position = layer2.global_position
	layer1.scale = layer2.scale
	layer2.global_position = layer3.global_position
	layer2.scale = layer3.scale
	layer3.global_position = layer4.global_position
	layer3.scale = layer4.scale
	layer4.global_position = layer5.global_position
	layer4.scale = layer5.scale
	
	layer5.global_position = buffer_position_1
	layer5.scale = Vector2(1,1)
	
	layer5.reparent(main_scene)
	layer4.reparent(parallax_layer4)
	layer3.reparent(parallax_layer3)
	layer2.reparent(parallax_layer2)
	layer1.reparent(parallax_layer)

func lift_player() -> void:
	var layer1 = main_scene.get_child(2)
	var layer2 = parallax_layer.get_child(0)
	var layer3 = parallax_layer2.get_child(0)
	var layer4 = parallax_layer3.get_child(0)
	var layer5 = parallax_layer4.get_child(0)
	
	var buffer_position_4 = layer4.global_position
	var buffer_scale_4 = layer4.scale
	
	layer4.global_position = layer3.global_position
	layer4.scale = layer3.scale
	layer3.global_position = layer2.global_position
	layer3.scale = layer2.scale
	layer2.global_position = layer1.global_position
	layer2.scale = layer1.scale
	layer1.global_position = layer5.global_position
	layer1.scale = layer5.scale
	
	layer5.global_position = buffer_position_4
	layer5.scale = buffer_scale_4
	
	layer5.reparent(parallax_layer3)
	layer4.reparent(parallax_layer2)
	layer3.reparent(parallax_layer)
	layer2.reparent(main_scene)
	layer1.reparent(parallax_layer4)

func death() -> void:
	print("died")
	call_deferred("reload_scene")

func reload_scene() -> void:
	get_tree().reload_current_scene()
