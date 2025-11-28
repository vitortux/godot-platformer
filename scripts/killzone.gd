extends Area2D

@onready var timer = $Timer
@onready var sfx: AudioStreamPlayer = $SFX

func _on_body_entered(player: Player) -> void:
	Engine.time_scale = 0.5
	player.get_node("CollisionShape2D").queue_free()
	#player.is_dead = true
	sfx.play()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
