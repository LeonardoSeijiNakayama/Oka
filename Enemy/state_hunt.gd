extends NodeState

@export var character_body_2d: CharacterBody2D
@export var sprite_2d: AnimatedSprite2D
@export var speed: float = 120.0
@export var jump_force: float = -750.0
@export var ray_front: RayCast2D
@export var marker: Marker2D

var player: CharacterBody2D

func on_physics_process(_delta: float) -> void:
	var diff := player.global_position - character_body_2d.global_position
	var direction = sign(diff.x)
	sprite_2d.flip_h = !(direction > 0)
	ray_front.scale.x = direction
	if direction < 0:
		if marker.position.x > 0:
			marker.position.x *= -1;
	elif direction > 0:
		if marker.position.x < 0:
			marker.position.x *= -1;
	character_body_2d.velocity.x = direction * speed

	var hit := ray_front.get_collider()
	if hit != null and hit.is_in_group("Obstacle") and character_body_2d.is_on_floor():
		print("pulo")
		character_body_2d.velocity.y = jump_force



func enter() -> void:
	sprite_2d.play("run")
	var players := get_tree().get_nodes_in_group("Player")
	print(players[0])
	if players.size() > 0:
		player = players[0] as CharacterBody2D


func exit() -> void:
	pass
