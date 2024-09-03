class_name Credits extends SMenuControl

const CREDITS_SECTION = preload("res://addons/PackedUi/UI/credits_section.tscn")

## Array of sections to be displayed in the credits.
@export var credit_sections:Array[CreditSectionData]
## Delay before the auto-scrolling of the credits begin.
@export var scroll_delay:float = 2
## Speed at which the credits auto-scroll.
@export var scroll_speed:float = 10

@onready var credits_scroll: ScrollContainer = %credits_scroll
@onready var game_name_in_credits: RichTextLabel = %game_name_in_credits
@onready var credits_vbox: VBoxContainer = %credits_vbox
@onready var back_btn: Button = %back_btn

var scroll_timer:float = 0.0:
	set(_value):
		scroll_timer = _value
		if scroll_timer >= scroll_delay:
			scroll_timer = 0.0
			scrolling = true
			scroll_wait = false
var scroll_wait:bool = false
var scrolling:bool = false

func _ready() -> void:
	super()
	credits_scroll.scroll_ended.connect(_scroll_ended)
	if credit_sections.is_empty():
		push_warning("Credits Ui does not have any Credit Section Data to display.")
	game_name_in_credits.text = "[center]"+UI.game_name+"[/center]"
	_create_credits(credit_sections)
	back_btn.position = (Vector2(UI.width, UI.height) * 0.95) - back_btn.size
	back_btn.pressed.connect(_back_btn_pressed)

func _physics_process(delta: float) -> void:
	if scroll_wait:
		scroll_timer += delta
	if scrolling:
		credits_scroll.scroll_vertical += scroll_speed * delta

func _create_credits(_list:Array[CreditSectionData]) -> void:
	for section in _list:
		var new_section = CREDITS_SECTION.instantiate() as CreditsSection
		credits_vbox.add_child.call_deferred(new_section)
		await new_section.ready
		new_section.set_section(section)

func _back_btn_pressed() -> void:
	UI.ToggleUi.emit("main_menu", true)
	_toggle_control(id, false)

func _toggle_control(_id:String, _value:bool) -> void:
	if id == "":
		push_error(name, " does not have an id set.")
	else:
		if _id == id:
			set_deferred("visible", _value)
			if not _value:
				scroll_wait = false
				scrolling = false
				credits_scroll.scroll_vertical = 0
			else:
				back_btn.grab_focus()
				scroll_wait = true

func _scroll_ended() -> void:
	scrolling = false
