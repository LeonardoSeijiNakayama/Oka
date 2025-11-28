extends NodeState

@export var character_body_2d : CharacterBody2D
@export var sprite_2d : AnimatedSprite2D
@export var slow_down_speed : float = 100
@export var muzzle : Marker2D
@export var node_finite_state_machine : NodeFiniteStateMachine


@onready var ShotScene = preload("res://shot.tscn")


func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed * delta)


func enter():
	sprite_2d.play("attack")
	# Conecta o sinal apenas uma vez
	if not sprite_2d.is_connected("animation_finished", Callable(self, "_on_attack_finished")):
		sprite_2d.connect("animation_finished", Callable(self, "_on_attack_finished"))

func exit():
	pass

func shoot():
	var shot = ShotScene.instantiate() as Node2D
	get_parent().add_child(shot, false, Node.INTERNAL_MODE_DISABLED)
	print(muzzle.global_position)
	shot.global_position = muzzle.global_position
	shot.direction = sign(muzzle.position).x
	get_parent().add_child(shot)

func _on_attack_finished():
	if sprite_2d.animation == "attack":
		shoot()  # Só atira se terminou a animação de ataque
		node_finite_state_machine.transition_to("idle")
		
