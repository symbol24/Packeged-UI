class_name SMenuControl extends SControl

## Color for the color rect background
@export var background_color:Color
##
@export var background:ColorRect

func _ready() -> void:
	super()
	_set_background(size, background_color)

func _set_background(_size:Vector2, _color:Color) -> void:
	if background:
		background.size = _size
		background.color = _color
