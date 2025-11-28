extends CharacterBody2D

@onready var Sprite = $Sprite2D
@onready var AttackArea = $Area2D
@onready var DashTimer = $DashTimer
@onready var World: Node2D = get_parent()
@onready var ArrowScene = preload("res://Arrow.tscn")
@onready var SmokeScene = preload("res://swap_smoke.tscn")
@onready var AudioWalking: AudioStreamPlayer2D = $Audios/Walking
@onready var AudioDash: AudioStreamPlayer2D = $Audios/Dash
@onready var AudioArrow: AudioStreamPlayer2D = $Audios/ArrowSwoosh
@onready var AudioJump: AudioStreamPlayer2D = $Audios/Jump
@onready var AudioHit: AudioStreamPlayer2D = $Audios/Hit
@onready var AudioSwap: AudioStreamPlayer2D = $Audios/Swap

@export var lifes : int = 5

var muzzle_position = 0
const SPEED = 1300.0
const FIRST_JUMP_VELOCITY = -3500.0
const SECOND_JUMP_VELOCITY = -2600.0
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
var DASH_SPEED = 4500.0
@export_range(-1, 1)var dash_dir:int = 1
var dashtimerflag = false
var can_dash = true
var dashing = false
var facing := 1 # 1 = direita, -1 = esquerdad
var prev_direction
var state : String = 'idle'
var attackTimer = 0.0
var attackFlag = false
const ATTACK_TIME = 0.5
var jumpFlag = false

@export_range(-1, 1)var character: int = 1



func _ready() -> void:
	GRAVITY.x = 0.0
	GRAVITY.y = 8000.0
	REDUCED_GRAVITY.x = 0.0
	REDUCED_GRAVITY.y = 6000.0
	AttackArea.body_entered.connect(attack_area_detection)
	AttackArea.visible = false
	AttackArea.monitoring = false
	AttackArea.monitorable = false
	character = 1


func _process(delta: float) -> void:
	
	match state:
		'idle':
			if character == CHARACTER1:
				Sprite.play('idle_1')
			else:
				Sprite.play('idle_2')
		'attack':
			if not AudioArrow.playing:
				AudioArrow.play()
			if character == CHARACTER1:
				Sprite.play('attack_1')
			else:
				Sprite.play('attack_2')
		'run':
			if not AudioWalking.playing:
				AudioWalking.play()
			if character == CHARACTER1:
				Sprite.play('run_1')
			else:
				Sprite.play('run_2')
		'jump':
			if character == CHARACTER1 and jumpFlag:
				Sprite.play('jump_1')
			elif jumpFlag:
				Sprite.play('jump_2')
			jumpFlag = false
		'swap':
			pass
		'falling':
			if character == CHARACTER1:
				Sprite.play('falling_1')
			else:
				Sprite.play('falling_2')
	
	
	if Input.is_action_just_pressed("swap"):
		swap_character()
	
	if Input.is_action_just_pressed("attack") and !attacking and !attackCDFlag:
		state = 'attack'
		match character:
			CHARACTER1:
				if not is_on_floor() and Input.is_action_pressed("down"):
					shootDown()
				else: 
					shoot()
			CHARACTER2:
				attack()
	
	if attacking:
		run_attack_timer(delta)
	
	if attackCDFlag:
		run_attack_cd_timer(delta)



