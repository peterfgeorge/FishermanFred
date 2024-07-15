extends AnimatedSprite2D

# Boolean to check if line is already casted
var line_casted = false


# Called when the node enters the scene tree for the first time.
func _ready():
	stop() # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_select") and not line_casted:
		play_casting_animation()

func play_casting_animation():
	line_casted = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
