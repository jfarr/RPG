class_name NPCDialog
extends Node2D

signal dialog_started
signal dialog_finished

@export var dialog_script : DialogScript = null

@onready var dialog : Dialog = $Dialog

@onready var player : Player = null

func _process(delta):
	if dialog_script and player and Input.is_action_just_pressed("use"):
		dialog.start(dialog_script.get_messages())

func _on_chat_area_body_entered(body : Player):
	if dialog_script != null and body != null:
		player = body

func _on_chat_area_body_exited(body : Player):
	if dialog_script != null and body != null:
		player = null
		dialog.close()

func _on_dialog_dialog_started():
	dialog_started.emit()

func _on_dialog_dialog_finished():
	dialog_finished.emit()
