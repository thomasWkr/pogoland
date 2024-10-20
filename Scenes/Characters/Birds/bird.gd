extends CharacterBody2D

const SPEED = 50.0
var pogoed = false
var persue = false

# Reference to the player
var player: Node2D = null

func _physics_process(_delta: float) -> void:
	if(pogoed):
		pass
	else:
		velocity.x = -SPEED

	if(persue):
		velocity.x = -SPEED
	else: 
		velocity.x = 0
		
	move_and_slide()
	
func _on_pogo_detection_area_body_entered(body: Node2D) -> void:
	if(body.name == "Pc"):
		var main_layer = body.get_parent().get_child(3)
		if self.get_parent().name == main_layer.name:
			body.can_pogo = true
			body.bird = self

func _on_pogo_detection_area_body_exited(body: Node2D) -> void:
	if(body.name == "Pc"):
		body.can_pogo = false

func _on_detectiona_area_body_entered(body: Node2D) -> void:
	if(body.name == "Pc"):
		persue = true
