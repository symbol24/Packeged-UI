class_name Popups extends Control

enum Severity {
				NORMAL = 0,
				WARNING = 1,
				ERROR = 2,
			}
			
const WARNING = preload("res://addons/PackedUi/popup_icon_warning.png")
const ERROR = preload("res://addons/PackedUi/popup_icon_error.png")

@export_group("Small Popup")
## Time the small popup remains displayed; not including fade in and out.
@export var popup_timer: float = 3
## Time the tweens of the SMALL popup takes to fade in and out when appearing and disappearing. If set to 0.0, fade is ignored.
@export var small_popup_fade_time: float = 0.5

@export_group("Large Popup")
## Time the tweens of the LARGE popup takes to fade in and out when appearing and disappearing. If set to 0.0, fade is ignored.
@export var large_popup_fade_time: float = 0.3

# Small popup onready
@onready var small_popup: PanelContainer = %small_popup
@onready var icon_control: Control = %icon_control
@onready var icon_sprite: Sprite2D = %icon_sprite
@onready var small_popup_text: RichTextLabel = %small_popup_text

# Large popup onready
@onready var large_popup: Control = %large_popup
@onready var icon_container_large: Control = %icon_container_large
@onready var large_icon: Sprite2D = %large_icon
@onready var spacer_l_popup: Control = %spacer_l_popup
@onready var large_title: RichTextLabel = %large_title
@onready var large_text: RichTextLabel = %large_text
@onready var cancel_btn: Button = %cancel_btn
@onready var confirm_btn: Button = %confirm_btn
@onready var timer_label: Label = %timer_label
@onready var timer_spacer: Control = %timer_spacer

# Small popup parameters
var small_displayed:bool = false
var small_timer:float = 0.0:
	set(_value):
		small_timer = _value
		if small_timer >= popup_timer:
			small_timer = 0.0
			_hide_small_popup()

# Large popup parameters
var large_popup_id: String = ""
var large_popup_timed: bool = false
var large_display_timer: int = 15:
	set(_value):
		large_display_timer = _value
		timer_label.text = str(large_display_timer)
		if large_display_timer <= 0:
			_end_large_popup_timed()
var large_timer: float = 0.0:
	set(_value):
		large_timer = _value
		if large_timer >= 1.0:
			large_timer = 0.0
			large_display_timer -= 1


func _ready() -> void:
	hide()
	UI.PopupSmall.connect(_display_small_popup)
	UI.PopupLarge.connect(_display_big_popup)
	cancel_btn.pressed.connect(_cancel_btn_pressed)
	confirm_btn.pressed.connect(_confirm_btn_pressed)
	small_popup.set_deferred("modulate", Color.TRANSPARENT)
	small_popup.hide()
	large_popup.set_deferred("modulate", Color.TRANSPARENT)
	large_popup.hide()


# Process is used for timers.
func _process(delta: float) -> void:
	if small_displayed:
		small_timer += delta
	
	if large_popup_timed:
		large_timer += delta


# Small popups only receive a text to display and an icon/image. The image is automatically resized to fit the popup. If no icon is received, it is not displayed.
func _display_small_popup(_text:String = "", _icon:CompressedTexture2D = null) -> void:
	if _icon:
		icon_sprite.texture = _icon
		icon_control.show()
		var control_size:Vector2 = icon_control.size
		var image_x:float = _icon.get_width()
		if image_x > control_size.x:
			var ratio = control_size.x / image_x
			icon_sprite.scale = Vector2(ratio, ratio)
		else:
			icon_sprite.scale = Vector2(1, 1)
	else:
		icon_control.hide()

	small_popup_text.text = _text
	show()
	small_popup.show()

	if small_popup_fade_time > 0.0:
		var tween = get_tree().create_tween()
		tween.tween_property(small_popup, "modulate", Color.WHITE, small_popup_fade_time)
		await tween.finished
	else:
		small_popup.set_deferred("modulate", Color.WHITE)

	small_displayed = true


func _hide_small_popup():
	if small_popup_fade_time > 0.0:
		var tween = get_tree().create_tween()
		tween.tween_property(small_popup, "modulate", Color.TRANSPARENT, small_popup_fade_time)
		await tween.finished
	else:
		small_popup.set_deferred("modulate", Color.TRANSPARENT)
	small_popup.hide()

	hide()

# The large popup receives a larger amounf of parameters.
# _severity indicates the severity of the popup (normal, warning, error). Normal popups do not display the icon._add_constant_central_force
# _id is used by the receiving code of the UI.PopupResult siganl to identify the popup._add_constant_central_force
# If no _icon is provided, default images are displayed for Warning and Error popups._add_constant_central_force
# if _timer is greater than 0.0, the popup has a cooldown timer that displays on screen. 
# 		Reaching 0 closes and considers the popup canceled for the UI.PopupResult signal.
func _display_big_popup(_severity:Severity, _title:String, _text:String, _id:String, _icon:Texture2D = null, _timer:int = 0) -> void:
	large_popup_id = _id
	
	match _severity:
		Severity.WARNING:
			icon_container_large.show()
			icon_sprite.show()
			if _icon == null:
				_icon = WARNING
		Severity.ERROR:
			icon_container_large.show()
			icon_sprite.show()
			if _icon == null:
				_icon = ERROR
		_:
			icon_container_large.hide()
			icon_sprite.hide()
	
	if _icon:
		print("icon_container_large.size.x / _icon.get_width(): ", icon_container_large.size.x, " / ", _icon.get_width())
		var ratio:float = icon_container_large.size.x / _icon.get_width()

		large_icon.texture = _icon
		large_icon.set_deferred("scale", Vector2(ratio, ratio))
		print("ratio: ", ratio)
	
	large_title.text = _title
	large_text.text = _text

	if _timer > 0:
		timer_label.show()
		timer_spacer.show()
	else:
		timer_label.hide()
		timer_spacer.hide()

	show()
	large_popup.show()

	if large_popup_fade_time > 0.0:
		var tween = get_tree().create_tween()
		tween.tween_property(large_popup, "modulate", Color.WHITE, large_popup_fade_time)
		await tween.finished
	
	if _timer > 0:
		large_display_timer = _timer
		large_popup_timed = true


# Large popup can receive a timed parameter. If the timer reaches 0, the popup is considered canceled, and closes.
func _end_large_popup_timed() -> void:
	large_popup_timed = false
	UI.PopupResult.emit(large_popup_id, false)
	_close_large_popup()


func _close_large_popup() -> void:
	if large_popup_fade_time > 0.0:
		var tween = get_tree().create_tween()
		tween.tween_property(large_popup, "modulate", Color.TRANSPARENT, large_popup_fade_time)
		await tween.finished
	large_popup.hide()
	hide()


# Confirm and Cancel buttons are handled in the popups script.
func _cancel_btn_pressed() -> void:
	if large_popup_timed:
		large_popup_timed = false

	UI.PopupResult.emit(large_popup_id, false)
	_close_large_popup()


func _confirm_btn_pressed() -> void:
	if large_popup_timed:
		large_popup_timed = false

	UI.PopupResult.emit(large_popup_id, true)
	_close_large_popup()


# Example uses of the small and large popup signals.
func _test_small_popup() -> void:
	UI.PopupSmall.emit("This is a small popup test.")


func _test_large_popup() -> void:
	UI.PopupLarge.emit(Severity.ERROR, "WARNING!", "Paging Doctor Biggs! hellow good sir!", "warning", null, 15)
