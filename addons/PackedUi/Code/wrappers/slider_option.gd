class_name SliderOption extends OptionsOption

@onready var name_label: Label = %name_label
@onready var slider: HSlider = %slider

var dragging:bool = false
var dragging_timer:float = 0.0:
	set(_value):
		dragging_timer = _value
		if dragging_timer >= dragging_delay:
			dragging_timer = 0.0
			_update_value()
var dragging_delay:float = 0.2

func _ready() -> void:
	slider.drag_ended.connect(_drag_ended)
	slider.drag_started.connect(_start_dragging)

func _physics_process(delta: float) -> void:
	if dragging:
		dragging_timer += delta

func _update_value() -> void:
	UI.OptionUpdated.emit(id, slider.value)
	print("UI.OptionUpdated.emit(id, slider.value)")

func _drag_ended(_value_changed:bool) -> void:
	if _value_changed:
		UI.OptionUpdated.emit(id, slider.value)
		print("UI.OptionUpdated.emit(id, slider.value)")
	if dragging:
		dragging = false

func _start_dragging(): 
	dragging = true

func set_slider(_name:String, _using_sam:bool, _slider_value:float = 1.0) -> float:
	name = "bus_slider_"+_name
	id = _name
	name_label.text = _name
	if _using_sam:
		var audio = get_tree().get_first_node_in_group("SimpleAudioManager")
		if audio != null:
			match _name:
				"Master":
					slider.value = audio.DEFAULT.master_volume
				"Music":
					slider.value = audio.DEFAULT.music_volume
				"SFX":
					slider.value = audio.DEFAULT.sfx_volume
				_:
					pass
		else:
			push_error("Simple Audio Manager not found. Default audio values not set. Make sure to have latest version of Simple Audio Manager installed.")
	else:
		slider.value = _slider_value

	return slider.value

func set_slider_value(_id:String, _value:float) -> void:
	if _id == id:
		slider.value = clampf(_value, 0.0, 1.0)