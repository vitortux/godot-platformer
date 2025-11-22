extends Area2D

@onready var hud = %HUD

func _on_body_entered(body: Node2D) -> void:
	hud.add_point()
	queue_free()
