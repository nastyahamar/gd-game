extends RigidBody2D

var min_speed = 200
var max_speed = 500

var mob_types = ["walk", "swim", "fly"]

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % 3]
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

