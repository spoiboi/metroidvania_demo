extends CharacterBody2D

signal powerup_collected(powerup_name: String)

const SPEED := 220.0
const JUMP_VELOCITY := -500.0
const GRAVITY := 1300.0
const DASH_SPEED := 600.0
const DASH_DURATION := 0.18
const DASH_COOLDOWN := 0.7
const COYOTE_TIME := 0.1

var has_double_jump := false
var has_dash := false

var jump_count := 0
var is_dashing := false
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var dash_direction := 1.0
var coyote_timer := 0.0
var was_on_floor := false

@onready var body_polygon: Polygon2D = $BodyPolygon
@onready var dash_indicator: Polygon2D = $DashIndicator


func _physics_process(delta: float) -> void:
	var on_floor := is_on_floor()

	# Coyote time: allow jumping briefly after walking off a ledge
	if was_on_floor and not on_floor:
		coyote_timer = COYOTE_TIME
	elif on_floor:
		coyote_timer = 0.0
		jump_count = 0
	else:
		coyote_timer -= delta

	was_on_floor = on_floor

	# Dash cooldown countdown
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	# While dashing: override all other movement
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0.0
		if dash_timer <= 0.0:
			is_dashing = false
		move_and_slide()
		return

	# Gravity
	if not on_floor:
		velocity.y += GRAVITY * delta
		velocity.y = min(velocity.y, 900.0)

	# Dash input
	if has_dash and Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0.0:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		velocity.y = 0.0

	# Jump input
	if Input.is_action_just_pressed("jump"):
		if on_floor or coyote_timer > 0.0:
			velocity.y = JUMP_VELOCITY
			jump_count = 1
			coyote_timer = 0.0
		elif has_double_jump and jump_count < 2:
			velocity.y = JUMP_VELOCITY * 0.9
			jump_count = 2

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = direction * SPEED
		dash_direction = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * 10.0 * delta)

	move_and_slide()


func collect_powerup(type: String) -> void:
	match type:
		"double_jump":
			has_double_jump = true
			# Turn body green to show upgrade
			body_polygon.color = Color(0.2, 0.85, 0.4)
		"dash":
			has_dash = true
			# Show dash indicator dot
			dash_indicator.visible = true
	powerup_collected.emit(type)
