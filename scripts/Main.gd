extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	player.powerup_collected.connect(hud.on_powerup_collected)
	# Set player spawn position
	player.position = Vector2(80, 520)
