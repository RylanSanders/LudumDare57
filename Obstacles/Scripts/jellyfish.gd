extends obstacle_base

#I'm going to try making this a child of a rigid body in this scene - I don't know if this will work
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rigidBody : RigidBody2D = $".."
@onready var orbSpawn: Node2D = $OrbSpawn

@export var orb: PackedScene

func play_animation():
	sprite.play("default")
	spawn_orb()

func move():
	var rand := randf_range(-1,1)
	rigidBody.apply_impulse(Vector2(rand,-0.5))
	
func spawn_orb():
	var new_orb = orb.instantiate()
	get_parent().get_parent().add_child(new_orb)
	new_orb.global_position = orbSpawn.global_position
