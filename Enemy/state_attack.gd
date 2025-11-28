extends NodeState

@export var character_body_2d : CharacterBody2D
@export var sprite_2d : AnimatedSprite2D
@export var slow_down_speed : float = 100
@export var muzzle : Marker2D

@onready var ShotScene = preload("res://shot.tscn")


func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed * delta)

func enter():
	sprite_2d.play("attack")
	shoot(sign(character_body_2d.global_position.x))


func exit():
	pass

func shoot(direction : int):
	var shot = ShotScene.instantiate() as Node2D
	get_parent().add_child(shot, false, Node.INTERNAL_MODE_DISABLED)
	print(muzzle.global_position)
	shot.global_position = muzzle.global_position
	shot.direction = direction 
	get_parent().add_child(shot)
