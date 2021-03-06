note
	description: "[
					This class will be responsible for communication on Client side.
					Infact it will manage all the messages arriving or sent to the
					Server side through a socket.
					]"
	author: "Luca Falsina"
	date: "17.11.2012"
	revision: "1.1"

class
	G5_NET_MESSENGER_CLIENT

inherit
	SOCKET_RESOURCES
	STORABLE

create
	make

feature -- Status Report

	communication_socket: detachable NETWORK_STREAM_SOCKET
			-- This socket is generated when a client connects succesfully with its server.
			-- It will be used to send and receive G5_MESSAGE instances from the server net class.

	received_messages: G5_MESSAGES_CONTAINER
			-- This list contains all the received G5_MESSAGE objects, which are generated on Server
			-- side and need to be forwarded to the NET CONTROLLER CLIENT

	response_messages: G5_MESSAGES_CONTAINER
			-- This list contains all the messages that are going to be sent to the server at the next
			-- invocation of the send_response feature.

	messenger_observer: G5_NET_MESSENGER_OBSERVER
			-- This is the reference to the object which is informed about the activities of sending
			-- and receiving messages through the socket communication_socket

	player_name: STRING
			-- This string represents the name that will be taken by the client if the connection
			-- procedure works fine.

feature {G5_NET_CONTROLLER_CLIENT} -- Initialization by G5_NET_CONTROLLER_CLIENT

	make(associated_observer: G5_NET_MESSENGER_OBSERVER; my_name: STRING; server_ip: STRING; server_port: INTEGER)
			-- This constructor instantiates the NET MESSENGER CLIENT component and in particular it will
			-- grant that associated_observer will be informed every time this instance receives a new message.
			-- This creation feature will be launched when the client call the "connect" feature
			-- in G5_NET_CONTROLLER_CLIENT and it will set a socket connection if everything works fine.
		require
			existent_observer: associated_observer /= void
			valid_name:	my_name /= void and
						not(my_name.is_equal ("SERVER")) and
						not(my_name.is_empty)
			valid_port: server_port > 1024 and server_port < 5000
		local
			connection_message: G5_MESSAGE_TEXTUAL
				-- This message will be sent to the server asking for the connection evaluation.
			ip_address_manager: G5_IP_MANAGER
				-- This object checks the validation process of an IP address
			valid_ip_address: INET_ADDRESS
				-- This is the valid address generated by the ip_manager starting from the
				-- string server_ip, obtained as a parameter
			connection_has_failed: BOOLEAN
		do
			-- If this code is performed for the first time then the connection
			-- procedure must be attempted.
			if not(connection_has_failed) then
				-- The IP address is obtained from the parameter "server_ip"
				create ip_address_manager.make_empty
				valid_ip_address := ip_address_manager.generates_ip_from_string (server_ip)

				-- The incoming associated_observer and my_name are saved in the class state
				messenger_observer := associated_observer
				player_name := my_name

				create received_messages.make
				create response_messages.make

				-- Here the client try to connect to the server using a Socket and end a message
				-- with action connect to the Server.
				create communication_socket.make_client_by_address_and_port (valid_ip_address, server_port)

				communication_socket.set_connect_timeout (5000)
				communication_socket.connect

				if not(communication_socket.is_connected) then
					(create {DEVELOPER_EXCEPTION}).raise
				end

				create connection_message.make (player_name, <<"SERVER">>, "connect", void)
				connection_message.independent_store (communication_socket)

				-- Here the client waits for a connection response from th Server.
				if attached {G5_MESSAGES_CONTAINER} retrieved (communication_socket) as connect_result_list then
					-- Here the first message of the container, which must have action "connect_result",
					-- is recovered and checked.
					connect_result_list.start

					if (connect_result_list.item.targets.item (1).is_equal (player_name) and
						connect_result_list.item.action.is_equal ("connect_result")) then

						-- In this case a correct message container has just been retrieved from the Server and its
						-- messages will be forwarded later to the messenger_observer.
						from
							connect_result_list.start
						until
							connect_result_list.off
						loop
							received_messages.force (connect_result_list.item)

							connect_result_list.forth
						end
						-- This class reports to the messenger observer that one or more new messages
						-- can be retrieved.
						messenger_observer.alert_for_incoming_messages

					else
						clean_up_socket_and_exit
					end

				else
					clean_up_socket_and_exit
				end
			end

		ensure
			valid_observer_component: messenger_observer = associated_observer
			valid_player_name: player_name = my_name
			valid_socket: communication_socket /= void
			valid_list_incoming_messages: received_messages /= void
			valid_list_outgoing_messages: response_messages /= void

		rescue
            if communication_socket /= Void then
				clean_up_socket_and_exit
				connection_has_failed := true
				retry
            end
		end

