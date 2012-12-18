note
	description: "Summary description for {G1_UI_GAMEBOARD}."
	author: "MILANO7"
	date: "10/11/2012"
	revision: "1.0"

class
	G1_UI_GAMEBOARD
	--- It's a Graphical Inteface

inherit
    EV_TITLED_WINDOW
		redefine
			initialize
		end

	G1_UI_CONSTANTS
	    export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make

feature {NONE}	-- Attributes

    main_ui: MAIN_WINDOW
    controller: G1_UI_CONTROLLER

    monopoly_gameboard_area: EV_FIXED
    monopoly_game_area : EV_FIXED
    monopoly_logo_area: EV_FIXED

    dice_first : EV_FIXED
    dice_second : EV_FIXED
    dice_one : INTEGER
    dice_two : INTEGER

	token_one : EV_FIXED
	token_two : EV_FIXED
	token_three : EV_FIXED
	token_four : EV_FIXED
	token_five : EV_FIXED
	token_six : EV_FIXED

	label_token_one_position : EV_LABEL
	label_token_two_position : EV_LABEL
	label_token_three_position : EV_LABEL
	label_token_four_position : EV_LABEL
	label_token_five_position : EV_LABEL
	label_token_six_position : EV_LABEL

    player_information: G1_UI_PLAYER_INFORMATION
    other_player_information: G1_UI_PLAYER_INFORMATION

    combo_box_total_players: EV_COMBO_BOX
    label_players : EV_LABEL
    label_turn_player : EV_LABEL
    label_current_player : EV_LABEL

    btn_roll_dice : EV_BUTTON
    btn_houses_hotels : EV_BUTTON
    btn_trade : EV_BUTTON
    btn_pass : EV_BUTTON

    cell : G1_CELL

    players_combo_box: HASH_TABLE [INTEGER, INTEGER]  -- id,key

