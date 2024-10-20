extends CharacterBody2D

@onready var camera = %Camera2D
@onready var main_scene = self.get_parent()
@onready var parallax_layer = %ParallaxLayer
@onready var parallax_layer2 = %ParallaxLayer2
@onready var parallax_layer3 = %ParallaxLayer3
@onready var parallax_layer4 = %ParallaxLayer4
@onready var theme_player = %Theme
@onready var sfx_player = %SFXPlayer
@onready var switch_layer_player = %SwitchLayerPlayer
@onready var death_player = %DeathPlayer
@onready var animation = %AnimatedSprite2D
@onready var particle_emitter = %BLOODSPREAD
@onready var pogo_emitter = %PogoSpread

var initial_position = 0
var collectable_count = 0
var is_jumping = true
var can_pogo = false
var got_hit = false
var alive = true
var bird = ''
var can_tp = 1

# Screenshake variables
var shake_magnitude = 10  # Default shake intensity
var shake_duration = 0.1  # Default shake duration
var shake_timer = 0.0     # Timer to track the shake duration
var original_camera_position = Vector2()

const DELTA = 10
var SPEED = 300.0
const JUMP_VELOCITY = -600.0
var GRAVITY = 1100.0
const ASCEND_MULTIPLIER = 1.6  # Controls the ascend speed (higher = faster)
const DESCEND_MULTIPLIER = 1 # Controls the descend speed (lower = slower)
const PARALLAXES_TOTAL = 4
const LAYERS_TOTAL = 4
const JUMP_AUDIO = preload("res://Assets/Audio/jump.ogg")
const FISH_AUDIO = preload("res://Assets/Audio/fish.ogg")
const DRAGONFLY_AUDIO = preload("res://Assets/Audio/dragonfly.ogg")
const SEAGULL_AUDIO = preload("res://Assets/Audio/seagull.ogg")
const UFO_AUDIO = preload("res://Assets/Audio/ufo.ogg")
const FAIRY_AUDIO = preload("res://Assets/Audio/fairy.ogg")

@onready var tilemap_layer1 = get_parent().get_child(3).get_child(1)
@onready var tilemap_layer2 = get_parent().get_child(1).get_child(0).get_child(0).get_child(2)
@onready var tilemap_layer3 = get_parent().get_child(1).get_child(1).get_child(0).get_child(2)
@onready var tilemap_layer4 = get_parent().get_child(1).get_child(2).get_child(0).get_child(2)
@onready var tilemap_layer5 = get_parent().get_child(2).get_child(0).get_child(0).get_child(2)

var current_layer = 1
var changing_layer = false

func up_layer():
	if current_layer == 5:
		current_layer= 1
	else: 
		current_layer+=1

func down_layer():
	if current_layer == 1:
		current_layer= 5
	else: 
		current_layer-=1


#shader function
func flash():
	print(current_layer)
	tilemap_layer1.material.set_shader_parameter("modifier", 0.5)
	tilemap_layer2.material.set_shader_parameter("modifier", 0.5)
	tilemap_layer3.material.set_shader_parameter("modifier", 0.65)
	tilemap_layer4.material.set_shader_parameter("modifier", 0.8)
	tilemap_layer5.material.set_shader_parameter("modifier", 0.5)

	
