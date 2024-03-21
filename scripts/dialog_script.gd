class_name DialogScript
extends Resource

@export_file("*.json") var dialog_file

var messages = null

func get_messages():
	if not messages:
		var file = FileAccess.open(dialog_file, FileAccess.READ)
		messages = JSON.parse_string(file.get_as_text())
	return messages
