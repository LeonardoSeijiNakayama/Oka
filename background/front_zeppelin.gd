extends ParallaxLayer

@export var ZEPPELIN_SPEED : float = -60

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.motion_offset.x += ZEPPELIN_SPEED * delta
