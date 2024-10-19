extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if(body.name == "Pc"):
		body.can_pogo = true
	pass # Replace with function body.
