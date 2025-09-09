extends Sprite2D

var clickable = false;



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (clickable):
		if (event is InputEventMouseButton && event.pressed):
			if (event.button_index == MOUSE_BUTTON_LEFT):
				self.get_parent().get_parent()._square_clicked(self.name)
