extends Node2D

@onready var CraftingGrid:GridContainer = get_node("AnvilGrid")
@onready var CreatedItemGrid:GridContainer = get_node("CreatedItemGrid")
@export var DraggableItemScn: PackedScene

@onready var Town:town = get_node("..")


var crafting_recipes:Array[crafting_recipe] = []
var last_crafting_recipe: crafting_recipe

func _ready() -> void:
	load_crafting_recipes()

func load_crafting_recipes() -> void:
	var recipe: crafting_recipe = crafting_recipe.new()
	recipe.cost = {ItemFactory.ITEM_TYPE.WOOD: 2, ItemFactory.ITEM_TYPE.SEAWEED: 1}
	recipe.output = ItemFactory.ITEM_TYPE.JELLYFISH
	crafting_recipes.append(recipe)

func _on_anvil_grid_child_entered_tree(node: Node) -> void:
	if node is DraggableItem:
		evaluate_crafting_recipes()
	

func evaluate_crafting_recipes():
	for child in CreatedItemGrid.get_children():
		if child is DraggableItem:
			if child.is_preview:
				child.queue_free()
	for recipe in crafting_recipes:
		if recipe.can_afford_cost(CraftingGrid):
			last_crafting_recipe = recipe
			if created_item_grid_has_children():
				pass
			else:
				var createdItem:DraggableItem = DraggableItemScn.instantiate()
				CreatedItemGrid.add_child(createdItem)
				createdItem.set_info(recipe.output, recipe.output_quantity, true)
			apply_costs(recipe)
			return
			

func created_item_grid_has_children() -> bool:
	for child in CreatedItemGrid.get_children():
		if child is DraggableItem:
			return true
	return false

func apply_costs(recipe: crafting_recipe):
	for item in CraftingGrid.get_children():
		if item is DraggableItem:
			if recipe.cost.keys().has(item.itemType):
				item.set_consumed(recipe.cost[item.itemType])

func _on_anvil_grid_child_exiting_tree(node: Node) -> void:
	if node is DraggableItem:
		node.set_consumed(0)
		call_deferred("evaluate_crafting_recipes")


func _on_craft_button_button_down() -> void:
	if not last_crafting_recipe.can_afford_cost(CraftingGrid):
		return
	for child in CraftingGrid.get_children():
		if child is DraggableItem:
			child.set_quantity(child.quantity - child.to_consume_quantity)
			Town.item_dictionary[child.itemType] -=child.to_consume_quantity
	for child in CreatedItemGrid.get_children():
		if child is DraggableItem:
			if child.is_preview:
				child.set_preview(false)
				if Town.item_dictionary.keys().has(child.itemType):
					Town.item_dictionary[child.itemType] +=1
				else:
					Town.item_dictionary[child.itemType] = 1
			else:
				child.set_quantity(child.quantity + 1)
				Town.item_dictionary[child.itemType] +=1
	Town.save_inventory()
	call_deferred("evaluate_crafting_recipes")