func unflash(current_layer):
	match current_layer:
		1:
			tilemap_layer1.material.set_shader_parameter("modifier", 0)
			tilemap_layer2.material.set_shader_parameter("modifier", 0.5)
			tilemap_layer3.material.set_shader_parameter("modifier", 0.65)
			tilemap_layer4.material.set_shader_parameter("modifier", 0.8)
			tilemap_layer5.material.set_shader_parameter("modifier", 0.5)
		2:
			tilemap_layer1.material.set_shader_parameter("modifier", 0.5)
			tilemap_layer2.material.set_shader_parameter("modifier", 0)
			tilemap_layer3.material.set_shader_parameter("modifier", 0.5)
			tilemap_layer4.material.set_shader_parameter("modifier", 0.65)
			tilemap_layer5.material.set_shader_parameter("modifier", 0.8)
		3:
			tilemap_layer1.material.set_shader_parameter("modifier", 0.8)
			tilemap_layer2.material.set_shader_parameter("modifier", 0.5)
			tilemap_layer3.material.set_shader_parameter("modifier", 0)
			tilemap_layer4.material.set_shader_parameter("modifier", 0.5)
			tilemap_layer5.material.set_shader_parameter("modifier", 0.65)
		4:
			tilemap_layer1.material.set_shader_parameter("modifier", 0.65)
			tilemap_layer2.material.set_shader_parameter("modifier", 0.8)
			tilemap_layer3.material.set_shader_parameter("modifier", 0.5)
			tilemap_layer4.material.set_shader_parameter("modifier", 0)
			tilemap_layer5.material.set_shader_parameter("modifier", 0.5)
		5:
			tilemap_layer1.material.set_shader_parameter("modifier", 0.5)
			tilemap_layer2.material.set_shader_parameter("modifier", 0.65)
			tilemap_layer3.material.set_shader_parameter("modifier", 0.8)
			tilemap_layer4.material.set_shader_parameter("modifier", 0.5)
			tilemap_layer5.material.set_shader_parameter("modifier", 0)

# Variables to control the shader modifier
var modifier := 0.0
var modifier_speed := 3.0  # Speed of the modifier change
var increasing := true  # Whether the modifier is increasing

# Reference to the material (ensure you assign it in the inspector or via code)
func shader_trans(delta: float) -> void:
	if increasing:
		modifier += modifier_speed * delta  # Increase the modifier
		if modifier >= 1.0:
			modifier = 1.0
			increasing = false  # Start decreasing
	else:
		modifier -= modifier_speed * delta /1.5 # Decrease the modifier
		if modifier <= 0.0:
			modifier = 0.0
			increasing = true  # Start increasing
			changing_layer = false
	# Apply the updated modifier to the shader
	tilemap_layer1.material.set_shader_parameter("modifier", modifier)
	tilemap_layer2.material.set_shader_parameter("modifier", modifier)
	tilemap_layer3.material.set_shader_parameter("modifier", modifier)
	tilemap_layer4.material.set_shader_parameter("modifier", modifier)
	tilemap_layer5.material.set_shader_parameter("modifier", modifier)

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
	if changing_layer:
		shader_trans(delta)

func _iwadanit() -> void:
	initial_position = global_position

func _ready() -> void:
	animation.play()
	#flash()
	#  unflash(current_layer)
	# Imprimir o nome do nó que foi acessado
	print(tilemap_layer1.name)
	print(tilemap_layer2.name)
	print(tilemap_layer3.name)
	print(tilemap_layer4.name)
	print(tilemap_layer5.name)

func _physics_process(delta: float) -> void:
	if(alive):
		if(got_hit or global_position.y >= 500):
			alive = false
			animation.visible = false
			particle_emitter.emitting = true
			start_screenshake(10, 1.2)  
			death_player.play()

		if not is_on_floor():
			if velocity.y < 0:  # Ascending
				velocity.y += GRAVITY * delta * ASCEND_MULTIPLIER
			else:  # Descending
				velocity.y += GRAVITY * delta * DESCEND_MULTIPLIER
		else:
			if(is_jumping):
				animation.animation = "default"
				animation.play()
				is_jumping = false

		if Input.is_action_just_pressed("jump"):
			if(is_on_floor()):
				is_jumping = true
				pogo_emitter.emitting = true
				animation.animation = "jumping"
				play_sfx(JUMP_AUDIO, -10.0)
				velocity.y = JUMP_VELOCITY
				#start_screenshake()  # Start the screenshake when jumping
			elif(can_pogo):
				type_of_bird(bird.name)
				velocity.y = JUMP_VELOCITY
				bird.pogoed = true
				start_screenshake(5, 0.1)  # Small shake for pogo jump

		elif Input.is_action_just_pressed("Drop Player"):
			switch_layer_player.play()
			drop_player()

		elif Input.is_action_just_pressed('Lift Player'):
			switch_layer_player.play()
			lift_player()

		velocity.x = SPEED

		move_and_slide()

