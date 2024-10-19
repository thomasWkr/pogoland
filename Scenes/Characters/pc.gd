extends CharacterBody2D

@onready var camera = %Camera2D
@onready var main_scene = self.get_parent()
@onready var parallax_layer = %ParallaxLayer
@onready var parallax_layer2 = %ParallaxLayer2
@onready var parallax_layer3 = %ParallaxLayer3
@onready var parallax_layer4 = %ParallaxLayer4
@onready var theme_player = %Theme

var initial_position = 0
var can_pogo = false
var got_hit = false
var bird = ''

# Screenshake variables
var shake_magnitude = 10  # Default shake intensity
var shake_duration = 0.1  # Default shake duration
var shake_timer = 0.0     # Timer to track the shake duration
var original_camera_position = Vector2()


const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const GRAVITY = 1100.0
const ASCEND_MULTIPLIER = 1.6  # Controls the ascend speed (higher = faster)
const DESCEND_MULTIPLIER = 1 # Controls the descend speed (lower = slower)
const PARALLAXES_TOTAL = 4
const LAYERS_TOTAL = 4


# Function to start the screenshake effect with custom intensity and duration
func start_screenshake(intensity: float, duration: float) -> void:
	shake_magnitude = intensity
	shake_duration = duration
	original_camera_position = camera.position
	shake_timer = shake_duration

func _process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer -= delta
		camera.position = original_camera_position + Vector2(randi_range(-shake_magnitude, shake_magnitude), randi_range(-shake_magnitude, shake_magnitude))
		
		if shake_timer <= 0:
			camera.position = original_camera_position  # Reset camera position after shaking


func _init() -> void:
	initial_position = global_position

func _physics_process(delta: float) -> void:
	if(got_hit):
		got_hit = false
		death()
	
	if (global_position.y >= 500):
		death()
	
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
			#start_screenshake()  # Start the screenshake when jumping
		elif(can_pogo):
			velocity.y = JUMP_VELOCITY
			bird.pogoed = true
			start_screenshake(5, 0.1)  # Small shake for pogo jump

	if Input.is_action_just_pressed("Drop Player"):
		drop_player()

	if Input.is_action_just_pressed('Lift Player'):
		lift_player()

	velocity.x = SPEED

	move_and_slide()

func drop_player() -> void:
	var layer1 = main_scene.get_child(3)
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
	var layer1 = main_scene.get_child(3)
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
	start_screenshake(50, 0.3)  # Stronger shake for death
	await get_tree().create_timer(0.3).timeout
	call_deferred("reload_scene")

func reload_scene() -> void:
	get_tree().reload_current_scene()

func _on_theme_finished() -> void:
	theme_player.play(1.33)
	pass # Replace with function body.
