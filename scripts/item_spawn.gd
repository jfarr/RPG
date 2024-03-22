class_name ItemSpawn extends Node2D

@export var item_scene : PackedScene
@export var wait_time : int = 0

var timer : Timer = Timer.new()
var spawned : Collectible = null

func _ready():
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(spawn_item)
	add_child(timer)

func spawn_item():
	spawned = item_scene.instantiate()
	get_parent().add_child(spawned)
	spawned.global_position = global_position
	spawned.item.item_collected.connect(on_item_collected)

func on_item_collected(object):
	if object == spawned:
		timer.wait_time = wait_time
		timer.start()
