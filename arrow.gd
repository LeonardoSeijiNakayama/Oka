extends CharacterBody2D

@onready var HitBox: CollisionShape2D = $CollisionShape2D
@onready var Sprite: Sprite2D = $Sprite2D

const SPEED = 1200.0
var GRAVITY = Vector2.ZERO
var hit = false
var disappearTimer = 0.0
var dir = 1
const DISAPPEAR_TIME = 1

func setDir(direction: int) -> void:
	dir = direction
	if dir == -1:
		Sprite.flip_h = true
		
	
func _ready() -> void:
	print("arrow created")
	GRAVITY.y = 700.0


func _physics_process(delta: float) -> void:
	if not is_on_floor() and !hit:
		velocity += GRAVITY * delta
		velocity.x = SPEED*dir
	if hit:
		disappearTimer -= delta
		print("contando : " + str( disappearTimer))
		if disappearTimer<=0.0:
			print("sumir")
			disappearTimer = 0.0
			get_parent().remove_child(self)
			hit = false
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var colliding_body = collision.get_collider()
		if colliding_body != null:
			print("Colidiu com: ", colliding_body.name)
			velocity.x = 0
			velocity.y = 0
			if not hit:
				print("if not hit")
				disappearTimer = DISAPPEAR_TIME
				hit = true
				HitBox.set_deferred("disabled", true)
