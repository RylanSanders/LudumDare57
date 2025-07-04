extends Node2D

@onready var CraftingGrid:GridContainer = get_node("AnvilGrid")
@onready var CreatedItemGrid:GridContainer = get_node("CreatedItemGrid")
@export var DraggableItemScn: PackedScene

var crafting_recipes:Array[crafting_recipe] = []

func _ready() -> void:
	load_crafting_recipes()

func load_crafting_recipes() -> void:
	var recipe: crafting_recipe = crafting_recipe.new()
	recipe.cost = {ItemFactory.ITEM_TYPE.WOOD: 2, ItemFactory.ITEM_TYPE.SEAWEED: 1}
	recipe.output = ItemFactory.ITEM_TYPE.JELLYFISH
	crafting_recipes.append(recipe)

func _on_anvil_grid_child_entered_tree(node: Node) -> void:
	if node is DraggableItem:
		node.set_consumed(1)
		evaluate_crafting_recipes()
	

func evaluate_crafting_recipes():
	for child in CreatedItemGrid.get_children():
		if child is DraggableItem:
			child.queue_free()
	for recipe in crafting_recipes:
		if recipe.can_afford_cost(CraftingGrid):
			var createdItem:DraggableItem = DraggableItemScn.instantiate()
			CreatedItemGrid.add_child(createdItem)
			createdItem.set_info(recipe.output, recipe.output_quantity, true)
			return

func _on_anvil_grid_child_exiting_tree(node: Node) -> void:
	if node is DraggableItem:
		node.set_consumed(0)
		call_deferred("evaluate_crafting_recipes")
