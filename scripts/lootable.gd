class_name Lootable extends Node2D

@export var item_scene : PackedScene
@export var wait_time : int = 0

var timer : Timer = Timer.new()
var spawned = null

func _ready():
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(spawn_item)
	add_child(timer)

func _process(delta):
	pass

func spawn_item():
	spawned = item_scene.instantiate()
	spawned.item.item_collected.connect(on_item_collected)
	spawned.global_position = global_position
	get_parent().add_child(spawned)

func on_item_collected(object):
	if wait_time > 0 and object == spawned:
		print("collected")
		timer.wait_time = wait_time
		timer.start()
