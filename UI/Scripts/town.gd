extends Control

@onready var inventoryString: Label = get_node("TmpInventoryLabel")
@onready var InventoryGrid:GridContainer = get_node("InventoryGrid")
@onready var ShopLabel: Label = get_node("Shop/ShopLabel")
@onready var ShopGrid:GridContainer = get_node("Shop/ShopGrid")

@export var DraggableItemScn: PackedScene

var item_dictionary: Dictionary = {}

func _ready() -> void:
	load_inventory()
	add_draggable_items()

func load_inventory():
	var file := FileAccess.open(game_controller.INVENTORY_SAVE_FILE_PATH, FileAccess.READ)
	if file != null:
		inventoryString.text = file.get_as_text()
		var parsedText = JSON.parse_string(file.get_as_text())
		if parsedText !=null:
			for k in parsedText.keys():
				item_dictionary[k as item_factory.ITEM_TYPE] = int(parsedText[k])

func add_draggable_items():
	for key in item_dictionary.keys():
		var newItem = DraggableItemScn.instantiate()
		InventoryGrid.add_child(newItem)
		newItem.set_info(key, item_dictionary[key])

func _on_game_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://c6kt75durlr23")


func _on_craft_button_pressed() -> void:
	pass # Replace with function body.


func _on_sell_button_pressed() -> void:
	pass # Replace with function body.


func _on_shop_grid_child_entered_tree(node: Node) -> void:
	if ShopLabel != null:
		evaluate_shop_items()


func _on_shop_grid_child_exiting_tree(node: Node) -> void:
	if ShopLabel != null:
		call_deferred("evaluate_shop_items")

func evaluate_shop_items():
	var sum:=0
	for item in ShopGrid.get_children():
		if item.has_method("get_quantity"):
			sum += item.quantity
	ShopLabel.text = str(sum)
