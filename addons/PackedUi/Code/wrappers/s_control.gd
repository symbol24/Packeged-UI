class_name SControl extends Control


@export var id:String = ""

func _ready() -> void:
	if not UI.is_node_ready():
		await UI.ready
	size.x = UI.width
	size.y = UI.height
	
func _toggle_control(_id:String, _value:bool) -> void:
	if id == "":
		push_error(name, " does not have an id set.")
	else:
		if _id == id:
			set_deferred("visible", _value)
	
