extends Area2D

@export var sprite_index: int
@onready var sprite = %Sprite2D

func collect(body) -> void:
	if body.name == 'Pc':
		var main_layer = body.get_parent().get_child(3)
		if self.get_parent().name == main_layer.name:
			body.collectable_count += 1
			print(body.collectable_count)
			self.queue_free() 

func _on_body_entered(body: Node2D) -> void:
	collect(body)