func drop_player() -> void:
	if (can_tp):
		can_tp = 0
		
		changing_layer = true
		#down_layer()
		#flash()
		#unflash(current_layer)
	
		var layer1 = main_scene.get_child(3)
		var layer2 = parallax_layer.get_child(0)
		var layer3 = parallax_layer2.get_child(0)
		var layer4 = parallax_layer3.get_child(0)
		var layer5 = parallax_layer4.get_child(0)
  
		if is_on_floor():
			velocity.y = -100
		set_collision_layer_value(1,0)
		set_collision_mask_value(1,0)
			
		animation.animation = "jumping"
		is_jumping = true
		for i in DELTA:
			animation.scale+= Vector2(0.3, 0.3)
			await get_tree().create_timer(0.01).timeout
		
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
		
		set_collision_layer_value(1,1)
		set_collision_mask_value(1,1)
		global_position.y-=100
		
		for i in DELTA:
			animation.scale-= Vector2(0.3, 0.3)
			await get_tree().create_timer(0.01).timeout
		
		await get_tree().create_timer(0.1).timeout
		if is_on_floor():
			animation.animation = "default" 
		can_tp = 1

func lift_player() -> void:
	if can_tp:
		can_tp=0
		changing_layer = true
		#up_layer()
		#flash()
		#unflash(current_layer)
		var layer1 = main_scene.get_child(3)
		var layer2 = parallax_layer.get_child(0)
		var layer3 = parallax_layer2.get_child(0)
		var layer4 = parallax_layer3.get_child(0)
		var layer5 = parallax_layer4.get_child(0)

		var buffer_position_4 = layer4.global_position
		var buffer_scale_4 = layer4.scale
		
		if is_on_floor():
			velocity.y = -300
		set_collision_layer_value(1,0)
		set_collision_mask_value(1,0)
			
		animation.animation = "jumping"
		is_jumping = true
		for i in DELTA:
			animation.scale-= Vector2(0.15, 0.15)
			await get_tree().create_timer(0.01).timeout
		
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
		
		set_collision_layer_value(1,1)
		set_collision_mask_value(1,1)
		global_position.y-=100
		
		for i in DELTA:
			animation.scale+= Vector2(0.15, 0.15)
			await get_tree().create_timer(0.01).timeout
		
		await get_tree().create_timer(0.1).timeout
		if is_on_floor():
			animation.animation = "default" 
		can_tp = 1

func play_sfx(audio: AudioStreamOggVorbis, volume_intensity: float) -> void:
	sfx_player.volume_db = volume_intensity
	sfx_player.stream = audio
	sfx_player.play()

func type_of_bird(bird_name):
	if(bird_name.contains('Fish')):
		play_sfx(FISH_AUDIO, 0.0)
	elif(bird_name.contains('Dragonfly')):
		play_sfx(DRAGONFLY_AUDIO, 0.0)
	elif(bird.name.contains("Seagull")):
		play_sfx(SEAGULL_AUDIO, 0.0)
	elif(bird.name.contains("UFO")):
		play_sfx(UFO_AUDIO, 0.0)
	elif(bird.name.contains("Fairy")):
		play_sfx(FAIRY_AUDIO, 3.0)

func _on_theme_finished() -> void:
	theme_player.play(0.0)

func reload_scene() -> void:
	get_tree().reload_current_scene()

func _on_death_player_finished() -> void:
	await get_tree().create_timer(0.3).timeout
	call_deferred("reload_scene")
