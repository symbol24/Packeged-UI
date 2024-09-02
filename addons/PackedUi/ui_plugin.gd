@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("UI", "res://addons/PackagedUi/UI/UI.tscn")

func _exit_tree() -> void:
	remove_autoload_singleton("Manager")
