class_name Player
extends CharacterBody2D

const speed : int = 100

@onready var camera = $Camera2D
@onready var sprite = $AnimatedSprite2D

enum {
	IDLE,
	WALK
}

class PlayerState extends State:
	var player : Player

	func _init(_player : Player):
		player = _player

class IdleState extends PlayerState:

	func enter():
		play_animation()

	func physics_update(delta : float):
		var direction = Input.get_vector("left", "right", "up", "down")
		if (direction.x != 0 or direction.y != 0):
			player.transition_state(WALK)

	func play_animation():
		player.sprite.play("idle")

class WalkState extends PlayerState:
	func physics_update(delta : float):
		var direction = Input.get_vector("left", "right", "up", "down")
		if (direction.x == 0 and direction.y == 0):
			player.transition_state(IDLE)
		else:
			player.velocity = direction * speed
			player.move_and_slide()
			play_animation(direction)

	func play_animation(direction : Vector2):
		var animation = "walk"
		var animation_dir = "s"
		if direction.x > 0:
			if direction.y > 0.3:
				animation_dir = "se"
			elif direction.y < -0.3:
				animation_dir = "ne"
			else:
				animation_dir = "e"
		elif direction.x < 0:
			if direction.y > 0.3:
				animation_dir = "sw"
			elif direction.y < -0.3:
				animation_dir = "nw"
			else:
				animation_dir = "w"
		elif direction.y > 0:
			animation_dir = "s"
		elif direction.y < 0:
			animation_dir = "n"

		player.sprite.play(animation + "-" + animation_dir)

@onready var states = {
	IDLE: IdleState.new(self),
	WALK: WalkState.new(self),
}

var state : State

func _ready():
	transition_state(IDLE)

func transition_state(next_state : int):
	state = states[next_state]
	state.enter()

func _physics_process(delta : float):
	state.physics_update(delta)
