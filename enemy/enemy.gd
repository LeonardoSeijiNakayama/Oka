extends CharacterBody2D

var enemy_death_effect = preload("res://enemy/enemy_death.tscn")

@export var lifes : int = 3

func _on_hurt_box_area_entered(area: Area2D) -> void:
	lifes -= 1
	area.get_parent().queue_free()
	print('lifes = ', lifes)
	if(lifes <= 0):
		var enemy_death = enemy_death_effect.instantiate() as Node2D
		enemy_death.global_position = global_position
		get_parent().add_child(enemy_death)
		queue_free()
