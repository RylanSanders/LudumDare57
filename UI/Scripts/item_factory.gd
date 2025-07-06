extends Node

class_name item_factory

enum ITEM_TYPE {UNDEFINED, FISH1, WOOD, FISH2, FISH3, FROG, JELLYFISH, MERMAN, ROCK, SEAWEED}

@onready var SpriteDictionary = {ITEM_TYPE.UNDEFINED : load("res://UI/Sprites/TMPItemSprite.png"),
ITEM_TYPE.FISH1: load("res://UI/Sprites/Fish1-Item.png"),
ITEM_TYPE.FISH2: load("res://UI/Sprites/Fish2-Item.png"),
ITEM_TYPE.WOOD: load("res://UI/Sprites/Wood-Item.png"),
ITEM_TYPE.FISH3: load("res://UI/Sprites/Fish3-Item.png"),
ITEM_TYPE.FROG: load("res://UI/Sprites/FrogTongue-Item.png"),
ITEM_TYPE.JELLYFISH: load("res://UI/Sprites/JellyFish-Item.png"),
ITEM_TYPE.MERMAN: load("res://UI/Sprites/Merman-Item.png"),
ITEM_TYPE.SEAWEED: load("res://UI/Sprites/Seaweed-Item.png"),
ITEM_TYPE.ROCK: load("res://UI/Sprites/Rock-Item.png")}

@onready var IDToTypeID = {ITEM_TYPE.UNDEFINED : "UNDEFINED",
ITEM_TYPE.FISH1: "FISH1",
ITEM_TYPE.FISH2: "FISH2",
ITEM_TYPE.WOOD: "WOOD",
ITEM_TYPE.FISH3: "FISH3",
ITEM_TYPE.FROG: "FROG",
ITEM_TYPE.JELLYFISH: "JELLYFISH",
ITEM_TYPE.MERMAN: "MERMAN",
ITEM_TYPE.SEAWEED: "SEAWEED",
ITEM_TYPE.ROCK: "ROCK"}

@onready var ItemScn: PackedScene = preload("res://UI/Scenes/Item.tscn")

const ITEM_TYPE_FILE_PATH := "user://item_types.json"
var item_types_dict: Dictionary = {}
var crafting_recipes:Array[crafting_recipe]

const HUD_VAR := "HUD"
var OFFSET: Vector2 = Vector2(300, 200)
var CAMERA_ZOOM := 1.245

func create_item(parent: Node2D, itemType: ITEM_TYPE) -> void:
	var item = ItemScn.instantiate()
	
	var HUD: CanvasLayer = get_tree().get_first_node_in_group(HUD_VAR)
	#Gets the screen position of the node
	item.position =  parent.get_global_transform_with_canvas().get_origin()
	var itemSprite: Sprite2D = item.find_child("Sprite")
	itemSprite.texture = SpriteDictionary[itemType]
	HUD.get_node("Items").add_child(item)
	

func get_item_image(type: ITEM_TYPE) -> Texture2D:
	return SpriteDictionary[type]

func _ready() -> void:
	load_items()

func get_crafting_recipes() -> Array[crafting_recipe]:
	return crafting_recipes

func get_item_definition(item_type: String) -> item_definition:
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
				new_item_type.ImagePath = dict["Image"]
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
