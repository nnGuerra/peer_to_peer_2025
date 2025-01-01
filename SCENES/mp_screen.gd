extends Control

@export var chat:Node
@export var userName:Node
@export var connection:Node

var peer:ENetMultiplayerPeer

func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func get_user_name()->String:
	return $HBoxContainer/Connection/UserName.text

func get_ip_adress()->String:
	return $HBoxContainer/Connection/IPAddress.text

func get_port()->int:
	return int($HBoxContainer/Connection/Port.text)

func peer_connected(id:int)->void:
	chat.write_output(str(id," connected!"))

func peer_disconnected(id:int)->void:
	chat.write_output(str(id," disconnected."))

func connected_to_server()->void:
	chat.write_output("Connected to server.")

func connection_failed()->void:
	chat.write_output("Connection failed.")

func _on_host_button_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(get_port())
	if error != OK:
		chat.write_output(str("Host failed: ",error))
		return
	if get_user_name() == "":
		userName.text = "Host"
	multiplayer.set_multiplayer_peer(peer)
	chat.write_output("Hosting.")
	connection.hide()

func _on_join_button_button_down() -> void:
	if get_user_name() == "":
		chat.write_output("Connection failed: No username.")
		return
	peer = ENetMultiplayerPeer.new()
	peer.create_client(get_ip_adress(),get_port())
	multiplayer.set_multiplayer_peer(peer)
	connection.hide()