extends Control

@onready var inventory : Inventory = owner.inventory
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	inventory.update.connect(update_slots)
	update_slots()
	visible = false

func update_slots():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
	for i in range(inventory.slots.size(), slots.size()):
		slots[i].update(null)

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		visible = not visible
	elif visible and Input.is_action_just_pressed("cancel"):
		visible = false
