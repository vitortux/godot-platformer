class_name Player extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME: float = 0.15

var is_dead: bool = false
var coyote_timer: float = 0.0
var extra_jumps: int = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction and not is_dead:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_on_floor():
		coyote_timer = COYOTE_TIME
		extra_jumps = 1
	else: 
		velocity += get_gravity() * delta
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		if coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
			animated_sprite.play("jump")
			coyote_timer = 0
		elif extra_jumps > 0: 
			velocity.y = JUMP_VELOCITY
			animated_sprite.play("jump")
			extra_jumps -= 1
		
	if direction == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")

	move_and_slide()
