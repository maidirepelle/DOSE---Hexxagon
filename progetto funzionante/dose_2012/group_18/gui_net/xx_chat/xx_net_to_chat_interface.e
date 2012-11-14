note
	description: "Interface between net and chat"
	author: "Team Milano2"
	date: "13-11-2012"
	revision: "0.2"

deferred class
	XX_NET_TO_CHAT_INTERFACE

feature --Deferred method to send messages

	-- Sets the chat message to be displayed
	set_chat_message(a_chat_message: STRING)
	require
		chat_message_not_void: a_chat_message/=Void
		chat_message_not_empty: a_chat_message.is_empty = FALSE
	deferred
	ensure
		chat_message_is_visible: not a_chat_message.is_equal ("")
	end
end
