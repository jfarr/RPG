class_name Player
extends CharacterBody2D

enum State {
	IDLE,
	WALKING
}

const speed : int = 100

@onready var camera = $Camera2D
@onready var sprite = $AnimatedSprite2D

var state : State = State.IDLE;

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")

	velocity = direction * speed
	move_and_slide()
	
	play_animation(direction)

func play_animation(direction : Vector2):
	state = (
		State.IDLE 
		if (direction.x == 0 and direction.y == 0)
		 else State.WALKING
		)

	if state == State.IDLE:
		sprite.play("idle")
	else:
		#var animation = "attack" if bow_equipped else "walk"
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

		sprite.play(animation + "-" + animation_dir)
