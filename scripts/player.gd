class_name Player extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var is_dead: bool = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if (direction != 0):
		animated_sprite.flip_h = direction < 0
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			animated_sprite.play("jump")
		elif direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		velocity += get_gravity() * delta
	
	if not is_dead and direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
