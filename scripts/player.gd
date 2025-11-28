class_name Player extends CharacterBody2D

enum PlayerState {
	IDLE, RUN, JUMP, DOWN
}

@export var speed: int = 130
@export var acceleration: int = 20
@export var jump_velocity: int = -300
@export var gravity: int = 980
@export var down_gravity: float = 1.5
@export var extra_jumps: int = 1

var current_state: PlayerState = PlayerState.IDLE 
var extra_jump_count: int = 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer: Timer = $JumpBuffer
@onready var coyote_timer: Timer = $CoyoteTimer

func _physics_process(delta: float) -> void:
	set_input()
	set_movement(delta)
	set_player_state()
	set_animation()
	move_and_slide()


func set_input() -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start()
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else:
		velocity.x = move_toward(velocity.x, speed * direction, acceleration)


func set_movement(delta: float) -> void:
	if (is_on_floor() or coyote_timer.time_left > 0) and jump_buffer.time_left > 0:
		velocity.y = jump_velocity
		current_state = PlayerState.JUMP
		jump_buffer.stop()
		coyote_timer.stop()
	elif jump_buffer.time_left > 0 and extra_jump_count < extra_jumps:
		velocity.y = jump_velocity
		current_state = PlayerState.JUMP
		extra_jump_count += 1
		jump_buffer.stop()

 	
	if current_state == PlayerState.JUMP:
		velocity.y += gravity * delta
	else:
		velocity.y += gravity * down_gravity * delta


func set_animation() -> void:
	if velocity.x != 0:
		animated_sprite_2d.scale.x = sign(velocity.x)
	
	match current_state:
		PlayerState.IDLE: animated_sprite_2d.play("idle")
		PlayerState.RUN: animated_sprite_2d.play("run")
		PlayerState.JUMP: animated_sprite_2d.play("jump_up")
		PlayerState.DOWN: animated_sprite_2d.play("jump_down")


func set_player_state() -> void:
	match current_state:
		PlayerState.IDLE when velocity.x != 0:
			current_state = PlayerState.RUN
		
		PlayerState.RUN:
			if velocity.x == 0:
				current_state = PlayerState.IDLE
			if not is_on_floor() and velocity.y > 0:
				current_state = PlayerState.DOWN
				coyote_timer.start()
		
		PlayerState.JUMP when velocity.y > 0:
			current_state = PlayerState.DOWN
		
		PlayerState.DOWN when is_on_floor():
			extra_jump_count = 0
			
			if velocity.x == 0:
				current_state = PlayerState.IDLE
			else:
				current_state = PlayerState.RUN
