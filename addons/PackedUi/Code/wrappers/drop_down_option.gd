class_name DropDownOption extends OptionsOption

@onready var name_label: Label = %name_label
@onready var options: OptionButton = %options

func _ready() -> void:
	options.item_selected.connect(_option_changed)

func _option_changed(new_option_id:int) -> void:
	UI.OptionUpdated.emit(id, new_option_id)

func set_options(_id:String, _label_text:String, _options:Array[String], _vectors:Array[Vector2i] = []) -> void:
	if _id:
		id = _id
	if _label_text: 
		name_label.text = tr(_label_text)
	for option in _options:
		options.add_item(option)
	
	if not _vectors.is_empty():
		var resolution = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
		var i:int = 0
		for each in _vectors:
			if each > resolution:
				options.set_item_disabled(i, true)
			i += 1

func set_options_with_ids(_id:String, _label_text:String, _options:Array[String], _ids:Array[int]) -> void:
	if _id:
		id = _id
	if _label_text: 
		name_label.text = tr(_label_text)
	var i:int = 0
	for option in _options:
		options.add_item(option, i)
		i += 1

func select_value(_value:int) -> void:
	options.select(_value)
