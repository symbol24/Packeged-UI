class_name ToggleUiButton extends Button

@export var target_ui_id:String

var parent_id:String

func _ready() -> void:
	pressed.connect(_btn_pressed)
	var parent:SControl = get_parent() as SControl
	parent_id = parent.id

func _btn_pressed() -> void:
	UI.ToggleUi.emit(target_ui_id, true, parent_id)
