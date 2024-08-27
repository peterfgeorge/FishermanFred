extends State

class_name AirState

@export var ground_state : State
@export var fall_animation : String = "Fall"

func state_process(delta):
	if(character.is_on_floor()):
		next_state = ground_state
		
func _physics_process(delta):
	if (character.velocity.y > 0 && !character.is_on_floor()):
		playback.travel(fall_animation)
