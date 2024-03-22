class_name InventoryItem extends Resource

signal item_collected(object : Collectible)

@export var name : String = ""
@export var texture : Texture2D

func collect_item(player : Player, object : Collectible):
	player.collect_item(self)
	item_collected.emit(object)
