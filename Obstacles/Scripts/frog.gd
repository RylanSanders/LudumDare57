extends obstacle_base


var target_point := Vector2(0, 100)
var is_following_tongue := false


@onready var LeftPupil: Node2D = $LeftPupil
@onready var RightPupil: Node2D = $RightPupil
@onready var Spear: RigidBody2D = %Spear
@onready var Raycast:RayCast2D = $RayCast2D


@onready var TongueLine: Line2D = $TongueLine
@onready var TongueBulb:Node2D = $"FrogTongueParent"
@onready var TongueSpawn:Node2D = $TongueSpawn


func _process(delta: float) -> void:
	if LeftPupil != null and RightPupil != null and Spear != null:
		LeftPupil.look_at(Spear.global_position)
		LeftPupil.rotate(PI/2)
		RightPupil.look_at(Spear.global_position)
		RightPupil.rotate(PI/2)
		if is_following_tongue:
			TongueLine.set_point_position(1,to_local(target_point))
			TongueBulb.global_position = target_point

func shoot_tongue() ->void:
	
	#If I want I can tweak the angle that the ray cast is shooting to change the direction of the frog
	if Raycast.is_colliding():
		TongueLine.clear_points()
		TongueLine.add_point(Vector2.ZERO)
		TongueLine.add_point(Vector2.ZERO)
		target_point = Raycast.get_collision_point()
		var tween = get_tree().create_tween()
		tween.tween_method(set_line_point, to_global(Vector2.ZERO), target_point, 0.75).set_trans(Tween.TRANS_QUAD)
		
		TongueLine.visible = true
		TongueBulb.visible = true

func clear() -> void:
	TongueLine.visible = false
	TongueBulb.visible = false

func set_line_point(point : Vector2) -> void:
	TongueLine.set_point_position(1,to_local(point))
	TongueBulb.rotation = (TongueLine.points[1] - TongueLine.points[0]).angle()  + PI/2
	TongueBulb.global_position = point
	
func follow_tongue() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_point, 0.75).set_trans(Tween.TRANS_QUAD)
	is_following_tongue = true

func flip() ->void:
	rotate(PI)
	is_following_tongue = false