feature {G5_NET_MESSENGER_CLIENT} -- Internal feature

	clean_up_socket_and_exit
			-- This feature is executed whenever a client arises an error during the
			-- connection procedure. The socket is closed and an error message is
			-- sent to the messenger_observer.
		local
			connect_error_message: G5_MESSAGE_TEXTUAL
				-- This message will be generated when an error occurs on client side
				-- while the connection phase is performed.
		do
			communication_socket.cleanup
			create connect_error_message.make ("SERVER", <<player_name>>, "connect_result", "refused:no_server_found")
			received_messages.force (connect_error_message)
			messenger_observer.alert_for_incoming_messages
		ensure
			-- Messenger Observer has received the error message and
			-- the related socket has been cleaned up.
		end

feature {G5_NET_CONTROLLER_CLIENT, TEST_SET_G5_NET_MESSENGER_CLIENT} -- Communication through socket

	enque_message_to_server(socket_message: G5_MESSAGE)
			-- This feature will be called whenever a G5_MESSAGE object needs to be carried
			-- from the actual client to the server.
		require
			correct_message:
				socket_message /= void and
				socket_message.source.is_equal (player_name) and
				socket_message.targets.count = 1 and
				socket_message.targets.item (1).is_equal ("SERVER")
		do
			response_messages.force (socket_message)

		ensure
			-- the message is correctly enqued in the response_messages list.
		end

	send_response_to_server
			-- This feature sends a response composed by a list of G5_MESSAGE objects.
			-- In particular the last one of them will be a message with action "response".
			-- After that the list of the responses is sent, it will be made empty.
		local
			tail_message: G5_MESSAGE_TEXTUAL
		do
			-- A tail message with action "response" is added to the outgoing list.
			create tail_message.make (player_name, <<"SERVER">>, "response", void)
			response_messages.force (tail_message)

			-- The list of outgoing messages is sent to the Server.
			response_messages.independent_store (communication_socket)

			-- The outgoing messages list is clean.
			response_messages.wipe_out

		ensure
			empty_response_list: response_messages.is_empty
		end

	wait_for_messages()
			-- This feature will be invoked when a client needs to receive one or more G5_MESSAGE
			-- from the server before performing an action.
			-- When this component receives a message, it will notify its supervisor of this event
			-- so that the messages in the queue can be later recovered.
		do
			if attached {G5_MESSAGES_CONTAINER} retrieved (communication_socket) as incoming_message_list then
				-- Here a new message list is retrieved and its messages are saved into recieved_messages list.
				received_messages.append (incoming_message_list)

				-- It is reported to the observer that new messages can be recovered.
				messenger_observer.alert_for_incoming_messages
			end
		end

	get_and_clean_message_list(): LINKED_LIST[G5_MESSAGE]
			-- This feature may be called by a NET CONTROLLER to retrieve all the previous messages which
			-- has been alraedy stored by this class but not still retrieved by the controller.
			-- The list of new incoming messages is returned and then the internal list is remade empty.
		require
			at_least_one_message_is_present: received_messages.count > 0
		local
			result_list: LINKED_LIST[G5_MESSAGE]
				-- A list used to copy all the messages saved in G5_NET_MESSENGER_CLIENT
		do
			create result_list.make

			from
				received_messages.start
			until
				received_messages.off
			loop
				-- Every element of the received messages list
				-- is copied into the resut one.
				result_list.force (received_messages.item)

				received_messages.forth
			end

			-- The received messages list is cleant.
			received_messages.wipe_out

			-- The copy list is returned as the result.
			Result := result_list
		ensure
			list_incoming_messages_is_returned: Result.for_all (agent (message: G5_MESSAGE): BOOLEAN
			do Result := (message /= void) end ) and Result.count = old received_messages.count
			now_message_list_is_empty: received_messages.is_empty
		end

	close_communication
			-- When this feature is invoked, it reports that a game is finished and the rematch was
			-- not taken. The communiction socket is closed.
		do
			communication_socket.close
		ensure
			communication_socket.is_closed
		end

end
