extends Label

@export var state_machine : CharacterStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "AnimationState: " + state_machine.current_state.name
