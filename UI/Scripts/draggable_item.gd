extends Panel

class_name DraggableItem

@onready var ItemSprite:Sprite2D = get_node("Sprite2D")
@onready var QuantityLabel:Label = get_node("QuantityLabel")
@onready var ConsumedLabel:Label = get_node("ConsumedLabel")

var itemType: item_factory.ITEM_TYPE = item_factory.ITEM_TYPE.UNDEFINED
var quantity := 0

var is_mouse_over:bool = false
var is_dragging:bool = false
var is_preview:bool = false

func set_info(type: item_factory.ITEM_TYPE, quantity:int, is_preview:bool=false):
	ItemSprite.texture = ItemFactory.get_item_image(type)
	QuantityLabel.text = str(quantity)
	self.quantity = quantity
	self.itemType = type
	self.is_preview = is_preview
	if is_preview:
		ItemSprite.modulate.r = 1.5
		ItemSprite.modulate.g = 1.5
		ItemSprite.modulate.b = 1.5
	

func _input(event: InputEvent) -> void:
	if is_preview:
		return
	if is_mouse_over and event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = true
	if event is InputEventMouseMotion and is_dragging:
		global_position = global_position + event.relative 
	if is_dragging and event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = false
		position=Vector2.ZERO
		#get scene root and filter the nodes for container nodes then check the size and position or bounds? for if the position is in it
		var grid_nodes = get_grid_children(get_tree().root)
		for grid:GridContainer in grid_nodes:
			if grid.get_rect().has_point(event.position):
				reparent(grid, false)
				break
		if get_parent_control() is Container:
			get_parent_control().queue_sort()

#If this is too slow I could call it on load and store references to the grids
#Wrote this so that lower level nodes get returned first for layering
func get_grid_children(node:Node) -> Array:
	var grid_children:Array = []
	for child in node.get_children():
		get_grid_children_rec(child,grid_children)
		if child is GridContainer:
			grid_children.append(child)
	return grid_children

func get_grid_children_rec(node:Node, node_list: Array) -> void:
	for child in node.get_children():
		get_grid_children_rec(child,node_list)
		if child is GridContainer:
			node_list.append(child)

func _on_mouse_entered() -> void:
	modulate.a = 3.0
	is_mouse_over = true

func _on_mouse_exited() -> void:
	modulate.a = 0.8
	is_mouse_over = false

func get_quantity() -> int:
	return quantity

func set_consumed(num: int):
	ConsumedLabel.text = str(num)
	if num == 0:
		ConsumedLabel.text = ""
