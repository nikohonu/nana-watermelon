extends Node

var yokai_dict = {
	1: load("res://yokai/yokai1.tscn"),
	2: load("res://yokai/yokai2.tscn"),
	3: load("res://yokai/yokai3.tscn"),
	4: load("res://yokai/yokai4.tscn"),
	5: load("res://yokai/yokai5.tscn")
}


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
