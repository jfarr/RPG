class_name Dialog extends Control

signal dialog_started
signal dialog_finished

var dialog = []
var current_dialog_idx = -1
var is_active = false

func _ready():
	$NinePatchRect.visible = false

func start(_dialog):
	if is_active:
		return
	is_active = true

	dialog_started.emit()
	dialog = _dialog
	$NinePatchRect.visible = true
	next_script()

func _input(event):
	if is_active:
		if event.is_action_pressed("accept"):
			next_script()
		elif event.is_action_pressed("cancel"):
			close()

func next_script():
	current_dialog_idx += 1
	if current_dialog_idx < len(dialog):
		$NinePatchRect/Name.text = dialog[current_dialog_idx]["name"]
		$NinePatchRect/Text.text = dialog[current_dialog_idx]["text"]	
	else:
		close()

func close():
	is_active = false
	current_dialog_idx = -1
	$NinePatchRect.visible = false
	dialog_finished.emit()
