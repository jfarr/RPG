class_name MOB extends CharacterBody2D

enum {
	IDLE,
	NEW_DIR,
	MOVE,
	CHASE,
	DIALOG,
}

class MOBState extends State:

	var mob : MOB

	func _init(_mob : MOB):
		mob = _mob

class IdleState extends MOBState:
	
	func enter():
		mob.sprite.play("idle")

class MoveState extends MOBState:

	var speed : int

	func _init(_mob : MOB):
		super(_mob)
		speed = _mob.walk_speed

	func physics_update(delta : float):
		var distance = ((mob.position + mob.direction * speed) - mob.starting_pos).length()
		if distance < mob.max_distance:
			mob.move(speed)
			play_animation()
		else:
			mob.transition_state(NEW_DIR)
			mob.move_timer.wait_time = 0.5
			mob.sprite.play("idle")

	func play_animation():
		if mob.direction.x == -1:
			mob.sprite.play("move-w")
		elif mob.direction.x == 1:
			mob.sprite.play("move-e")
		elif mob.direction.y == -1:
			mob.sprite.play("move-n")
		elif mob.direction.y == 1:
			mob.sprite.play("move-s")

class NewDirectionState extends MOBState:

	func enter():
		mob.direction = mob.choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		mob.transition_state(MOVE)

class ChaseState extends MOBState:

	var speed : int

	func _init(_mob : MOB):
		super(_mob)
		speed = _mob.run_speed

	func physics_update(delta : float):
		mob.direction = (mob.player.get_global_position() - mob.get_global_position()).normalized()
		mob.move(speed)
		mob.starting_pos = mob.position

	func play_animation():
		if mob.direction.x < 0:
			mob.sprite.play("run-w")
		elif mob.direction.x > 0:
			mob.sprite.play("run-e")
		elif mob.direction.y < 0:
			mob.sprite.play("run-n")
		elif mob.direction.y > 0:
			mob.sprite.play("run-s")

class DialogState extends MOBState:

	func enter():
		mob.sprite.play("idle")
		mob.player.set_process_input(false)

	func exit():
		mob.player.set_process_input(true)

@onready var states : Array[MOBState] = [
	IdleState.new(self),
	NewDirectionState.new(self),
	MoveState.new(self),
	ChaseState.new(self),
	DialogState.new(self),
]

func transition_state(next_state : int):
	if state:
		state.exit()
	state = states[next_state]
	state.enter()

@export var sprite : AnimatedSprite2D
@export var walk_speed = 30
@export var run_speed = 50
@export var max_distance = 120
@export var hostile = false
@export var detection_area : Area2D
@export var dialog : NPCDialog

var state : MOBState
var direction = Vector2.RIGHT
var starting_pos : Vector2
var player : Player = null
var move_timer = Timer.new()

func _ready():
	randomize()
	starting_pos = position
	setup_timer()
	if detection_area != null:
		detection_area.body_entered.connect(_on_detection_area_body_entered)
		detection_area.body_exited.connect(_on_detection_area_body_exited)
	if dialog != null:
		dialog.dialog_started.connect(_on_dialog_started)
		dialog.dialog_finished.connect(_on_dialog_finished)

	transition_state(IDLE)

func setup_timer():
	move_timer.timeout.connect(_on_timer_timeout)
	move_timer.set_wait_time(0.5)
	move_timer.set_autostart(true)
	add_child(move_timer)

func _physics_process(delta : float):
	state.physics_update(delta)

func choose(choices):
	choices.shuffle()
	return choices.front()

func move(speed):
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout():
	if player == null:
		move_timer.wait_time = choose([0.5, 1.0, 1.5])
		var new_state = choose([IDLE, NEW_DIR, MOVE])
		transition_state(new_state)

func _on_detection_area_body_entered(body : Player):
	if body != null:
		player = body
		transition_state(CHASE)

func _on_detection_area_body_exited(body : Player):
	if body != null:
		player = null
		transition_state(NEW_DIR)

func _on_dialog_started():
	transition_state(DIALOG)

func _on_dialog_finished():
	transition_state(NEW_DIR)
