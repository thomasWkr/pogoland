extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Pc':
		var main_layer = body.get_parent().get_child(3)
		if self.get_parent().name == main_layer.name:
			body.got_hit = true
