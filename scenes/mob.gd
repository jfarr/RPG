class_name MOB extends CharacterBody2D

enum {
	IDLE,
	NEW_DIR,
	MOVE,
}

class MOBState extends State:

	var mob : MOB

	func _init(_mob : MOB):
		mob = _mob

class IdleState extends MOBState:

	func enter():
		mob.sprite.play("idle")

class MoveState extends MOBState:

	func physics_update(delta : float):
		var distance = ((mob.position + mob.direction * mob.walk_speed) - mob.starting_pos).length()
		if distance < mob.max_distance:
			mob.move(mob.walk_speed)
			mob.play_animation()
		else:
			mob.transition_state(NEW_DIR)
			mob.move_timer.wait_time = 0.5
			mob.sprite.play("idle")

class NewDirectionState extends MOBState:
	
	func enter():
		mob.direction = mob.choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		mob.sprite.play("idle")

@onready var states : Array[MOBState] = [
	IdleState.new(self),
	NewDirectionState.new(self),
	MoveState.new(self),
]

func transition_state(next_state : int):
	state = states[next_state]
	state.enter()

@export var sprite : AnimatedSprite2D
@export var walk_speed = 30
@export var max_distance = 120

var state : MOBState
var direction = Vector2.RIGHT
var starting_pos : Vector2
var move_timer = Timer.new()

func _ready():
	randomize()
	starting_pos = position
	setup_timer()
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
	move_timer.wait_time = choose([0.5, 1.0, 1.5])
	var new_state = choose([IDLE, NEW_DIR, MOVE])
	transition_state(new_state)

func play_animation():
	if direction.x == -1:
		sprite.play("move-w")
	elif direction.x == 1:
		sprite.play("move-e")
	elif direction.y == -1:
		sprite.play("move-n")
	elif direction.y == 1:
		sprite.play("move-s")
