extends VBoxContainer

func get_username()->String:
	return $UserName.text

func get_ip_adress()->String:
	return $IPAddress.text

func get_port()->String:
	return $Port.text

func set_username(userName:String)->void:
	$UserName.text = userName

func _on_join_button_button_down() -> void:
	owner._on_join_button_button_down()

func _on_host_button_button_down() -> void:
	owner._on_host_button_button_down()
