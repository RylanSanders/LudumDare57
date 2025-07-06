extends Control

class_name town

@onready var inventoryString: Label = get_node("TmpInventoryLabel")
@onready var InventoryGrid:GridContainer = get_node("InventoryGrid")
@onready var ShopLabel: Label = get_node("Shop/ShopLabel")
@onready var ShopGrid:GridContainer = get_node("Shop/ShopGrid")
@onready var GoldLabel:Label = get_node("Shop/GoldLabel")

@export var DraggableItemScn: PackedScene

var gold:= 0

var item_dictionary: Dictionary = {}

func _ready() -> void:
	load_inventory()
	add_draggable_items()
	load_gold()

func load_inventory():
	var file := FileAccess.open(game_controller.INVENTORY_SAVE_FILE_PATH, FileAccess.READ)
	if file != null:
		inventoryString.text = file.get_as_text()
		var parsedText = JSON.parse_string(file.get_as_text())
		if parsedText !=null:
			for k in parsedText.keys():
				item_dictionary[k as String] = int(parsedText[k])

func add_draggable_items():
	for key in item_dictionary.keys():
		var newItem = DraggableItemScn.instantiate()
		InventoryGrid.add_child(newItem)
		newItem.set_info(key, item_dictionary[key])

func _on_game_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://c6kt75durlr23")


func _on_craft_button_pressed() -> void:
	pass # Replace with function body.

func save_inventory():
	var file := FileAccess.open(game_controller.INVENTORY_SAVE_FILE_PATH, FileAccess.WRITE)
	var inventory_string = JSON.stringify(item_dictionary)
	file.store_string(inventory_string)

func _on_sell_button_pressed() -> void:
	var sell_price = evaluate_shop_items()
	gold += sell_price
	record_gold()
	GoldLabel.text = str(gold)
	
	for item in ShopGrid.get_children():
		if item.has_method("get_quantity"):
			item_dictionary[item.itemType] -= item.get_quantity()
			if item_dictionary[item.itemType] == 0:
				item_dictionary.erase(item.itemType)
			item.queue_free()
	save_inventory()

func load_gold():
	var conf := ConfigFile.new()
	var error := conf.load(game_controller.cnf_path)
	if error==OK:
		var saved_gold = conf.get_value(game_controller.GOLD_SECTION_VAR,game_controller.GOLD_VAR,0 )
		gold = saved_gold
		GoldLabel.text =  str(saved_gold)

func record_gold() -> void:
	
	var conf := ConfigFile.new()
	conf.set_value(game_controller.GOLD_SECTION_VAR,game_controller.GOLD_VAR, gold)
	var error := conf.save(game_controller.cnf_path)

func _on_shop_grid_child_entered_tree(node: Node) -> void:
	if ShopLabel != null:
		update_sales_label()


func _on_shop_grid_child_exiting_tree(node: Node) -> void:
	if ShopLabel != null:
		call_deferred("update_sales_label")

func update_sales_label():
	ShopLabel.text = str(evaluate_shop_items())
	
func evaluate_shop_items() -> int:
	var sum:=0
	for item in ShopGrid.get_children():
		if item.has_method("get_quantity"):
			sum += item.get_quantity() * ItemFactory.get_item_definition(item.itemType).GoldValue
	return sum
