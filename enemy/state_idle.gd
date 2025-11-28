extends NodeState

@export var character_body_2d : CharacterBody2D
@export var sprite_2d : AnimatedSprite2D
@export var node_finite_state_machine : NodeFiniteStateMachine
@export var enemy_wait_time : int = 2.0

var timer = 0.0


func on_process(delta : float):
	if timer >= 0.0:
		timer -= delta
	else:
		node_finite_state_machine.transition_to("attack")
	pass
	
#func on_physics_process(delta : float):
	#pass

func enter():
	sprite_2d.play("idle")
	timer = enemy_wait_time
	


func exit():
	pass
