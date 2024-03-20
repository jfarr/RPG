class_name MOB extends Node2D

@onready var character : CharacterBody2D = get_owner()

enum State {
	IDLE,
	NEW_DIR,
	MOVE
}

@export var sprite : AnimatedSprite2D
@export var walk_speed = 30

var state = State.IDLE
var direction = Vector2.RIGHT

func _ready():
	randomize()

func _physics_process(delta : float):
	match state:
		State.IDLE:
			sprite.play("idle")
		State.NEW_DIR:
			direction = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			sprite.play("idle")
		State.MOVE:
			move(walk_speed)
			play_animation()
			#var distance = ((position + direction * walk_speed) - starting_pos).length()
			#if distance < max_distance:
				#move(walk_speed)
			#else:
				#current_state = State.NEW_DIR

func choose(choices):
	choices.shuffle()
	return choices.front()

func move(speed):
	character.velocity = direction * speed
	character.move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1.0, 1.5])
	state = choose([State.IDLE, State.NEW_DIR, State.MOVE])

func play_animation():
	if direction.x == -1:
		sprite.play("move-w")
	elif direction.x == 1:
		sprite.play("move-e")
	elif direction.y == -1:
		sprite.play("move-n")
	elif direction.y == 1:
		sprite.play("move-s")
