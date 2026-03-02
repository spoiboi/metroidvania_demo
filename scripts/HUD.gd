extends CanvasLayer

@onready var controls_label: Label = $ControlsLabel
@onready var powers_label: Label = $PowersLabel


func _ready() -> void:
	controls_label.text = (
		"Move: A / D  |  Jump: Space / W  |  Dash (after upgrade): Shift"
	)
	powers_label.text = "Powers: none"


func on_powerup_collected(powerup_name: String) -> void:
	var current := powers_label.text.replace("Powers: none", "Powers:")
	if not current.contains(powerup_name):
		if current == "Powers:":
			current += "  " + _friendly(powerup_name)
		else:
			current += "   |   " + _friendly(powerup_name)
	powers_label.text = current

	# Flash the powers label briefly
	var tween := create_tween()
	tween.tween_property(powers_label, "modulate", Color(1, 1, 0.2), 0.1)
	tween.tween_property(powers_label, "modulate", Color(1, 1, 1), 0.4)


func _friendly(type: String) -> String:
	match type:
		"double_jump": return "Double Jump"
		"dash":        return "Dash"
	return type.capitalize()
