extends Area2D

## Powerup types: "double_jump", "dash"
@export var powerup_type: String = "double_jump"

var collected := false

@onready var visual: Polygon2D = $Visual
@onready var label: Label = $Label
@onready var anim_timer := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_setup_appearance()


func _process(delta: float) -> void:
	if not collected:
		# Gentle bob animation
		anim_timer += delta * 2.5
		visual.position.y = sin(anim_timer) * 6.0
		label.position.y = visual.position.y - 36.0
		# Slow spin color pulse
		var pulse := (sin(anim_timer * 1.2) + 1.0) * 0.5
		if powerup_type == "double_jump":
			visual.color = Color(0.9, 0.7 + pulse * 0.3, 0.1)
		else:
			visual.color = Color(0.8, 0.1, 0.9 + pulse * 0.1)


func _setup_appearance() -> void:
	match powerup_type:
		"double_jump":
			visual.color = Color(1.0, 0.8, 0.1)
			label.text = "DOUBLE JUMP"
		"dash":
			visual.color = Color(0.85, 0.1, 1.0)
			label.text = "DASH"


func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if body.has_method("collect_powerup"):
		collected = true
		body.collect_powerup(powerup_type)
		# Flash and disappear
		var tween := create_tween()
		tween.tween_property(self, "scale", Vector2(2.0, 2.0), 0.15)
		tween.tween_property(self, "modulate:a", 0.0, 0.2)
		tween.tween_callback(queue_free)
