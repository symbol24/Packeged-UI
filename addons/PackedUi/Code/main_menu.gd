class_name MainMenu extends SMenuControl

signal ButtonPressed(id:String)

## Sets the text of the game title lavel on runtime. BBCode is accepted.
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
	game_title_label.text = "[center]"+_value+"[/center]"
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
			set_deferred("visible", _value)
			if _value:
				if not button_list.is_empty():
					button_list[0].grab_focus()
		else:
			set_deferred("visible", not _value)

func button_pressed(_id:String) -> void:
	var signal_sent:bool = false
	match _id.to_lower():
		"play":
			ButtonPressed.emit(_id.to_lower())
			signal_sent = true
		"start":
			ButtonPressed.emit(_id.to_lower())
			signal_sent = true
		"continue":
			ButtonPressed.emit(_id.to_lower())
			signal_sent = true
		"options":
			UI.ToggleUi.emit(_id.to_lower(), true, id)
			signal_sent = true
		"settings":
			UI.ToggleUi.emit(_id.to_lower(), true, id)
			signal_sent = true
		"credits":
			UI.ToggleUi.emit(_id.to_lower(), true, id)
			signal_sent = true
		"quit":
			ButtonPressed.emit(_id.to_lower())
			signal_sent = true
		_:
			push_warning("Button name unrecognized. Suggest using 'Play', 'Start', 'Continue', 'Options', 'Settings', 'Credits', or 'Quit'")

	#if signal_sent:
		#_toggle_control(id, false)
