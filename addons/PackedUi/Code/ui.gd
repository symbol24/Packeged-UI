extends CanvasLayer

signal ToggleUi(id:String, value:bool, previous:String)
signal ReturnToMainMenu()
signal WindowResized(_value:Vector2i)
signal OptionUpdated(id:String, value)
signal TogglePauseGame(value:bool)
signal PopupSmall(text:String, icon:Texture2D)
signal PopupLarge(severity, title:String, text:String, popup_id:String, icon:CompressedTexture2D, timer:float)
signal PopupResult(id:String, result:bool)

## Setting your own theme here will make the menu more personalized. Please note that a lot of Type Variations are being used. Have a look at the default_theme.tres in the Packed Ui addon folder. A lot of Style Boxes are used and can be found in the StyleBoxes folder.
@export var default_theme:Theme

var window_size:Vector2i
var height:float  = 720
var width:float = 1280
var themed_ui:Array = []
var theme_timer:float = 0.0
var theme_check_delay:float = 60
var size_timer:float = 0.0:
	set(_value):
		size_timer = _value
		if size_timer >= size_delay:
			window_size = _get_window_size(window_size)
var size_delay:float = 0.5
var game_name:String
var previous_menu:String

func _ready() -> void:
	window_size = _get_window_size(window_size)
	width = ProjectSettings.get_setting("display/window/size/viewport_width")
	height = ProjectSettings.get_setting("display/window/size/viewport_height")
	await get_tree().create_timer(0.5).timeout
	_set_theme_ui(_get_themed_ui(), default_theme)

func _physics_process(delta: float) -> void:
	size_timer += delta

func _get_window_size(_current:Vector2i) -> Vector2i:
	if _current != DisplayServer.window_get_size():
		WindowResized.emit(DisplayServer.window_get_size())
		return DisplayServer.window_get_size()
	return _current

func _set_theme_ui(_list:Array, _theme:Theme) ->void:
	for each in _list:
		if each.theme != _theme:
			each.theme = _theme

func _get_themed_ui() -> Array:
	var children = _get_all_children(self)
	var themed:Array = []
	for child in children:
		if child is Control and child.theme and not themed.has(child):
			themed.append(child)
	return themed

func _get_all_children(_parent:Node) -> Array:
	var children = _parent.get_children()
	for child in children:
		if child.get_children().size() > 0:
			children.append_array(_get_all_children(child))
	return children
