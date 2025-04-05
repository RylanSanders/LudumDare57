extends RigidBody2D

var angular_vel: float =0
var is_angling_launch:=true
var is_strength_launch:=false
var LAUNCH_VEL = 100
var GRAVITY_SCALE = 0.5
var ANGULAR_ROT_SPEED = 4

@onready var ForwardNode:Node2D = get_node("Forward")
@onready var LaunchStrengthBar:TextureProgressBar = get_node("../LaunchStrengthProgressBar")

func _process(delta: float) -> void:
	if is_angling_launch:
		if Input.is_key_pressed(KEY_A):
			angular_vel=ANGULAR_ROT_SPEED
		elif Input.is_key_pressed(KEY_D):
			angular_vel=-ANGULAR_ROT_SPEED
		else:
			angular_vel=0
	if Input.is_action_just_pressed("launch"):
		if is_angling_launch:
			is_angling_launch = false
			is_strength_launch = true
		elif is_strength_launch:
			gravity_scale=GRAVITY_SCALE
			is_strength_launch = false
			var launch_vel = (ForwardNode.global_position-global_position).normalized() * LAUNCH_VEL * (LaunchStrengthBar.value/5)
			apply_impulse(launch_vel)
	pass

func _physics_process(delta: float) -> void:
	if is_angling_launch or is_strength_launch:
		linear_velocity=Vector2.ZERO
		angular_velocity=angular_vel
		gravity_scale=0
