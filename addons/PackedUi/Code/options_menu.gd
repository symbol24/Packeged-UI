class_name OptionsMenu extends SMenuControl

const SLIDER_OPTION = preload("res://addons/PackedUi/UI/slider_option.tscn")

## Name displayed on runtime.
@export var page_name:String
## Bus names for audio. Since this plugin is intended to be used with teh Simple Audio Manager, defaults are Master, Music and SFX.
@export var bus_names:Array[String] = ["Master", "Music", "SFX"]
## If TRUE, sound options will attempt to connect with the Aimple Audio Manager autoload.
@export var use_simple_audio_manager:bool = true
## If use_simple_audio_manager is false, default value of each audio slider are set with this value. Clamped between 0.0 and 1.0.
@export var default_audio_slider_value:float = 1.0:
	get:
		return clampf(default_audio_slider_value, 0.0, 1.0)

@onready var option_back_btn: Button = %option_back_btn
@onready var options_page_title: RichTextLabel = %options_page_title
@onready var tab_container: TabContainer = %TabContainer
@onready var basics: Control = %basics
@onready var basics_vbox: VBoxContainer = %basics_vbox

func _ready() -> void:
	super()
	option_back_btn.pressed.connect(_back_pressed)
	option_back_btn.position = (Vector2(UI.width, UI.height)*0.95) - option_back_btn.size
	if page_name:
		options_page_title.text = "[center]"+page_name+"[/center]"
	tab_container.get_tab_bar().set_tab_title(0,"Basic")
	_build_sound_options(bus_names)

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

func _build_sound_options(_buses:Array[String]) -> void:
	var title = Label.new()
	title.text = "Audio"
	title.custom_minimum_size = Vector2(basics_vbox.size.x, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.theme = UI.default_theme
	title.theme_type_variation = "OptionsSectionLabel"
	basics_vbox.add_child(title)
	for each in _buses:
		var slider = SLIDER_OPTION.instantiate() as SliderOption
		basics_vbox.add_child(slider)
		slider.set_slider(each, use_simple_audio_manager, default_audio_slider_value)
