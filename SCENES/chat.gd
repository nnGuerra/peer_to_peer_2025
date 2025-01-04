extends VBoxContainer

@export var output:Node
@export var input:Node

@onready var MP = get_tree().root.get_node("MPScreen")

@rpc("any_peer","call_local")
func write_output(message:String)->void:
	output.text += message + "\n"

func hide_input()->void:
	input.hide()

func show_input()->void:
	input.show()

func _on_input_text_submitted(new_text: String) -> void:
	var message = str(MP.get_user_name(),": ",new_text)
	write_output.bind(message).rpc()
	input.text = ""
