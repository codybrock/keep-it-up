extends CharacterBody2D

@onready var screen_size = get_viewport_rect().size

@export var speed : float = 600.0
@export var friction : float = 0.2
@export var acceleration : float = 0.25
@export var FLOOR_SNAP : float = 7.0

@export var jump_height : float = 100.0
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _debugger_gravity_label : Label = $CanvasLayer/DebugPanel/MarginContainer/VBoxContainer/Gravity/Value
@onready var _debugger_velocity_label : Label = $CanvasLayer/DebugPanel/MarginContainer/VBoxContainer/Velocity/Value
@onready var _debugger_onfloor_label : Label = $CanvasLayer/DebugPanel/MarginContainer/VBoxContainer/OnFloor/Value

@onready var _update_timer : float = 0.0


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")

	if direction != 0:
		_state_chart.send_event("move")
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		_state_chart.send_event("stop")
		velocity.x = lerp(velocity.x, 0.0, friction)
		
	_update_timer += delta
	if _update_timer > 0.5:
		_update_timer = 0
		_debugger_gravity_label.text = str(get_gravity())
		_debugger_velocity_label.text = str(velocity)
		_debugger_onfloor_label.text = str(is_on_floor())

	move_and_slide()
	
	# Add the gravity.
	if is_on_floor():
		_state_chart.send_event("grounded")
		velocity.y = 0
		if get_floor_normal() != Vector2.UP:
			floor_snap_length = FLOOR_SNAP
		else:
			floor_snap_length = 0.0
	else:
		_state_chart.send_event("airborne")


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


#func get_left_from_floor_normal(normal):
#	var theta = Vector2.UP.angle_to(normal)
#	return Vector2.LEFT.rotated(theta)


func _on_grounded_state_physics_processing(delta):
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		_state_chart.send_event("jump")

func _on_jump_state_physics_processing(delta):
	velocity.y += get_gravity() * delta
	if velocity.y >= 0:
		_state_chart.send_event("falling")
	elif Input.is_action_just_released("jump"):
		_state_chart.send_event("clipped")


func _on_clipped_jump_state_physics_processing(delta):
#	velocity.y += 2 * get_gravity() * delta
	velocity.y *= 0.5
	velocity.y += get_gravity() * delta
	if velocity.y >= 0:
		_state_chart.send_event("falling")


func _on_falling_state_physics_processing(delta):
	velocity.y += get_gravity() * delta


func _on_idle_state_entered():
	$AnimatedSprite2D.modulate = Color.WHITE


func _on_run_state_entered():
	$AnimatedSprite2D.modulate = Color.LIME_GREEN


func _on_coyote_time_state_entered():
	$AnimatedSprite2D.modulate = Color.HOT_PINK


func _on_jump_state_entered():
	$AnimatedSprite2D.modulate = Color.GOLD


func _on_falling_state_entered():
	$AnimatedSprite2D.modulate = Color.RED


func _on_clipped_jump_state_entered():
	$AnimatedSprite2D.modulate = Color.ORANGE
