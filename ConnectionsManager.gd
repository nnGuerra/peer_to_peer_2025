extends Node

var connections:Dictionary = {}

@rpc("call_local","any_peer")
func add_connection(id:int,userName:String)->void:
	if !connections.has(id):
		connections[id] = {
			"USERNAME":userName,
			"ID":id,
			}

@rpc("call_local","any_peer")
func remove_connection(id:int)->void:
	if connections.has(id):
		connections.erase(id)

@rpc("authority")
func add_previous_connections(id:int)->void:
	for connection in connections:
		add_connection.bind(connection,connections[connection]["USERNAME"]).rpc_id(id)
