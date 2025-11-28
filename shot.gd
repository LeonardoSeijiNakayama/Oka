extends AnimatedSprite2D

var speed : int = 2000
var direction : int 

func _physics_process(delta: float) -> void:
	move_local_x(direction * speed * delta)


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
