note
	description: "interface ogf socket connection."
	author: "Team Milano2"
	date: "11-12-2012"
	revision: "0.3"

deferred class
	XX_SOCKET_INTERFACE

inherit
	THREAD

	SED_STORABLE_FACILITIES
	export
		{NONE} all
	end

feature --Deferred Method

	--Writes
	write(a_message: ANY)
	require
		message_not_void: a_message/=Void
	deferred
	end

	--Closes the thread
	close
	deferred
	end

feature{NONE}
	--Loop that listens the stream
	listening
	deferred
	end

	--Create socket agents
	create_socket_agents
	deferred
	end

end
