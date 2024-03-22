class_name Collectible extends StaticBody2D

@export var item : InventoryItem
@export var sprite : Sprite2D
@export var collection_area : Area2D

func _ready():
	assert(item)
	assert(sprite)
	assert(collection_area)
	sprite.texture = item.texture
	collection_area.body_entered.connect(_on_collection_area_body_entered)

func _on_collection_area_body_entered(player : Player):
	if player != null:
		item.collect_item(player, self)
		queue_free()
