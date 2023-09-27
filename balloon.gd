extends CharacterBody2D

@onready var _debugger_gravity_label : Label = $DebugLayer/DebugPanel/MarginContainer/VBoxContainer/Gravity/Value
@onready var _debugger_velocity_label : Label = $DebugLayer/DebugPanel/MarginContainer/VBoxContainer/Velocity/Value
@onready var _debugger_onfloor_label : Label = $DebugLayer/DebugPanel/MarginContainer/VBoxContainer/OnFloor/Value
@onready var _debugger_update_timer : float = 0.0

#@export var SPEED : float = 400.0
@export var JUMP_VELOCITY : float = -100.0
@export var MAX_VELOCITY : float = 25.0
@export var GRAVITY : float = 50.0
@export var BOUNCE_DECAY : float = 0.8

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		_debugger_onfloor_label.text = "False"
		velocity.y += GRAVITY * delta
	else:
		_debugger_onfloor_label.text = "True"


	# use direction_to() for player hits
	
	
#	velocity = velocity.limit_length(MAX_VELOCITY)
	
	# Jump action for debugging physics
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY

	_debugger_update_timer += delta
	if _debugger_update_timer > 0.5:
		_debugger_velocity_label.text = str(velocity)
		_debugger_gravity_label.text = str(GRAVITY)
		_debugger_update_timer = 0
	
	var collision = move_and_collide(velocity * delta)
	if not collision: return
	velocity = velocity.bounce(collision.get_normal()) * BOUNCE_DECAY
	
#	var mag = velocity.length()
#	var collision = move_and_collide(velocity * delta, false, 0.08, true)
#	if collision:
#		print("velocity: ", str(velocity))
#		velocity = velocity.bounce(collision.get_normal())
#		print("bounce: ", str(velocity))
		

	
