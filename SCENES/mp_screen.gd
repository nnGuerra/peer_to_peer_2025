extends Control

@export var chat:Chat
@export var connection:Node

var peer:ENetMultiplayerPeer

func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(server_disconnected)

func get_username()->String:
	return connection.get_username()

func get_ip_adress()->String:
	return connection.get_ip_adress()

func get_port()->int:
	return int(connection.get_port())

func peer_connected(id:int)->void:
	chat.write_output(str(id," connected!"))
	if multiplayer.is_server():
		ConnectionsManager.add_connection(1,get_username())
		ConnectionsManager.add_previous_connections(id)

func peer_disconnected(id:int)->void:
	chat.write_output(str(id," disconnected."))
	ConnectionsManager.remove_connection.bind(id)

func server_disconnected()->void:
	chat.write_output("Server disconnected.")
	chat.hide_input()

func connected_to_server()->void:
	chat.write_output("Connected to server.")
	var myId = multiplayer.get_unique_id()
	ConnectionsManager.add_connection.bind(myId,get_username()).rpc()

func connection_failed()->void:
	chat.write_output("Connection failed.")

func _on_host_button_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(get_port())
	if error != OK:
		chat.write_output(str("Host failed: ",error))
		return
	if get_username() == "":
		connection.set_username("Host")
	multiplayer.set_multiplayer_peer(peer)
	chat.write_output("Hosting.")
	connection.hide()
	chat.show()

func _on_join_button_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(get_ip_adress(),get_port())
	if error != OK:
		chat.write_output(str("Can't join.",error))
		return
	multiplayer.set_multiplayer_peer(peer)
	if get_username() == "":
		connection.set_username(str("User ",multiplayer.get_unique_id()))
	connection.hide()
	chat.show()
