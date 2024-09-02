class_name CreditsSection extends VBoxContainer

@onready var section_name: RichTextLabel = %section_name
@onready var grid_of_names: GridContainer = %grid_of_names
@onready var grid_of_logos: GridContainer = %grid_of_logos

func set_section(_section_data:CreditSectionData) -> void:
	section_name.text = "[center]"+_section_data.section_name+"[/center]"
	if not _section_data.logo_images.is_empty():
		if _section_data.logo_images.size() < 3:
			grid_of_logos.columns = _section_data.logo_images.size()
		else:
			grid_of_logos.columns = 3
		for logo in _section_data.logo_images:
			if logo is Texture:
				var new_control = Control.new()
				var new_sprite = Sprite2D.new()
				new_sprite.texture = logo
				new_sprite.centered = false
				new_control.size = Vector2(50,50)
				new_control.add_child(new_sprite)
				grid_of_logos.add_child.call_deferred(new_control)
	else:
		grid_of_logos.hide()
	if not _section_data.list_of_names.is_empty():
		if _section_data.list_of_names.size() < 5:
			grid_of_names.columns = _section_data.list_of_names.size()
		else:
			grid_of_names.columns = 5
		for _name in _section_data.list_of_names:
			var new_label = Label.new()
			new_label.text = _name
			new_label.theme = UI.default_theme
			new_label.theme_type_variation = "CreditsLabel"
			grid_of_names.add_child.call_deferred(new_label)
	else:
		grid_of_names.hide()
				
