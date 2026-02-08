extends Area2D
signal hit
signal item_pickup(item)

export var speed = 200
var dash_speed = speed * 3
var screensize

const PLAYER_HEIGHT = 135
const PLAYER_WIDTH = 108

var is_dashing = false 
var can_dash = true

var is_hidden = true
var velocity 
var DashGhost = preload("res://player/DashGhost.tscn")

func _ready():
	hide()

func _process(delta):
	screensize = get_viewport_rect().size
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	direction = direction.normalized()
	
	
	if is_dashing:
		velocity = direction * dash_speed * delta
	else:
		velocity = direction * speed * delta
	
	
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()	
	
	position += velocity
	
	
	position.x = clamp(position.x, 0 +  PLAYER_WIDTH * 0.5 * $AnimatedSprite.scale.x, screensize.x - PLAYER_WIDTH * 0.5 * $AnimatedSprite.scale.x)
	position.y = clamp(position.y, 0 +  PLAYER_HEIGHT * 0.5 * $AnimatedSprite.scale.y, screensize.y -  PLAYER_HEIGHT * 0.5 * $AnimatedSprite.scale.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y !=0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		


func _input(event):
	if Input.is_action_just_pressed("dash") and can_dash and !is_hidden and velocity != Vector2.ZERO:
		start_dash()


func start_dash():
	is_dashing = true
	can_dash = false
	$SpeedTimer.start()
	$GhostTimer.start()
	$CollisionShape2D.disabled = true


func start(pos):
	position = pos
	show()
	is_hidden = false

func _on_Player_body_entered(body):
	hide()
	is_hidden = true
	emit_signal("hit")


func _on_Player_area_entered(area):
	if area.is_in_group("Items"):
		emit_signal("item_pickup", area)


func _on_SpeedTimer_timeout():
	is_dashing = false
	$CollisionShape2D.disabled = false
	$GhostTimer.stop()
	$DashTimer.start()
	
	
func spawn_dash_ghost():
	var ghost = DashGhost.instance()
	get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.texture = $AnimatedSprite.get_sprite_frames().get_frame($AnimatedSprite.animation, $AnimatedSprite.get_frame())
	ghost.flip_h = false if scale.x == 1 else true
	ghost.scale = $AnimatedSprite.scale


func _on_DashTimer_timeout():
	can_dash = true


func _on_GhostTimer_timeout():
	spawn_dash_ghost()
