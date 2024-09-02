class_name Credits extends SMenuControl

const CREDITS_SECTION = preload("res://addons/PackedUi/UI/credits_section.tscn")

@export var credit_sections:Array[CreditSectionData]

@onready var credits_scroll: ScrollContainer = %credits_scroll
@onready var game_name_in_credits: RichTextLabel = %game_name_in_credits
@onready var credits_vbox: VBoxContainer = %credits_vbox

func _ready() -> void:
	super()
	if credit_sections.is_empty():
		push_warning("Credits Ui does not have any Credit Section Data to display.")
	game_name_in_credits.text = "[center]"+UI.game_name+"[/center]"
	_create_credits(credit_sections)

func _create_credits(_list:Array[CreditSectionData]) -> void:
	for section in _list:
		var new_section = CREDITS_SECTION.instantiate() as CreditsSection
		credits_vbox.add_child.call_deferred(new_section)
		await new_section.ready
		new_section.set_section(section)
