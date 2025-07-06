extends Node

class_name item_factory

@onready var ItemScn: PackedScene = preload("res://UI/Scenes/Item.tscn")

const ITEM_TYPE_FILE_PATH := "res://Config/item_types.json"
const IMAGE_DIR_PATH = "res://UI/Sprites/"
var item_types_dict: Dictionary = {}
var crafting_recipes:Array[crafting_recipe]

const HUD_VAR := "HUD"
var OFFSET: Vector2 = Vector2(300, 200)
var CAMERA_ZOOM := 1.245

func create_item(parent: Node2D, itemType: String) -> void:
	var item = ItemScn.instantiate()
	
	var HUD: CanvasLayer = get_tree().get_first_node_in_group(HUD_VAR)
	#Gets the screen position of the node
	item.position =  parent.get_global_transform_with_canvas().get_origin()
	var itemSprite: Sprite2D = item.find_child("Sprite")
	itemSprite.texture = get_item_image(itemType)
	HUD.get_node("Items").add_child(item)
	

func get_item_image(type: String) -> Texture2D:
	if not item_types_dict.has(type):
		return item_types_dict["UNDEFINED"].ImageResource
	return item_types_dict[type].ImageResource

func _ready() -> void:
	load_items()

func get_crafting_recipes() -> Array[crafting_recipe]:
	return crafting_recipes

func get_item_definition(item_type: String) -> item_definition:
	if not item_types_dict.has(item_type):
		return item_types_dict["UNDEFINED"]
	return item_types_dict[item_type]

func load_items():
	var file := FileAccess.open(ITEM_TYPE_FILE_PATH, FileAccess.READ)
	if file != null:
		var items = file.get_as_text()
		var parsedText = JSON.parse_string(file.get_as_text())
		if parsedText !=null:
			for dict in parsedText:
				var new_item_type:item_definition = item_definition.new()
				new_item_type.ID = dict["ID"]
				new_item_type.ImageResource = load(IMAGE_DIR_PATH + dict["Image"] + ".png")
				new_item_type.GoldValue = dict["GoldValue"]
				new_item_type.ShopPrice = dict["ShopPrice"]
				new_item_type.CraftingOutput = dict["CraftingOutput"]
				new_item_type.ToolTip = dict["ToolTip"]
				if dict.keys().has("CraftingRecipe"):
					var new_recipe:crafting_recipe = crafting_recipe.new()
					new_recipe.cost = dict["CraftingRecipe"]
					new_recipe.output = dict["ID"]
					new_recipe.output_quantity = dict["CraftingOutput"]
					new_item_type.CraftingRecipe = new_recipe
				item_types_dict[new_item_type.ID] = new_item_type
				if new_item_type.CraftingRecipe != null:
					crafting_recipes.append(new_item_type.CraftingRecipe)
