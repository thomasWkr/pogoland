extends Area2D

@export var color = ''
@onready var polygon = %Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon.color = color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if(body.name == 'Pc'):
		body.got_hit = true
