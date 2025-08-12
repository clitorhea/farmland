extends CharacterBody2D

enum WorkState { IDLE, WORKING, MOVING_TO_WORK }
enum WorkType { FARMING, BUILDING, NONE }

@export var worker_name: String = "Thomas"
@export var move_speed: float = 50.0

var current_state: WorkState = WorkState.IDLE
var assigned_work: WorkType = WorkType.NONE
var work_target: Vector2
var work_progress: float = 0.0
var work_duration: float = 10.0  # seconds to complete work

func _physics_process(delta):
	match current_state:
		WorkState.IDLE:
			# Stand still, maybe idle animation
			pass
		WorkState.MOVING_TO_WORK:
			move_to_work_location()
		WorkState.WORKING:
			perform_work(delta)

func assign_work(work_type: WorkType, location: Vector2):
	assigned_work = work_type
	work_target = location
	current_state = WorkState.MOVING_TO_WORK
	work_progress = 0.0

func move_to_work_location():
	var direction = (work_target - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()
	
	if global_position.distance_to(work_target) < 10.0:
		current_state = WorkState.WORKING

func perform_work(delta):
	work_progress += delta
	# Visual: play work animation, spawn particles
	
	if work_progress >= work_duration:
		complete_work()

func complete_work():
	current_state = WorkState.IDLE
	# Trigger estate progress (clear plot, build structure, etc.)
	#SignalBus.work_completed.emit(assigned_work, work_target)
	assigned_work = WorkType.NONE
