class_name PauseMenu extends SMenuControl

## If TRUE, emits signal UI.TogglePauseGame as false to be used by your code to toggle the pause state of your game.
@export var use_pause_game_signal:bool = true
## If FALSE, removes the spacer and pause_page_title RichTextLabel on runtime.
@export var display_page_title:bool = true
## Name displayed at the top of the menu on runtime.
@export var page_title:String
## If TRUE, sets the position of the back button through code.
@export var set_position_of_buttons:bool = true
## If FALSE, hides the button to open the settings menu.
@export var display_options_menu_button:bool = true

@onready var spacer: Control = %spacer
@onready var pause_page_title: RichTextLabel = %pause_page_title
@onready var pause_back_btn: Button = %pause_back_btn
@onready var settings_btn: Button = %settings_btn

func _ready() -> void:
	super()
	
	if display_page_title:
		pause_page_title.hide()
		spacer.hide()
	else:
		pause_page_title.text = "[center]" + page_title + "[/center]"
		
	pause_back_btn.pressed.connect(_back_btn_pressed)
	
	if set_position_of_buttons:
		pause_back_btn.position = (Vector2(UI.width, UI.height) * 0.95) - pause_back_btn.size
		settings_btn.position = (Vector2(UI.width, UI.height) * 0.95) - pause_back_btn.size - Vector2(settings_btn.size.x+20, 0)
	
	if not display_options_menu_button:
		settings_btn.hide()

func _back_btn_pressed() -> void:
	_toggle_control(id, false, id)
	
	if use_pause_game_signal:
		UI.TogglePauseGame.emit(false)
