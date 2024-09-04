class_name OptionsMenu extends SMenuControl

signal OptionsUpdated(master:float, music:float, sfx:float, window_mode:WindowOption, window_size:Vector2i)

enum WindowOption {
					FULLSCREEN = 0,
					WINDOWED = 1,
					BORDERLESS = 2,
					EXCLUSIVE_FULLSCREEN = 3,
				}

const SLIDER_OPTION = preload("res://addons/PackedUi/UI/slider_option.tscn")
const DROP_DOWN_OPTION = preload("res://addons/PackedUi/UI/drop_down_option.tscn")

## Name displayed at the top of the menu on runtime.
@export var menu_name:String
## If TRUE, a confirmation POPUP is displayed when exiting the options menu to confirm setting changes. If POPUP is confirmed, a signal OptionsUpdated with all savable options. If the POPUP is not confirmed, options are returned to default.
@export var confirm_on_exit:bool = false

@export_group("Audio Settings")
## Name displayed in the section label.
@export var audio_section_name:String = "Audio"
## If TRUE, Audio options will be displayed in the options menu.
@export var display_audio_options:bool = true
## Bus names for audio. Since this plugin is intended to be used with the Simple Audio Manager, defaults are Master, Music and SFX.
@export var bus_names:Array[String] = ["Master", 
										"Music", 
										"SFX",
										]
## If TRUE, sound options will attempt to connect with the Simple Audio Manager.
@export var use_simple_audio_manager:bool = true
## If use_simple_audio_manager is false, default value of each audio slider are set with this value. Clamped between 0.0 and 1.0.
@export var default_audio_slider_value:float = 1.0:
	get:
		return clampf(default_audio_slider_value, 0.0, 1.0)

@export_group("Display Settings")
## If TRUE, Window Setting options will be displayed in the options menu.
@export var display_display_options:bool = true
## Name displayed in the section label.
@export var display_section_name:String = "Display"
## Standard list of window options: Fullscreen, Windowed and Windowed Borderless.
@export var window_options:Array[String] = ["Fullscreen", 
											"Windowed", 
											"Borderless",
											]
## List of screen resolutions. All resolutions will be displayed in the list, but unavaible options based on screen resultion will be disabled in the drop down.
@export var window_sizes:Array[Vector2i] = [Vector2i(3840, 2160), 
											Vector2i(2560, 1440), 
											Vector2i(1920, 1080), 
											Vector2i(1366, 768), 
											Vector2i(1280, 720), 
											Vector2i(1920, 1200), 
											Vector2i(1680, 1050), 
											Vector2i(1440, 900), 
											Vector2i(1280, 800), 
											Vector2i(1024, 768), 
											Vector2i(800, 600), 
											Vector2i(640, 480), 
											]

@export_group("Language Settings")
## If TRUE, Window Setting options will be displayed in the options menu.
@export var display_language_options:bool = true
## Name displayed in the section label.
@export var language_section_name:String = "Language"

@onready var option_back_btn: Button = %option_back_btn
@onready var options_page_title: RichTextLabel = %options_page_title
@onready var tab_container: TabContainer = %TabContainer
@onready var basics_vbox: VBoxContainer = %basics_vbox

var starting_window_option:WindowOption
var current_window_option:WindowOption
var starting_window_size:Vector2i
var current_window_size:Vector2i
var window_options_drop_down:DropDownOption
var size_options_drop_down:DropDownOption
var language_options:DropDownOption
var loaded_locales:PackedStringArray

var changes_made:bool = false

# TODO: Uppdate to use popups to confirm selection on exit

func _ready() -> void:
	super()
	UI.OptionUpdated.connect(_update_window_size_option)
	UI.OptionUpdated.connect(_update_window_option)
	UI.OptionUpdated.connect(_update_game_language)
	option_back_btn.pressed.connect(_back_pressed)
	option_back_btn.position = (Vector2(UI.width, UI.height)*0.95) - option_back_btn.size
	tab_container.get_tab_bar().set_tab_title(0,"Basic")
	starting_window_option = _get_window_option()
	starting_window_size = DisplayServer.window_get_size()
	
	if menu_name:
		options_page_title.text = "[center]"+menu_name+"[/center]"

	if display_audio_options:
		_build_sound_options(audio_section_name, bus_names)

	if display_display_options:
		_build_display_options(display_section_name, window_options, window_sizes)
	
	if display_language_options:
		loaded_locales = TranslationServer.get_loaded_locales()
		print(loaded_locales)
		language_options = _build_language_options(language_section_name, loaded_locales)
	
	if tab_container.get_tab_count() <= 1:
		tab_container.tabs_visible = false

