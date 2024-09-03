class_name SButton extends Button

var id:String = ""
var main_menu:MainMenu

func _ready() -> void:
	pressed.connect(_button_pressed)

func _button_pressed():
	main_menu.button_pressed(id)
