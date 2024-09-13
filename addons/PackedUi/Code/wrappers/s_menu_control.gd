class_name SMenuControl extends SControl

## Color for the color rect background
@export var background_color:Color
## If using a ColorRect as background, it is automatically sized to the widt and height of the viewport in Project Settings.
@export var background:ColorRect


func _ready() -> void:
	super()
	_set_background(Vector2(UI.width, UI.height), background_color)
	UI.ButtonPressed.connect(_main_menu_buttons_listener)


func _set_background(_size:Vector2, _color:Color) -> void:
	if background:
		background.size = _size
		background.color = _color


func _main_menu_buttons_listener(_id:String, _from:String) -> void:
	if _id == id:
		UI.ToggleUi.emit(id, true, _from)
