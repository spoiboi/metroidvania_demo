@tool
extends StaticBody2D

## Size of this platform in pixels (width, height).
## Change this in the Inspector to resize the platform live in the editor.
@export var size: Vector2 = Vector2(120, 20):
	set(v):
		size = v
		if is_node_ready():
			_update()

## Fill colour of the platform.
@export var color: Color = Color(0.3, 0.55, 0.3, 1):
	set(v):
		color = v
		if is_node_ready():
			_update()


func _ready() -> void:
	_update()


func _update() -> void:
	var col: CollisionShape2D = $CollisionShape2D
	var vis: Polygon2D = $Visual
	if col == null or vis == null:
		return
	var rect := RectangleShape2D.new()
	rect.size = size
	col.shape = rect
	var hw := size.x * 0.5
	var hh := size.y * 0.5
	vis.polygon = PackedVector2Array([
		Vector2(-hw, -hh), Vector2(hw, -hh),
		Vector2(hw,   hh), Vector2(-hw,  hh),
	])
	vis.color = color
