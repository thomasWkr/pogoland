extends Node2D

@onready var animation = %AnimatedSprite2D
@onready var title = %RichTextLabel

var animation_playing = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Enter") and (not animation_playing)):
		animation.play()
		self.remove_child(title)

func _on_animated_sprite_2d_animation_looped() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")