func _back_pressed() -> void:
	_toggle_control(id, false)
	UI.ToggleUi.emit("main_menu", true)

func _toggle_control(_id:String, _value:bool) -> void:
	if id == "":
		push_error(name, " does not have an id set.")
	else:
		if _id == id:
			set_deferred("visible", _value)
			if _value:
				option_back_btn.grab_focus()

func _build_sound_options(_name:String, _buses:Array[String]) -> void:
	var title = _add_section_title(_name)
	basics_vbox.add_child(title)
	for each in _buses:
		var slider = SLIDER_OPTION.instantiate() as SliderOption
		basics_vbox.add_child(slider)
		slider.set_slider(each, use_simple_audio_manager, default_audio_slider_value)

func _build_display_options(_name:String, _window:Array[String], _sizes:Array[Vector2i]) -> void:
	var title = _add_section_title(_name)
	basics_vbox.add_child(title)
	window_options_drop_down = DROP_DOWN_OPTION.instantiate() as DropDownOption
	basics_vbox.name = "display_options"
	basics_vbox.add_child(window_options_drop_down)
	window_options_drop_down.set_options("display_options", _name, _window)
	window_options_drop_down.select_starting_value(starting_window_option)
	var sizes_string:Array[String] = []
	for vector in _sizes:
		var new_string:String = str(vector.x) + " x " + str(vector.y)
		sizes_string.append(new_string)
	size_options_drop_down = DROP_DOWN_OPTION.instantiate() as DropDownOption
	size_options_drop_down.name = "window_size_options"
	basics_vbox.add_child(size_options_drop_down)
	size_options_drop_down.set_options("window_size_options", "Window Size", sizes_string, window_sizes)
	size_options_drop_down.select_starting_value(window_sizes.find(starting_window_size))


func _add_section_title(_text:String) -> Label:
	var title = Label.new()
	title.name = "label_"+_text
	title.text = tr(_text)
	title.custom_minimum_size = Vector2(basics_vbox.size.x, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.theme = UI.default_theme
	title.theme_type_variation = "OptionsSectionLabel"
	return title

func _get_window_option() -> WindowOption:
	var option:WindowOption
	var mode = DisplayServer.window_get_mode()
	var borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	
	match mode:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			option = WindowOption.FULLSCREEN
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			option = WindowOption.EXCLUSIVE_FULLSCREEN
		_:
			if borderless:
				option = WindowOption.BORDERLESS
			else:
				option = WindowOption.WINDOWED
	
	return option

# TODO: Uppdate to use popups to confirm selection
func _update_window_option(_id:String, _value:WindowOption) -> void:
	if _id == "display_options":
		print("window size value: ", _value)
		match _value as WindowOption:
			WindowOption.FULLSCREEN:
				_update_window_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			WindowOption.EXCLUSIVE_FULLSCREEN:
				_update_window_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			WindowOption.BORDERLESS:
				_update_window_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				_update_window_borderless(true)
			WindowOption.WINDOWED:
				_update_window_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				_update_window_borderless(false)
		current_window_option = _value

func _update_window_size_option(_id:String, _value:int) -> void:
	if _id == "window_size_options" and _value:
		DisplayServer.window_set_size(window_sizes[_value])
		current_window_size = window_sizes[_value]

func _update_window_mode(_mode := DisplayServer.WINDOW_MODE_FULLSCREEN):
	#Debug.log("Attempting to set window mode as ", _value)
	DisplayServer.window_set_mode(_mode)

func _update_window_borderless(_value := false):
	#Debug.log("Attempting to set bordeless to ", _value)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, _value)

func _build_language_options(_name:String, _languages:PackedStringArray) -> DropDownOption:
	if _languages.is_empty():
		push_warning("No localization detected. Language section was not added to the settings.")
		return null
		
	var title:Label = _add_section_title(_name)
	title.name = "label_"+_name
	basics_vbox.add_child(title)
	var dropdown:DropDownOption = DROP_DOWN_OPTION.instantiate() as DropDownOption
	basics_vbox.add_child(dropdown)
	dropdown.set_options("language_option", _name, _languages,)
	dropdown.select_starting_value(_get_starting_language_id())
	return dropdown

func _update_game_language(_id:String, _value:int) -> void:
	if _id == "language_option":
		TranslationServer.set_locale(loaded_locales[_value])

func _get_starting_language_id() -> int:
	var locale:String = TranslationServer.get_locale() 
	if TranslationServer.get_locale() not in loaded_locales:
		if locale.length() > 2:
			locale = locale.split("_")[0]
	print(locale)
	return loaded_locales.find(locale)
