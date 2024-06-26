extends Node2D

enum State {
	APPLES,
	NO_APPLES
}

#@export var item : InventoryItem

var apple_scene : PackedScene = preload("res://inventory/scenes/apple_collectible.tscn")

var state = State.APPLES
var player_in_area = false

func _ready():
	$GrowthTimer.start()

func _process(_delta):
	if state == State.NO_APPLES:
		$AnimatedSprite2D.play("no_apples")
	elif state == State.APPLES:
		$AnimatedSprite2D.play("apples")
		if player_in_area and Input.is_action_just_pressed("use"):
			state = State.NO_APPLES
			drop_apple()

func _on_pickable_area_body_entered(_body):
	player_in_area = true

func _on_pickable_area_body_exited(_body):
	player_in_area = false

func _on_growth_timer_timeout():
	state = State.APPLES

func drop_apple():
	var apple = apple_scene.instantiate()
	apple.global_position = global_position
	get_parent().add_child(apple)
	$GrowthTimer.start()
