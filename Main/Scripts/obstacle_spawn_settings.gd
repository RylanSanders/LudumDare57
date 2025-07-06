extends Resource

class_name  obstacle_spawn_settings

@export var min_depth_to_spawn: int
@export var max_depth_to_spawn: int
@export var spawn_prob: float
@export var obstacle_scn: PackedScene
@export var spawn_on_edges:bool = false
@export var spawn_swarm:=false
@export var swarm_min:=1
@export var swarm_max:=4
