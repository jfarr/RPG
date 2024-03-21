class_name NPCDialog
extends Node2D

signal dialog_started
signal dialog_finished

@export var dialog_script : DialogScript

@onready var dialog : Dialog = $Dialog

@onready var mob : MOB = owner

func _process(delta):
	if dialog_script and mob.player and Input.is_action_just_pressed("use"):
		dialog.start(dialog_script.get_messages())

func _on_chat_area_body_entered(body : Player):
	if body != null:
		mob.player = body

func _on_chat_area_body_exited(body : Player):
	if body != null:
		mob.player = null

func _on_dialog_dialog_started():
	dialog_started.emit()

func _on_dialog_dialog_finished():
	dialog_finished.emit()
