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
@onready var ItemScn: PackedScene = preload("res://UI/Scenes/Item.tscn")

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
