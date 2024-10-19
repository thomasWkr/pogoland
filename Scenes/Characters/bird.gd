extends CharacterBody2D

const SPEED = 50.0
var pogoed = false

func _physics_process(_delta: float) -> void:
	if(pogoed):
		print('test')
	else:
		velocity.x = -SPEED

	move_and_slide()

func _on_pogo_detection_area_body_entered(body: Node2D) -> void:
	if(body.name == "Pc"):
		body.can_pogo = true
		body.bird = self
	pass # Replace with function body.

func _on_pogo_detection_area_body_exited(body: Node2D) -> void:
	if(body.name == "Pc"):
		body.can_pogo = false
	pass # Replace with function body.
