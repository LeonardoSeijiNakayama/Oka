extends CharacterBody2D

@onready var Sprite = $Sprite2D
@onready var AttackArea = $Area2D
@onready var DashTimer = $DashTimer
@onready var World: Node2D = get_parent()
@onready var ArrowScene = preload("res://Arrow.tscn")

const SPEED = 450.0
const FIRST_JUMP_VELOCITY = -700.0
const SECOND_JUMP_VELOCITY = -600.0
var GRAVITY = Vector2.ZERO
var REDUCED_GRAVITY = Vector2.ZERO
var attacking = false
var ATTACK_DURATION = 0.1
@export_range(0, 2)var jumpCount: int = 0
@export_range(0.0, 0.2)var attackDurationTimer: float = 0.0
var ATTACK_COOLDOWN = 0.3
var SHOT_COOLDOWN = 0.5
var attackCDFlag = false
var CHARACTER1 = 1
var CHARACTER2 = -1
@export_range(0.0, 1.0) var attackCDTimer: float = 0.0
var DASH_DURATION = 0.15
@export_range(0.1, 0.2)var dashDurationTimer: float = 0.0
var DASH_COOLDOWN = 0.25
@export_range(0.0,0.15)var dashCDTimer: float = 0.0
var dashCDFlag = false
var DASH_SPEED = 1400.0
@export_range(-1, 1)var dash_dir:int = 1
var dashtimerflag = false
var can_dash = true
var dashing = false
var facing := 1 # 1 = direita, -1 = esquerdad
var prev_direction

@export_range(-1, 1)var character: int = 1



func _ready() -> void:
	GRAVITY.x = 0.0
	GRAVITY.y = 2000.0
	REDUCED_GRAVITY.x = 0.0
	REDUCED_GRAVITY.y = 1000.0
	AttackArea.body_entered.connect(attack_area_detection)
	AttackArea.visible = false
	character = 1


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("swap"):
		swap_character()
	
	if Input.is_action_just_pressed("attack") and !attacking and !attackCDFlag:
		match character:
			CHARACTER1:
				shoot()
			CHARACTER2:
				attack()
		
		
		
	if attacking:
		run_attack_timer(delta)
	
	if attackCDFlag:
		run_attack_cd_timer(delta)



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if jumpCount == 0:
			jumpCount = 1
		if Input.is_action_pressed("up") and velocity.y<0:
			velocity += REDUCED_GRAVITY * delta
		else:
			velocity += GRAVITY * delta
	
	if is_on_floor():
		jumpCount = 0
		can_dash = true
	
	if Input.is_action_just_pressed("up") and jumpCount<2:
		match jumpCount:
			0:
				velocity.y = FIRST_JUMP_VELOCITY
			1:
				if character == CHARACTER1:
					velocity.y = SECOND_JUMP_VELOCITY
		jumpCount+=1
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		dash_dir = direction
		if not dashing:
			velocity.x = direction * SPEED
	else:
		if not dashing:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if dashtimerflag == true and DashTimer.time_left == 0.0:
		dashtimerflag = false
	elif dashtimerflag == true:
		if (Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left")) and not dashing and can_dash and character == CHARACTER2 and !dashCDFlag:
			if direction == prev_direction:
				enable_dash()
	
	
	if direction:
		prev_direction = direction
		if DashTimer.time_left == 0.0: 
			DashTimer.start(0.2)
			dashtimerflag = true
	
	
	#if Input.is_action_just_pressed("dash") and not dashing and can_dash and character == CHARACTER2 and !dashCDFlag:
		#enable_dash()
	
	if dashing:
		run_dash_timer(delta)
	
	if dashCDFlag:
		run_dash_cd_timer(delta)
	
	move_and_slide()
	
	if direction != 0:
		set_facing(direction)



func set_facing(dir: int)->void:
	if dir == facing:
		return
	facing = dir
	Sprite.flip_h = (facing<0)
	AttackArea.scale.x = facing



func attack_area_detection(area:Area2D) -> void:
	if area.is_in_group("Enemy"):
		print("hit")



func attack()->void:
	AttackArea.monitoring = true
	AttackArea.visible = true
	attacking = true
	attackDurationTimer = ATTACK_DURATION
	print("iniciou ataque")

func shoot()->void:
	var Arrow = ArrowScene.instantiate()
	get_parent().add_child(Arrow, false, Node.INTERNAL_MODE_DISABLED)
	Arrow.global_position.y = global_position.y
	Arrow.global_position.x = global_position.x + (96*facing)
	attackCDTimer = SHOT_COOLDOWN
	attackCDFlag = true
	Arrow.setDir(facing)

func run_attack_timer(delta:float)->void:
	attackDurationTimer -= delta
	if attackDurationTimer <= 0.0:
		attacking = false
		AttackArea.monitoring = false
		AttackArea.visible = false
		attackDurationTimer = 0.0
		attackCDTimer = ATTACK_COOLDOWN
		attackCDFlag = true
		print("finalizou ataque")



func run_attack_cd_timer(delta:float)->void:
	attackCDTimer -= delta
	if attackCDTimer <=0.0:
		attackCDFlag = false
		attackCDTimer = 0.0
		print("Fim do cooldown")



func swap_character()->void:
	if character == CHARACTER1:
		character = CHARACTER2
	else:
		character = CHARACTER1



func enable_dash()->void:
	dashing = true
	dashDurationTimer = DASH_DURATION
	dashCDTimer = DASH_COOLDOWN
	dashCDFlag = true
	if !is_on_floor():
		can_dash = false



func run_dash_timer(delta:float)->void:
	velocity.y = 0
	velocity.x = dash_dir*DASH_SPEED
	dashDurationTimer -=delta
	if(dashDurationTimer<=0):
		dashDurationTimer = 0.0
		dashing = false



func run_dash_cd_timer(delta:float)->void:
	dashCDTimer-=delta
	if dashCDTimer<=0.0:
		dashCDTimer = 0.0
		dashCDFlag = false
