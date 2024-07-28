extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

var is_slashing = false
var slash_held = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_slashing:
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Handle slash attack.
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_on_floor() and not is_slashing and not slash_held:
		anim.play("Slash")
		is_slashing = true
		slash_held = true
		return # Skip the rest of the movement code while slashing

	# Reset slash_held when the left mouse button is released
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		slash_held = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		sprite.flip_h = true
	elif direction == 1:
		sprite.flip_h = false

	# Handle movement and animation only if not slashing
	if not is_slashing:
		if direction != 0:
			velocity.x = direction * SPEED
			if is_on_floor():
				anim.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				anim.play("Idle")

		if not is_on_floor():
			anim.play("Fall")
	
	move_and_slide()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Slash":
		is_slashing = false
		# Ensure the correct animation is played after slashing
		update_animation_state()

func update_animation_state():
	if is_slashing:
		return

	if not is_on_floor():
		anim.play("Fall")
	elif velocity.x == 0:
		anim.play("Idle")
	else:
		anim.play("Run")
