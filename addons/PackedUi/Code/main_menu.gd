@tool
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

var button_list:Array[SButton] = []

func _ready() -> void:
	super()
	_set_game_title(game_title)
	game_title_label.custom_minimum_size.y = UI.height/3
	menu_button_vbox.custom_minimum_size.x = UI.width/3
	hbox_seperator_01.custom_minimum_size.x = UI.width/3
	hbox_seperator_02.custom_minimum_size.x = UI.width/3
	_make_buttons(menu_options)
	if not button_list.is_empty() and not button_list[-1].is_node_ready():
		await button_list[-1].ready
	if not button_list.is_empty():
		button_list[0].grab_focus()

func _set_game_title(_value:String = "") -> void:
	game_title_label.text = "[center]"+_value+"[/center]"
	UI.game_name = _value

func _make_buttons(_list:Array[String]) -> Array[SButton]:
	var buttons:Array[SButton] = []
	var previous:SButton
	if _list.is_empty():
		push_error("Main menu options list is empty.")
		return buttons
		
	var x:int = 0
	for each in _list:
		var new_button = SButton.new()
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
		x += 1
	return buttons
