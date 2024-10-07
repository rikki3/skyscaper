extends Node2D

@export var player_path : NodePath
@onready var Player = get_node("/root/World/Player")
@onready var Animator = get_node("/root/World/Player/Sprite/AnimatedSprite2D")

var previous_frame_velocity := Vector2(0,0)

func _ready() -> void:
	if Player == null:
		print("Sprite.gd is missing player_path")
		set_process(false)
	else:
		set_process(true)
		Animator.set_flip_h(false)


func _process(_delta: float) -> void:
	if Player.velocity.x < 0:
		Animator.set_flip_h(false)
	elif Player.velocity.x > 0:
		Animator.set_flip_h(false)

	if previous_frame_velocity.y >= 0 and Player.velocity.y < 0:
		Animator.play("Jump")
	elif previous_frame_velocity.y > 0 and Player.is_on_floor():
		Animator.play("Idle")
	elif previous_frame_velocity.x != 0 and Player.is_on_floor():
		Animator.play("Run")
	elif !Player.is_on_floor():
		Animator.play("Fall")
	elif Player.velocity.y == 0 and Player.velocity.x == 0:
		Animator.play("Idle")
	# It's important that this is the last thing done
	previous_frame_velocity = Player.velocity