func _physics_process(delta: float) -> void:
	
	#aaaaaprint(state)
	# Timer da animação de attack
	if attackFlag and attackTimer >=0.0:
		attackTimer -= delta
	
	if attackTimer <=0.0:
		attackFlag = false
		
	
	# FÍSICA DO JUMP
	if not is_on_floor():
		if velocity.y>0:
			state = 'falling'
		## play pulo
		if Input.is_action_pressed("up") and velocity.y<0:
			velocity += REDUCED_GRAVITY * delta
		else:
			velocity += GRAVITY * delta
	
	
	# VERIFICA ESTADO DE IDLE E APLICA O ESTADO DE ESTAR NO CHÃO
	if is_on_floor():
		jumpFlag = false
		if not attackFlag:
			state = 'idle'
		jumpCount = 0
		can_dash = true
	
	
	# VERIFICA ESTADO DE RUN E APLICA VELOCIDADE
	var direction := Input.get_axis("left", "right")
	if direction:
		dash_dir = direction
		if not dashing and not attackFlag:
			velocity.x = direction * SPEED
			if is_on_floor():
				state = 'run'
	else:
		if not dashing:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	# LOGICA E ESTADO DE JUMP
	if Input.is_action_just_pressed("up") and jumpCount<2:
		if not AudioJump.playing:
				AudioJump.play()
		state = 'jump'
		if not attackFlag:
			jumpFlag = true
			
		print('jump count = ', jumpCount)
		match jumpCount:
			0:
				velocity.y = FIRST_JUMP_VELOCITY
			1:
				if character == CHARACTER1:
					velocity.y = SECOND_JUMP_VELOCITY
		jumpCount+=1

	
	#if dashtimerflag == true and DashTimer.time_left == 0.0:
		#dashtimerflag = false
	#elif dashtimerflag == true:
		### play dash
		#if (Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left")) and not dashing and can_dash and character == CHARACTER2 and !dashCDFlag:
			#if direction == prev_direction:
				#enable_dash()
	
	
	if direction:
		prev_direction = direction
		if DashTimer.time_left == 0.0: 
			DashTimer.start(0.2)
			dashtimerflag = true
	
	
	if Input.is_action_just_pressed("dash") and not dashing and can_dash and character == CHARACTER2 and !dashCDFlag:
		enable_dash()
	
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
	state = 'attack'
	attackFlag = true
	attackTimer = ATTACK_TIME
	AttackArea.monitoring = true
	AttackArea.monitorable = true
	AttackArea.visible = true
	attacking = true
	attackDurationTimer = ATTACK_DURATION
	print("iniciou ataque")

func shoot()->void:
	state = 'attack'
	attackFlag = true
	attackTimer = ATTACK_TIME
	var Arrow = ArrowScene.instantiate() as Node2D
	get_parent().add_child(Arrow, false, Node.INTERNAL_MODE_DISABLED)
	Arrow.global_position.y = global_position.y
	Arrow.global_position.x = global_position.x + (512*facing)
	attackCDTimer = SHOT_COOLDOWN
	attackCDFlag = true
	print('Facing: ', facing)
	Arrow.setDir(facing)


func shootDown()->void:
	state = 'attack'
	attackFlag = true
	attackTimer = ATTACK_TIME
	var Arrow = ArrowScene.instantiate()
	get_parent().add_child(Arrow, false, Node.INTERNAL_MODE_DISABLED)
	Arrow.global_position.y = global_position.y + 630
	Arrow.global_position.x = global_position.x
	attackCDTimer = SHOT_COOLDOWN
	attackCDFlag = true
	Arrow.setDir(0)



func run_attack_timer(delta:float)->void:
	attackDurationTimer -= delta
	if attackDurationTimer <= 0.0:
		attacking = false
		AttackArea.monitoring = false
		AttackArea.monitorable = false
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
	## play swap
	if not AudioSwap.playing:
		AudioSwap.play()
	state = 'swap'
	var smoke = SmokeScene.instantiate() as Node2D
	smoke.global_position = global_position
	get_parent().add_child(smoke)
	if character == CHARACTER1:
		character = CHARACTER2
	else:
		character = CHARACTER1



func enable_dash()->void:
	if not AudioDash.playing:
		AudioDash.play()
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
	dashCDTimer -= delta
	if dashCDTimer<=0.0:
		dashCDTimer = 0.0
		dashCDFlag = false


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	lifes -= 1
	if not AudioHit.playing:
		AudioHit.play()
	print('lifes = ', lifes)
	_area.get_parent().queue_free()
	if(lifes <= 0):
		print('morreu')
		queue_free()
