extends NodeState

@export var character_body_2d: CharacterBody2D
@export var sprite_2d: Sprite2D
@export var speed: float = 120.0
@export var jump_force: float = -750.0
@export var ray_front: RayCast2D

var player: CharacterBody2D

func on_physics_process(delta: float) -> void:
	
	var diff := player.global_position - character_body_2d.global_position
	var direction = sign(diff.x)

	sprite_2d.flip_h = !(direction > 0)
	ray_front.scale.x = direction

	character_body_2d.velocity.x = direction * speed

	var hit := ray_front.get_collider()
	if hit != null and hit.is_in_group("Obstacle") and character_body_2d.is_on_floor():
		character_body_2d.velocity.y = jump_force


func enter() -> void:
	var players := get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0] as CharacterBody2D


func exit() -> void:
	pass
