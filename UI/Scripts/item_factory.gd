extends Node

class_name item_factory

enum ITEM_TYPE {UNDEFINED, FISH1, WOOD, FISH2}

@onready var SpriteDictionary = {ITEM_TYPE.UNDEFINED : load("res://UI/Sprites/TMPItemSprite.png"),
ITEM_TYPE.FISH1: load("res://UI/Sprites/Fish1-Item.png"),
ITEM_TYPE.FISH2: load("res://UI/Sprites/Fish2-Item.png"),
ITEM_TYPE.WOOD: load("res://UI/Sprites/Wood-Item.png")}
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
	
