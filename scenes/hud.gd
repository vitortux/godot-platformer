extends CanvasLayer

var score: int = 0
@onready var score_label: Label = $Control/MarginContainer/HBoxContainer/ScoreLabel
		
func add_point() -> void:
	score += 1
	score_label.text = "Moedas: " + str(score)
