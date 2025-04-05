extends RigidBody2D

var angular_vel: float =0
var is_angling_launch:=true
var LAUNCH_VEL = 100
var GRAVITY_SCALE = 0.1
@onready var ForwardNode:Node2D = get_node("Forward")

func _process(delta: float) -> void:
	#set_physics_process(false)
	if Input.is_key_pressed(KEY_A):
		angular_vel=1
	elif Input.is_key_pressed(KEY_D):
		angular_vel=-1
	else:
		angular_vel=0
	if Input.is_action_just_pressed("launch"):
		var launch_vel = (ForwardNode.global_position-global_position).normalized() * LAUNCH_VEL
		apply_impulse(launch_vel)
		is_angling_launch = false
		gravity_scale=GRAVITY_SCALE
	pass

func _physics_process(delta: float) -> void:
	if is_angling_launch:
		linear_velocity=Vector2.ZERO
		angular_velocity=angular_vel
		gravity_scale=0
