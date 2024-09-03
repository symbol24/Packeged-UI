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
		var max_height:float = 0.0
		var x:int = 0
		for logo in _section_data.logo_images:
			if logo is Texture2D:
				var sprite:Sprite2D = Sprite2D.new()
				sprite.name = "sprite_" + str(x)
				sprite.texture = logo
				var control:Control = Control.new()
				control.name = "control_" + str(x)
				control.custom_minimum_size = Vector2((UI.width-400)/grid_of_logos.columns, 100)
				if logo.get_width() > control.custom_minimum_size.x:
					var ratio:float = control.custom_minimum_size.x / logo.get_width()
					sprite.scale = Vector2(ratio, ratio)
				sprite.position = control.custom_minimum_size/2
				control.add_child(sprite)
				grid_of_logos.add_child(control)
				if logo.get_height() > max_height:
					max_height = logo.get_height()
				x += 1
		for each:Control in grid_of_logos.get_children():
			each.custom_minimum_size.y = max_height
	else:
		grid_of_logos.hide()
	if not _section_data.list_of_names.is_empty():
		if _section_data.list_of_names.size() < 5:
			grid_of_names.columns = _section_data.list_of_names.size()
		else:
			grid_of_names.columns = 5
		for _name in _section_data.list_of_names:
			var new_label = Label.new()
			new_label.custom_minimum_size = Vector2((UI.width-400)/grid_of_names.columns, 40)
			new_label.text = _name
			new_label.theme = UI.default_theme
			new_label.theme_type_variation = "CreditsLabel"
			new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			grid_of_names.add_child(new_label)
	else:
		grid_of_names.hide()
				
