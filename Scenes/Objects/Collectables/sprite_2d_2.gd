extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.rotation += 0.01
	if(self.rotation == 360):
		self.rotation = 0