feature {NONE} -- Initialization

	make(a_main_ui_window: MAIN_WINDOW; a_controller: G1_UI_CONTROLLER)
	do
		main_ui := a_main_ui_window
		controller := a_controller
		make_with_title (Window_title)
		disable_user_resize
	end

	initialize
		do
				Precursor {EV_TITLED_WINDOW}
				close_request_actions.extend (agent request_close_window(main_ui,current))
				controller.set_current_gui(Current)

				monopoly_gameboard_area := set_background(mp_img_load("background_gameboard.png"),0,0);
				monopoly_logo_area := set_background(mp_img_load("logo_monopoly2.png"),370,80);
				monopoly_gameboard_area.extend_with_position_and_size (monopoly_logo_area, 995, 0, 370, 80)
				create player_information.make (controller.get_player)
                monopoly_gameboard_area.extend_with_position_and_size (player_information, 995, 85, 370, 250)

                monopoly_game_area := set_background(mp_img_load("monopoly_gameboard.png"),650,650);
                monopoly_gameboard_area.extend_with_position_and_size (monopoly_game_area, 0, 0,650,650)

				create label_players
				label_players.set_background_color (GREEN)
                label_players.set_text ("Player: ")
				label_players.align_text_center
				monopoly_gameboard_area.extend_with_position_and_size (label_players, 995,350,100,30)

                -- per ora che non c'� tutta la logica+net, altrimenti update_combo_box
				create combo_box_total_players.make_with_strings (<<"0", "1", "2", "3">>)
				combo_box_total_players.disable_edit
				monopoly_gameboard_area.extend_with_position_and_size (combo_box_total_players, 1100, 350, 80, 24)
				combo_box_total_players.select_actions.extend (agent view_player_information)

				create label_turn_player
		        label_turn_player.set_background_color (GREEN)
		        label_turn_player.set_text ("Turn: ")
			    label_turn_player.align_text_center
		     	monopoly_gameboard_area.extend_with_position_and_size (label_turn_player, 670, 20, 50, 30)

		     	create label_current_player
		     	label_current_player.set_background_color (GREEN)
		  	    label_current_player.set_text ("")
			    label_turn_player.align_text_center
		     	monopoly_gameboard_area.extend_with_position_and_size (label_current_player, 720, 20, 60, 30)

				create btn_roll_dice.make_with_text ("Roll Dice")
				monopoly_gameboard_area.extend_with_position_and_size (btn_roll_dice, 60, 690, 80, 30)
				btn_roll_dice.select_actions.extend (agent roll_dice)

				create btn_houses_hotels.make_with_text ("Manage Houses&Hotels")
				monopoly_gameboard_area.extend_with_position_and_size (btn_houses_hotels, 180, 690, 150, 30)
				btn_houses_hotels.select_actions.extend (agent manage_houses_hotels)

				create btn_trade.make_with_text ("Trade")
				monopoly_gameboard_area.extend_with_position_and_size (btn_trade, 370, 690, 80, 30)
				btn_trade.select_actions.extend (agent trade)

				create btn_pass.make_with_text ("Pass")
				monopoly_gameboard_area.extend_with_position_and_size (btn_pass, 490, 690, 80, 30)
				btn_pass.select_actions.extend (agent pass)

				extend(monopoly_gameboard_area)
		end

	view_token(players_list: HASH_TABLE [STRING, INTEGER])
		do
			if players_list.has (1) then
				token_one := set_background(mp_img_load("monopoly_token_dog.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (token_one, 670, 80,50,50)
                create label_token_one_position
				label_token_one_position.set_background_color (GREEN)
                label_token_one_position.set_text ("")
				label_token_one_position.align_text_center
				monopoly_gameboard_area.extend_with_position_and_size (label_token_one_position, 730,95,120,20)
            end
			if players_list.has (2) then
				token_two := set_background(mp_img_load("monopoly_token_car.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (token_two, 670, 140,50,50)
                create label_token_two_position
				label_token_two_position.set_background_color (GREEN)
                label_token_two_position.set_text ("")
				label_token_two_position.align_text_center
				monopoly_gameboard_area.extend_with_position_and_size (label_token_two_position, 730,155,120,20)
            end
			if players_list.has (3) then
				token_three := set_background(mp_img_load("monopoly_token_hat.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (token_three, 670, 200,50,50)
                create label_token_three_position
				label_token_three_position.set_background_color (GREEN)
                label_token_three_position.set_text ("")
				label_token_three_position.align_text_center
				monopoly_gameboard_area.extend_with_position_and_size (label_token_three_position, 730,215,120,20)
            end
			if players_list.has (4) then
				token_four := set_background(mp_img_load("monopoly_token_ship.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (token_four, 670, 260,50,50)
                create label_token_four_position
				label_token_four_position.set_background_color (GREEN)
                label_token_four_position.set_text ("")
				label_token_four_position.align_text_center
				monopoly_gameboard_area.extend_with_position_and_size (label_token_four_position, 730,275,120,20)
            end
			if players_list.has (5) then
				token_five := set_background(mp_img_load("monopoly_token_iron.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (token_five, 670, 320,50,50)
                create label_token_five_position
				label_token_five_position.set_background_color (GREEN)
                label_token_five_position.set_text ("")
				label_token_five_position.align_text_center
				monopoly_gameboard_area.extend_with_position_and_size (label_token_five_position, 730,335,120,20)
            end
			if players_list.has (6) then
				token_six := set_background(mp_img_load("monopoly_token_boot.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (token_six, 670, 390,50,50)
                create label_token_six_position
				label_token_six_position.set_background_color (GREEN)
                label_token_six_position.set_text ("")
				label_token_six_position.align_text_center
				monopoly_gameboard_area.extend_with_position_and_size (label_token_six_position, 730,405,120,20)
           	end
		end


feature {NONE} -- Implementation creation combo_box

		--This feature is used to initialize the combo_box
	update_combo_box
		local
			number_of_players, myID, a,b,c,d,e : INTEGER
	do
		 number_of_players := controller.get_players_list.count
		 myID := controller.get_player.id_player
		 if number_of_players = 2 then
		 	if myID = 1 then
		 		a := 2
		 	else
		 		a := 1
		 	end
		 	create combo_box_total_players.default_create
			combo_box_total_players.set_strings (<<controller.get_players_list.item (a)>>)
			combo_box_total_players.disable_edit
			monopoly_gameboard_area.extend_with_position_and_size (combo_box_total_players, 1100, 350, 80, 24)
			players_combo_box.extend (a,1)
			combo_box_total_players.select_actions.extend (agent view_player_information)
		elseif number_of_players = 3 then
			if myID = 1 then
				a := 2
				b := 3
			elseif myID = 2 then
				a := 1
				b := 3
			else
				a := 1
				b := 2
			end
			create combo_box_total_players.default_create
			combo_box_total_players.set_strings (<<controller.get_players_list.item (a),controller.get_players_list.item (b)>>)
			combo_box_total_players.disable_edit
			monopoly_gameboard_area.extend_with_position_and_size (combo_box_total_players, 1100, 350, 80, 24)
			players_combo_box.extend (a,1)
			players_combo_box.extend (b,2)
			combo_box_total_players.select_actions.extend (agent view_player_information)
		elseif number_of_players = 4 then
			if myID = 1 then
				a := 2
				b := 3
				c := 4
			elseif myID = 2 then
				a := 1
				b := 3
				c := 4
			elseif myID = 3 then
				a := 1
				b := 2
				c := 4
			else
				a := 1
				b := 2
				c := 3
			end
		 	create combo_box_total_players.default_create
			combo_box_total_players.set_strings (<<controller.get_players_list.item (a),controller.get_players_list.item (b),controller.get_players_list.item (c)>>)
			combo_box_total_players.disable_edit
			monopoly_gameboard_area.extend_with_position_and_size (combo_box_total_players, 1100, 350, 80, 24)
			players_combo_box.extend (a,1)
			players_combo_box.extend (b,2)
			players_combo_box.extend (c,3)
			combo_box_total_players.select_actions.extend (agent view_player_information)
		elseif number_of_players = 5 then
			if myID = 1 then
				a := 2
				b := 3
				c := 4
				d := 5
			elseif myID = 2 then
				a := 1
				b := 3
				c := 4
				d := 5
			elseif myID = 3 then
				a := 1
				b := 2
				c := 4
				d := 5
			elseif myID = 4 then
				a := 1
				b := 2
				c := 3
				d := 5
			else
				a := 1
				b := 2
				c := 3
				d := 4
			end
			create combo_box_total_players.default_create
			combo_box_total_players.set_strings (<<controller.get_players_list.item (a),controller.get_players_list.item (b),controller.get_players_list.item (c),controller.get_players_list.item (d)>>)
			combo_box_total_players.disable_edit
			monopoly_gameboard_area.extend_with_position_and_size (combo_box_total_players, 1100, 350, 80, 24)
			players_combo_box.extend (a,1)
			players_combo_box.extend (b,2)
			players_combo_box.extend (c,3)
			players_combo_box.extend (d,4)
			combo_box_total_players.select_actions.extend (agent view_player_information)
		elseif number_of_players = 6 then
			if myID = 1 then
				a := 2
				b := 3
				c := 4
				d := 5
				e := 6
			elseif myID = 2 then
				a := 1
				b := 3
				c := 4
				d := 5
				e := 6
			elseif myID = 3 then
				a := 1
				b := 2
				c := 4
				d := 5
				e := 6
			elseif myID = 4 then
				a := 1
				b := 2
				c := 3
				d := 5
				e := 6
			elseif myID = 5 then
				a := 1
				b := 2
				c := 3
				d := 4
				e := 6
			else
				a := 1
				b := 2
				c := 3
				d := 4
				e := 5
			end
			create combo_box_total_players.default_create
			combo_box_total_players.set_strings (<<controller.get_players_list.item (a),controller.get_players_list.item (b),controller.get_players_list.item (c),controller.get_players_list.item (d),controller.get_players_list.item (e)>>)
			combo_box_total_players.disable_edit
			monopoly_gameboard_area.extend_with_position_and_size (combo_box_total_players, 1100, 350, 80, 24)
			players_combo_box.extend (a,1)
			players_combo_box.extend (b,2)
			players_combo_box.extend (c,3)
			players_combo_box.extend (d,4)
			players_combo_box.extend (e,5)
			combo_box_total_players.select_actions.extend (agent view_player_information)
		 end
	end

feature {NONE} -- Implementation features buttons and combo_box

	roll_dice
		do
			btn_houses_hotels.enable_capture
    		btn_trade.enable_capture
    		btn_pass.enable_capture
			cell := controller.roll_dice
		end

	manage_houses_hotels
			-- open the popup_manage_properties
		local
			manage_popup : G1_UI_POPUP_MANAGE_PROPERTIES
		do
			create manage_popup.make(controller)
		    manage_popup.show
		end

	trade
			-- open the popup_trade
		local
			trade_popup : G1_UI_POPUP_TRADE
		do
		    create trade_popup.make(controller)
			trade_popup.show
		end

	pass
			-- pass turn to next player
		do
			controller.finish_turn
		end

	view_player_information

		local
			k, id : INTEGER
			l_other_player : G1_PLAYER
		do
		--	k := combo_box_total_players.caret_position
		--	id := players_combo_box.item (k)
			l_other_player := controller.ask_player (id)
			create l_other_player.make (2, "giocatore")         -- solo per ora
			create other_player_information.make(l_other_player)
        	monopoly_gameboard_area.extend_with_position_and_size (other_player_information, 995, 400, 370, 250)
        	other_player_information.update_situation(l_other_player)
		end

feature {ANY} -- Implementation features called by other GUI classes

	set_turn(a_name : STRING; my_turn : BOOLEAN; i_am_in_jail : BOOLEAN)
		local
			jail_popup : G1_UI_POPUP_JAIL
		do
			label_current_player.set_text (a_name)
			if my_turn and i_am_in_jail then
				create jail_popup.make(controller)
				jail_popup.show
			elseif my_turn then
				btn_roll_dice.enable_capture
    		else
    			btn_roll_dice.disable_capture
    			btn_houses_hotels.disable_capture
    			btn_trade.disable_capture
    			btn_pass.disable_capture
			end
		end

	update_dice(dice_1,dice_2 : INTEGER)
		do
			dice_one := dice_1
			dice_two := dice_2

			if dice_one = 1 then
				dice_first := set_background(mp_img_load("dice_one.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_first, 810, 10,50,50)
			elseif dice_one = 2 then
				dice_first := set_background(mp_img_load("dice_two.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_first, 810, 10,50,50)
			elseif dice_one = 3 then
				dice_first := set_background(mp_img_load("dice_three.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_first, 810, 10,50,50)
			elseif dice_one = 4 then
				dice_first := set_background(mp_img_load("dice_four.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_first, 810, 10,50,50)
			elseif dice_one = 5 then
				dice_first := set_background(mp_img_load("dice_five.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_first, 810, 10,50,50)
			elseif dice_one = 6 then
				dice_first := set_background(mp_img_load("dice_six.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_first, 810, 10,50,50)
			end

			if dice_two = 1 then
				dice_second := set_background(mp_img_load("dice_one.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_second, 880, 10,50,50)
			elseif dice_two = 2 then
				dice_second := set_background(mp_img_load("dice_two.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_second, 880, 10,50,50)
			elseif dice_two = 3 then
				dice_second := set_background(mp_img_load("dice_three.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_second, 880, 10,50,50)
			elseif dice_two = 4 then
				dice_second := set_background(mp_img_load("dice_four.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_second, 880, 10,50,50)
			elseif dice_two = 5 then
				dice_second := set_background(mp_img_load("dice_five.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_second, 880, 10,50,50)
			elseif dice_two = 6 then
				dice_second := set_background(mp_img_load("dice_six.png"),50,50);
                monopoly_gameboard_area.extend_with_position_and_size (dice_second, 880, 10,50,50)
			end
		end

	update_position_player(position : STRING; id_player : INTEGER)
		do
			if id_player = 1 then
				label_token_one_position.set_text (position)
			elseif id_player = 2 then
				label_token_two_position.set_text (position)
			elseif id_player = 3 then
				label_token_three_position.set_text (position)
			elseif id_player = 4 then
				label_token_four_position.set_text (position)
			elseif id_player = 5 then
				label_token_five_position.set_text (position)
			elseif id_player = 6 then
				label_token_six_position.set_text (position)
			end
		end

	view_cell
		local
			std_popup : G1_UI_POPUP_STD
			special_popup : G1_UI_POPUP_SPECIAL
		do
			if attached {G1_STREET} cell as cell_street  then
				create std_popup.make_property (controller, cell_street)
				std_popup.show
			elseif attached {G1_RAILWAY} cell as cell_railway then
				create std_popup.make_deed (controller, cell_railway)
				std_popup.show
     		elseif attached {G1_UTILITY} cell as cell_utility then
				create std_popup.make_deed (controller, cell_utility)
				std_popup.show
			elseif attached {G1_NON_DEED} cell as cell_non_deed	then
				create special_popup.make (controller, cell_non_deed)
				special_popup.show
			end
		end

	show_trade_request
		local
			trade_request_popup : G1_UI_POPUP_TRADEREQUEST
		do
			create trade_request_popup.make (controller)
			trade_request_popup.show
		end

	update_buy_or_unmortgage_my_ui_player_information(a_id:INTEGER)
		do
			player_information.update_buy(a_id)
			player_information.update_money (controller.get_player.money)
		end

	update_jail_card_my_ui_player_information(card: INTEGER; condition: BOOLEAN)
		do
			if card = 0 then
				player_information.update_card_get_out_of_jail_community(condition)
			else
				player_information.update_card_get_out_of_jail_chance(condition)
			end
		end

	update_mortgage_my_ui_player_information(a_id:INTEGER)
		do
			player_information.update_mortgage (a_id)
			player_information.update_money (controller.get_player.money)
		end

	update_money_my_ui_player()
		do
			player_information.update_money (controller.get_player.money)
		end
end
