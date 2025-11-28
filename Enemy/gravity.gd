extends Node

@export var character_body_2d : CharacterBody2D
@export var sprite_2d : Sprite2D

var GRAVITY : float = 8000.
	
func _physics_process(delta: float) -> void:
	if !character_body_2d.is_on_floor():
		print("gravidade")
		character_body_2d.velocity.y += GRAVITY * delta
	character_body_2d.move_and_slide()
