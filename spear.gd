extends RigidBody2D

var angular_vel: float =0
var is_angling_launch:=true
var is_strength_launch:=false
var is_under_water:=false
var LAUNCH_VEL = 10
var GRAVITY_SCALE = 0.2
var ANGULAR_ROT_SPEED = 4
var UNDER_WATER_CONSTANT_UPWARDS_FORCE = -550
var GAME_OVER_TIME = 1
var game_over_timer=0
var is_stuck:= false

@onready var ForwardNode:Node2D = get_node("Forward")
@onready var LeftNode:Node2D = get_node("Left")
@onready var RightNode:Node2D = get_node("Right")
@onready var LaunchStrengthBar:TextureProgressBar = get_node("../LaunchStrengthProgressBar")
@onready var GameController = get_node("..")
@onready var Shop: shop = get_node("../Shop")

@onready var BreathSound: AudioStreamPlayer = get_node("Audio/Breath")
@onready var WaterSound: AudioStreamPlayer = get_node("Audio/Water")


func _process(delta: float) -> void:
	if is_angling_launch:
		if Input.is_action_pressed("left"):
			angular_vel=ANGULAR_ROT_SPEED
		elif Input.is_action_pressed("right"):
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
			var launch_vel = (ForwardNode.global_position-global_position).normalized() * LAUNCH_VEL * (LaunchStrengthBar.value/5)* (Shop.launch+1)
			apply_impulse(launch_vel)
			BreathSound.play()
	if not is_angling_launch and not is_strength_launch and is_under_water and linear_velocity.y<1:
		game_over_timer+=delta
		if game_over_timer>GAME_OVER_TIME:
			GameController.game_over()
	else:
		game_over_timer=0

func _physics_process(delta: float) -> void:
	if is_angling_launch or is_strength_launch:
		linear_velocity=Vector2.ZERO
		angular_velocity=angular_vel
		gravity_scale=0

var TEMP_MOVE_FORCE := 200
var FAKE_GRAVITY := 200
var WEIGHT_AMPLIFIER := 30
var MOVE_ANGULAR_VEL := 1
var MAGIC_MODIFIER = 1
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	if not is_angling_launch and not is_strength_launch:
		var fake_gravity = (ForwardNode.global_position-global_position).normalized() * FAKE_GRAVITY + (Vector2(0, 1)*(WEIGHT_AMPLIFIER * Shop.weight))
		state.apply_force(fake_gravity)
		if Input.is_action_pressed("left"):
			var left_vec = (LeftNode.global_position-global_position).normalized()
			#state.apply_force(left_vec * TEMP_MOVE_FORCE)
			state.angular_velocity = MOVE_ANGULAR_VEL * MAGIC_MODIFIER * (Shop.magic+1)
		elif Input.is_action_pressed("right"):
			var right_vec = (RightNode.global_position-global_position).normalized()
			#state.apply_force(right_vec * TEMP_MOVE_FORCE)
			state.angular_velocity = -MOVE_ANGULAR_VEL * MAGIC_MODIFIER * (Shop.magic+1)
	if is_stuck:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
	


func _ready() -> void:
	BreathSound.volume_linear = AudioManger.sound_volumn
	WaterSound.volume_linear = AudioManger.sound_volumn

func _on_spear_tip_area_area_entered(area: Area2D) -> void:
	if area.name == "WaterStartArea":
		constant_force.y = UNDER_WATER_CONSTANT_UPWARDS_FORCE
		is_under_water = true
		WaterSound.play()
		gravity_scale = GRAVITY_SCALE
	if area.name.begins_with("bound"):
		GameController.out_of_bounds()

var MIN_WALL_BOUNCE_VEL := 20.0
func _on_spear_tip_area_body_entered(body: Node2D) -> void:
	if body.name == "TileMapLayer":
		print(str(linear_velocity.length()))
		if linear_velocity.length() < MIN_WALL_BOUNCE_VEL:
			is_stuck = true

var durabilityModifier = 1
#For now this is going to return true if the ostacle isbroken and false otherwise
func hit_obstacle(params: obstacle_params) -> bool:
	apply_impulse(Vector2(0,-params.durability* durabilityModifier))
	GameController.add_gold(params.gold_value)
	if not does_spear_break_through(params):
		is_stuck = true
		return false
	return true

var LENGTH_MULTIPLER := 0.1
func does_spear_break_through(params:obstacle_params) -> bool:
	if linear_velocity.length() * LENGTH_MULTIPLER > params.durability:
		return true
	return false
