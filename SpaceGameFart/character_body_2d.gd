extends CharacterBody2D

@onready var StaminaTime = $"../Timer"

@export var maxStamina: float = 10.0
@export var walk_speed: float = 300.0
@export var sprint_speed: float = 600.0
@export var drain_rate: float = 5.0
@export var regen_rate: float = 5.0
@export var max_health: float = 100.0
@export var oxygen_drain_hp: float = 2.0
@export var oxygen_max: float = 100.0
@export var oxygen_drain: float = 1.0
@export var oxygen_regen: float = 25.0
var is_outside: bool = true
var currentStamina: float = 10.0
var is_exhausted: bool = false
var is_sprint: bool = false
var current_speed: float = 300.0
var current_health: float = 100.0
var current_oxygen: float = 100.0


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	

	if Input.is_action_pressed("sprint") and direction != Vector2.ZERO and not is_exhausted:
		is_sprint = true
		current_speed = sprint_speed
		currentStamina -= drain_rate * delta
		if currentStamina <= 0.0:
			currentStamina = 0.0
			is_exhausted = true
			is_sprint = false
			current_speed = walk_speed
	else:
		is_sprint = false
		current_speed = walk_speed
		currentStamina += regen_rate * delta
		if is_exhausted and currentStamina >= maxStamina:
			is_exhausted = false
			
	currentStamina = clamp(currentStamina, 0.0, maxStamina)
	
	# For Didy movement
	velocity = direction * current_speed
	move_and_slide()
	print(currentStamina)
	
	if is_outside == true:
		current_oxygen -= oxygen_drain * delta
	else:
		current_oxygen += oxygen_regen * delta
		
	if current_oxygen <= 0.0:
		current_health -= oxygen_drain_hp * delta
	#To test drain values. not needed in final patch
	#if current_health <= 98.0:
		#is_outside = false
	#if current_oxygen >= 4.0:
		#is_outside = true
	
	current_oxygen = clamp(current_oxygen, 0.0, oxygen_max)
	current_health = clamp(current_health, 0.0, max_health)
	
	print("Oxygen: ", current_oxygen)
	print("HP: ", current_health)
	
	
