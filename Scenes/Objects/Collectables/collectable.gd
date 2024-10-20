extends Area2D

@export var sprite_index: int
@onready var sprite = %Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if(body.name == 'Pc'):
		body.collectable_count += 1
		print(body.collectable_count)
		queue_free()
