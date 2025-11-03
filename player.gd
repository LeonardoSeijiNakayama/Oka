extends CharacterBody2D

@onready var Sprite = $Sprite2D
@onready var AttackArea = $Area2D

const SPEED = 450.0
const JUMP_VELOCITY = -800.0
var GRAVITY = Vector2.ZERO

var facing := 1 # 1 = direita, -1 = esquerda

func _ready() -> void:
	GRAVITY.x = 0.0
	GRAVITY.y = 1500.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += GRAVITY * delta

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction != 0:
		set_facing(direction)

func set_facing(dir: int)->void:
	if dir == facing:
		return
	facing = dir
	Sprite.flip_h = (facing<0)
	AttackArea.scale.x = facing
