extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var frog_sfx: AudioStreamPlayer2D = $SFX

func _ready():
	animated_sprite_2d.connect("frame_changed", _on_frame_changed)


func _on_frame_changed():
	match animated_sprite_2d.frame:
		3:
			frog_sfx.play(1.20)
