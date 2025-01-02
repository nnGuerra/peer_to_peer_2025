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
	if multiplayer.is_server():
		ConnectionsManager.add_connection(1,get_user_name())
		ConnectionsManager.add_previous_connections(id)

func peer_disconnected(id:int)->void:
	chat.write_output(str(id," disconnected."))
	ConnectionsManager.remove_connection.bind(id)

func connected_to_server()->void:
	chat.write_output("Connected to server.")
	var myId = multiplayer.get_unique_id()
	ConnectionsManager.add_connection.bind(myId,get_user_name()).rpc()

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
	chat.show()

func _on_join_button_button_down() -> void:
	if get_user_name() == "":
		chat.write_output("Connection failed: No username.")
		return
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(get_ip_adress(),get_port())
	if error != OK:
		chat.write_output(str("Can't join.",error))
		return
	multiplayer.set_multiplayer_peer(peer)
	connection.hide()
	chat.show()
