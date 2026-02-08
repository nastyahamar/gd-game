extends Node2D


export var Enemy: PackedScene
export var Coin: PackedScene

var score = 0

var screensize

func _ready():
	randomize()

func _process(delta):
	screensize = get_viewport_rect().size
	$PlayerPosition.position = Vector2(screensize.x / 2, screensize.y / 2)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$CoinTimer.stop()
	
	for node in get_tree().get_nodes_in_group("Enemies"):
		node.queue_free()
	for node in get_tree().get_nodes_in_group("Items"):
		node.queue_free()
	

func _on_ScoreTimer_timeout():
	score +=1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$CoinTimer.start()


func _on_MobTimer_timeout():
	
	var pos_array = [
		Vector2(0, rand_range(0, screensize.y)),
		Vector2(screensize.x, rand_range(0, screensize.y)),
		Vector2(rand_range(0, screensize.x), 0),
		Vector2(rand_range(0, screensize.x), screensize.y)
	]
	
	var rot_array = [
		0,
		PI,
		PI/2,
		-PI/2
	]
	
	var mob = Enemy.instance()
	$Enemies.add_child(mob)
	
	var num = randi() % 4
	
	var direction = rot_array[num]
	mob.position = pos_array[num]
	
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	
	mob.set_linear_velocity(Vector2(rand_range(sqrt(screensize.x*screensize.y)/5, sqrt(screensize.x*screensize.y)/2), 0).rotated(direction))
	
	

func _on_HUD_start_game():
	score = 0
	$Player.start($PlayerPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready!!")


func _on_Player_hit():
	game_over()


func _on_Player_item_pickup(item):
	if item.get_type() == "Coin":
		score += 10
		$HUD.update_score(score)
	

func _on_CoinTimer_timeout():
	var coin_position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
	var coin = Coin.instance()
	$Items.add_child(coin)
	coin.position = coin_position
