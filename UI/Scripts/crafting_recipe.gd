extends Node

class_name crafting_recipe

# This dictionary is an item type to an int
var cost: Dictionary
var output: item_factory.ITEM_TYPE
var output_quantity: int = 1

func can_afford_cost(grid: GridContainer) -> bool:
	var to_ret = true
	for itemType: item_factory.ITEM_TYPE in cost.keys():
		var draggableItem = get_draggable_item(itemType, grid)
		if draggableItem == null:
			return false
		if draggableItem.quantity< cost[itemType]:
			return false
	return to_ret

func get_draggable_item(itemType: item_factory.ITEM_TYPE, grid: GridContainer) -> DraggableItem:
	for child in grid.get_children():
		if child is DraggableItem:
			var item = child as DraggableItem
			if item.itemType == itemType:
				return item
	return null
