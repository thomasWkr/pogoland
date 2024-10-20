extends Sprite2D

var pulse = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame. 
func _process(delta: float) -> void:
	if(pulse):
		self.scale = Vector2(self.scale.x + 0.01, self.scale.y + 0.01)
		if(self.scale.x >= 4):
			pulse = false
	
	if(not pulse):
		self.scale = Vector2(self.scale.x - 0.01, self.scale.y - 0.01)
		if(self.scale.x <= 3.5):
			pulse = true
		

	
