note
	description: "Summary description for {BS_NET_AGENT_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BS_NET_AGENT_SET

create
	make

feature -- Constructor

	make (pmt_machine_connected_agent: PROCEDURE [ANY, TUPLE [BS_NET_MACHINE]]; pmt_machine_disconnected_agent: PROCEDURE [ANY, TUPLE [BS_NET_MACHINE]]; pmt_add_player_agent: PROCEDURE [ANY, TUPLE [BS_NET_MACHINE, STRING, INTEGER]]; pmt_remove_player_agent: PROCEDURE [ANY, TUPLE [BS_NET_MACHINE, INTEGER]])
		do
			machine_connected_agent := pmt_machine_connected_agent
			machine_disconnected_agent := pmt_machine_disconnected_agent
			add_player_agent := pmt_add_player_agent
			remove_player_agent := pmt_remove_player_agent
		end

feature -- Agents

	machine_connected_agent: PROCEDURE [ANY, TUPLE [BS_NET_MACHINE]]

	machine_disconnected_agent: PROCEDURE [ANY, TUPLE [BS_NET_MACHINE]]

	add_player_agent: PROCEDURE [ANY, TUPLE [BS_NET_MACHINE, STRING, INTEGER]] -- Machine, name, type

	remove_player_agent: PROCEDURE [ANY, TUPLE [BS_NET_MACHINE, INTEGER]] -- ID

end
