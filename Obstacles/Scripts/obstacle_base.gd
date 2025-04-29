extends Area2D

class_name obstacle_base
@export var durability:float = 10
@export var gold_value:int = 0
@export var damage: int = 0

var is_dead :=false
var death_timer:=0.0
@export var death_delete_delay:float = 1.0

@export var item_type:item_factory.ITEM_TYPE = item_factory.ITEM_TYPE.UNDEFINED

func _process(delta: float) -> void:
	if is_dead:
		death_timer += delta
		if death_timer>death_delete_delay:
			queue_free()

func _on_obstacle_entered(area: Area2D) -> void:
	if area.name == "SpearTipArea":
		var params:obstacle_params  = obstacle_params.new()
		params.durability = durability
		params.gold_value = gold_value
		params.damage = damage
		var is_destroyed: bool = area.get_parent().hit_obstacle(params)
		if is_destroyed:
			_on_destroyed()

#In the future this could be used to add animations and special effects on destroying an object
func _on_destroyed():
	monitorable = false
	monitoring = false
	is_dead = true
	if shardEmitter != null:
		shardEmitter.shatter()
	ItemFactory.create_item(self,item_type)

@onready var shardEmitter:ShardEmitter=$Sprite2D/ShardEmitter

	
