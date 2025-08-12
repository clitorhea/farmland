extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
var is_moving : bool = false
var move_direction : Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN
var input_vector : Vector2 = Vector2.ZERO
var facing_direction : String = "down"


func _ready() -> void:
	if not animated_sprite_2d : 
		push_error("No Animated Sprite 2D!!!! ")
	play_animation("idle")

func _physics_process(delta: float) -> void:
	get_input()
	process_move_direction()
	handle_movement()
	update_animation()

func process_move_direction() -> void : 
	move_direction = input_vector.normalized()
	if move_direction.length() > 0 : 
		if abs(move_direction.x) > abs(move_direction.y): 
			move_direction = Vector2(sign(move_direction.x),0)
		else: 
			move_direction = Vector2(0,sign(move_direction.y))

func play_animation(name : String) -> void : 
	
	var prefix : String = "" ;
	if name == "idle": 
		prefix = "idle_"
	if name == "walk": 
		prefix = "walk_"
	
	var animation_dir = facing_direction
	var should_flip = false 
	
	animated_sprite_2d.play(name)

func get_input(): 
	#input_vector.x = Input.get_axis("move_left","move_right")
	#input_vector.y = Input.get_axis("move_up","move_down")
	var input_dir = Input.get_vector("move_left","move_right","move_up", "move_down")
	velocity = input_dir * SPEED

func handle_movement() -> void : 
	if move_direction.length() > 0 : 
		last_direction = move_direction
		is_moving = true
	else: 
		is_moving = false 
	move_and_slide()

func update_animation() -> void : 
	if is_moving : 
		play_animation("walk")
	else : 
		play_animation("idle")
		
func update_direction() -> void : 
	facing_direction = get_4way_direction(last_direction)

func get_4way_direction(direction : Vector2) -> String : 
	if abs(direction.x) > abs(direction.y) : 
		if direction.x > 0 : 
			return "right"
		else: 
			return "left"
	else: 
		if direction.y > 0 : 
			return "down"
		else : 
			return "up"
