note
	description: "This is the interface for the CP_CLIENT part of the NET component."
	author: "Christos Petropoulos"

class
	CP_CLIENT

inherit

	SOCKET_RESOURCES

create

	make

feature -- Attributes

	game_started: BOOLEAN
	is_connected: BOOLEAN
	socket : NETWORK_STREAM_SOCKET

feature	-- Initialization

	make(ip_address:STRING;)
			-- Connect to a server
		require
			connection_status: is_connected = FALSE
			ip_address_not_void: ip_address/=Void
		do

		ensure
			connnection_status: is_connected = TRUE
		end

	process()
			-- Listening for any message
		do

		end

feature	-- Actions

	start_game
			-- The message that the client sends to the server
			-- to ensure that he agrees to start the game.
		require
			connection_status: is_connected = TRUE
			game_has_not_started: game_started = FALSE
		do

		ensure
			game_has_strated: game_started = TRUE
		end

	send_message(player: CP_PLAYER; message: STRING)
			-- Send a message to the other player
		require
			player_not_void: player/=Void
			message_not_void: message/= Void
			message_not_empty: message/=""
			player_is_connected: is_connected = TRUE
		do

		end

	send_move(move: CP_POSITION; insect: CP_INSECT)
			-- Send the move you did to the other player
		require
			move_not_void: move/=Void
			insect_not_void: insect/=Void
			player_is_connected: is_connected = TRUE
			game_has_started:game_started = TRUE
		do

		end

	post_message(message:CP_MESSAGE;)
			-- Send to the GUI the message
		require
			message_not_void: message/=Void
			player_is_connected: is_connected = TRUE
		do

		end

	apply_move(game_msg:CP_GAMEMESSAGE;board:ARRAY[CP_INSECT])
			-- Applies the move that the client received
		require
			game_msg_not_void: game_msg/=Void
			board_not_void: board/=Void
			player_is_connected: is_connected = TRUE
			game_has_started:game_started = TRUE
		do

		end


feature -- Actions for connection

	disconnect
		require
			connected_to_server: is_connected/=FALSE
		do

		ensure
			disconnected_from_server: is_connected=FALSE
		end


end