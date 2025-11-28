extends NodeState

@export var character_body_2d : CharacterBody2D
@export var sprite_2d : AnimatedSprite2D

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	pass

func enter():
	sprite_2d.play("idle")


func exit():
	pass
