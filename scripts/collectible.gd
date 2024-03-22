class_name Collectible extends StaticBody2D

@export var item : InventoryItem
@export var sprite : Sprite2D
@export var collection_area : Area2D
@export var animation_player : AnimationPlayer

func _ready():
	assert(item)
	assert(sprite)
	assert(collection_area)
	sprite.texture = item.texture
	collection_area.body_entered.connect(_on_collection_area_body_entered)
	if animation_player:
		animation_player.play("spawn")

func _on_collection_area_body_entered(player : Player):
	if player != null:
		item.collect_item(player, self)
		queue_free()
