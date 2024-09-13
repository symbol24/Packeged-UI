class_name MainMenu extends SMenuControl

## If TRUE, will ignore name in Game Title parameter and fetch name from the Project settings.
@export var get_name_from_properties:bool = false
## Sets the text of the game title lavel on runtime. BBCode is supported.
@export var game_title:String = "Game Title Here"
## Listing the menu buttons here will create buttons on runtime in the Main Menu. Pressing the button emits a signal (ButtonPressed) with the id listed here.
@export var menu_options:Array[String] = []

@onready var game_title_label: RichTextLabel = %game_title_label
@onready var menu_button_vbox: VBoxContainer = %menu_button_vbox
@onready var hbox_seperator_01: Control = %hbox_seperator_01
@onready var hbox_seperator_02: Control = %hbox_seperator_02
@onready var buttons_hbox: HBoxContainer = %buttons_hbox

var button_list:Array[MainMenuButton] = []


func _ready() -> void:
	super()
	
	if not UI.is_node_ready():
		await UI.ready
	
	_set_game_title(game_title)
	game_title_label.custom_minimum_size.y = UI.height/3
	menu_button_vbox.custom_minimum_size.x = UI.width/3
	hbox_seperator_01.custom_minimum_size.x = UI.width/3
	hbox_seperator_02.custom_minimum_size.x = UI.width/3
	_make_buttons(menu_options)
	
	if not button_list.is_empty() and not button_list[-1].is_node_ready():
		await button_list[-1].ready


func _set_game_title(_value:String = "") -> void:
	if get_name_from_properties:
		UI.game_name = ProjectSettings.get_setting("application/config/name")
		game_title_label.text = UI.game_name
	else:
		game_title_label.text = _value
		UI.game_name = _value


func _make_buttons(_list:Array[String]) -> Array[MainMenuButton]:
	var buttons:Array[MainMenuButton] = []
	var previous:MainMenuButton
	if _list.is_empty():
		push_error("Main menu options list is empty.")
		return buttons
		
	var x:int = 0
	for each in _list:
		var new_button = MainMenuButton.new()
		buttons.append(new_button)
		menu_button_vbox.add_child.call_deferred(new_button)
		await new_button.ready
		new_button.name = "btn_"+each
		new_button.text = each
		new_button.id = each
		new_button.main_menu = self
		new_button.theme = UI.default_theme
		new_button.focus_mode = Control.FOCUS_ALL
		if previous != null:
			new_button.set_focus_neighbor(SIDE_TOP, previous.get_path())
			previous.set_focus_neighbor(SIDE_BOTTOM, new_button.get_path())
		if x == _list.size() - 1:
			buttons[0].set_focus_neighbor(SIDE_TOP, new_button.get_path())
			new_button.set_focus_neighbor(SIDE_BOTTOM, buttons[0].get_path())
		previous = new_button
		button_list.append(new_button)
		x += 1
	return buttons


func _toggle_control(_id:String, _value:bool, _previous:String = "") -> void:
	if id == "":
		push_error(name, " does not have an id set.")
	else:
		UI.previous_menu = _previous
		if _id == id:
			_set_game_title(game_title)
			set_deferred("visible", _value)
			if _value:
				if not button_list.is_empty():
					button_list[0].grab_focus()
		else:
			set_deferred("visible", not _value)


func button_pressed(_id:String) -> void:
	UI.ButtonPressed.emit(_id.to_lower(), id)
