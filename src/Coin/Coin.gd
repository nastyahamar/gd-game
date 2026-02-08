extends Area2D

func get_type():
	return "Coin"
	
 

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		$AnimationPlayer.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_in":
		$AnimationPlayer.play ("float")
		
	
