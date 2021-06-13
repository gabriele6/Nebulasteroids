extends CanvasLayer

func _on_Tween_tween_all_completed():
	queue_free()
