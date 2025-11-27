class_name Player extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME: float = 0.15
const MAX_HOLD_TIME: float = 0.2
const MIN_HOLD_FACTOR: float = 0.1

var is_dead: bool = false
var coyote_timer: float = 0.0
var extra_jumps: int = 1
var is_holding_jump: bool = false
var jump_press_time: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction and not is_dead:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction == 0:
		animated_sprite.play("idle")
	elif not is_dead:
		animated_sprite.play("run")

	if is_on_floor():
		coyote_timer = COYOTE_TIME
		extra_jumps = 1
	else: 
		var gravity := get_gravity()
		if velocity.y > 0:
			gravity *= 1.5 
		velocity += gravity * delta
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump") and not is_dead:
		is_holding_jump = true
		jump_press_time = 0.0
		
		if coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
			animated_sprite.play("jump")
			coyote_timer = 0
		elif extra_jumps > 0: 
			velocity.y = JUMP_VELOCITY
			animated_sprite.play("jump")
			extra_jumps -= 1

	if is_holding_jump:
		jump_press_time += delta

	if Input.is_action_just_released("jump") or is_on_ceiling():
		is_holding_jump = false
		var hold_factor: float = clamp(jump_press_time / MAX_HOLD_TIME, 0.0, 1.0)
		velocity.y = lerp(velocity.y * MIN_HOLD_FACTOR, velocity.y, hold_factor)
		
	move_and_slide()
