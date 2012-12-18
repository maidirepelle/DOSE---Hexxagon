note
	description: "Main window for this application"
	author: "Generated by the New Vision2 Application Wizard."
	date: " 2012/12/12  "
	revision: "1.0.1"

class
	G2_GUI_MAIN_MENU

inherit

	G2_GUI_IMAIN_MENU
		undefine
			copy,
			default_create
		end

	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	INTERFACE_NAMES
		export
			{NONE} all
		undefine
			default_create,
			copy
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}
			create board.default_create
			board.show
			board.set_main_menu (Current)

				--create main_conteiner
			build_main_fixed
			extend (main_container)

				--event button
			b_new_game.select_actions.extend (agent host_game)
			b_join_game.select_actions.extend (agent join_game)
			b_help_game.select_actions.extend (agent help_game)
			b_close_game.select_actions.extend (agent close)
			close_request_actions.extend (agent close)

				-- Set the title of the window
			set_title (Window_title)

				-- Set the initial size of the window
			disable_user_resize
			set_size (Window_width, Window_height)
		end

	is_in_default_state: BOOLEAN
			-- Is the window in its default state
			-- (as stated in `initialize')
		do
			Result := (width = Window_width) and then (height = Window_height) and then (title.is_equal (Window_title))
		end

feature {NONE} -- Implementation/creates the window main_menu

		-- Main container (contains all widgets displayed in this window)

	build_main_fixed
			-- Create and populate `main_container'.
		require
			main_container_not_yet_created: main_container = Void
		do
			create main_container

				--load image background
			build_image

				--load button
			build_button

				--extend main_conteiner
			main_container.extend (b_new_game)
			main_container.extend (b_join_game)
			main_container.extend (b_help_game)
			main_container.extend (b_close_game)

				--set position button
			set_position_button
		ensure
			main_container_created: main_container /= Void
		end

feature {NONE} -- implementation / creates button and image

	build_button
		do
				-- create b_new_game
			create b_new_game
			b_new_game.set_text ({INTERFACE_NAMES}.button_new_game)

				-- create b_join_game
			create b_join_game
			b_join_game.set_text ({INTERFACE_NAMES}.button_join_game)

				-- create b_help_game
			create b_help_game
			b_help_game.set_text ({INTERFACE_NAMES}.Button_help_game)

				-- create b_close_game
			create b_close_game
			b_close_game.set_text ({INTERFACE_NAMES}.button_close_game)
		end

	build_image
		do
			create i_image_background
			i_image_background.set_with_named_file ({INTERFACE_NAMES}.path_main_menu_background)
			main_container.set_background_pixmap (i_image_background)
		end

feature {NONE} --Implementation / set position button

	set_position_button
		do
				--set position Button  New Game
			main_container.set_item_position_and_size (b_new_game, 0140, 0280, 0080, 0020)

				--set position Button  Join Game
			main_container.set_item_position_and_size (b_join_game, 0240, 0280, 0080, 0020)

				--set position Button  Help Game
			main_container.set_item_position_and_size (b_help_game, 0340, 0280, 0080, 0020)

				--set position Button Close Game
			main_container.set_item_position_and_size (b_close_game, 0440, 0280, 0080, 0020)
		end

feature -- events buttons

	host_game
			--opens the window to create new game
		do
			master := True
			create w_new_game
			w_new_game.set_main_menu (Current)
			w_new_game.show
		end

	join_game
			--opens the window to join the game.
		do
			create w_join_game
			w_join_game.set_main_menu (Current)
			w_join_game.show
		end

	help_game
			--opens the  help window game.
		do
			create w_help_game
			w_help_game.set_main_menu (Current)
			w_help_game.show
		end

	close
			--close windows
		local
			dialog: EV_CONFIRMATION_DIALOG
		do
			create dialog.make_with_text ("Are you sure you want to quit the game ? ")
			dialog.show_modal_to_window (Current)
			if (dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok)) then
				destroy
			end
		end

feature --basic operation

	set_window (window_1: MAIN_WINDOW)
			--save one instance main_ui
		do
			window := window_1
		end

	set_logic (logic_1: G2_LOGIC_LOGIC)
			--save logic
		do
			logic := logic_1
		end

	set_board (state: G2_LOGIC_STATE)
			--set board the game
		local
			cell_new: G2_GUI_CELL
			card_new: G2_GUI_CARD
			row, col: INTEGER
			matriz: ARRAY2 [G2_GUI_CELL]
			player_1, player_2: ARRAY [G2_GUI_CARD]
		do
				--set the board game
			if (amount > 0 or logic.g2_elemental) then

					--convert matriz the G2_LOGIC_MATRIX to matriz the G2_GUI_CELL
				create matriz.make_filled (Void, 3, 3)
				from
					row := 1
				until
					row > 3
				loop
					from
						col := 1
					until
						col > 3
					loop
						if (state.g2_matrix.item (row, col).g2_matrix_card /= Void) then
							create card_new.make_gui_card (state.g2_matrix.item (row, col).g2_matrix_card.g2_card_color, state.g2_matrix.item (row, col).g2_matrix_card.g2_card_levelup, state.g2_matrix.item (row, col).g2_matrix_card.g2_card_leveldown, state.g2_matrix.item (row, col).g2_matrix_card.g2_card_levelleft, state.g2_matrix.item (row, col).g2_matrix_card.g2_card_levelright, state.g2_matrix.item (row, col).g2_matrix_card.g2_card_element)
							card_new.set_board_game (board)
							create cell_new.make_gui_cell_1 (row, col, card_new, state.g2_matrix.item (row, col).g2_matrix_element)
							matriz.put (cell_new, row, col)
						end
						col := col + 1
					end
					row := row + 1
				end
				board.set_board_game (matriz)
			end

				--set the game players
			if (master) then
				create player_1.make_filled (Void, 1, 5)
					--convert card G2_LOGIC_CARD to card G2_GUI_CARD
				from
					row := 1
				until
					row > 5
				loop
					if (state.g2_player1.at (row) /= Void) then
						create card_new.make_gui_card (state.g2_player1.at (row).g2_card_color, state.g2_player1.at (row).g2_card_levelup, state.g2_player1.at (row).g2_card_leveldown, state.g2_player1.at (row).g2_card_levelleft, state.g2_player1.at (row).g2_card_levelright, state.g2_player1.at (row).g2_card_element)
						card_new.set_board_game (board)
						player_1.put (card_new, row)
					end
					row := row + 1
				end
				board.set_card_player1 (player_1)
				board.set_score_player_1 (state.g2_player1_number_cards)
				if (logic.g2_open) then
					create player_2.make_filled (Void, 1, 5)
						--convert card G2_LOGIC_CARD to card G2_GUI_CARD
					from
						row := 1
					until
						row > 5
					loop
						if (state.g2_player2.at (row) /= Void) then
							create card_new.make_gui_card (state.g2_player2.at (row).g2_card_color, state.g2_player2.at (row).g2_card_levelup, state.g2_player2.at (row).g2_card_leveldown, state.g2_player2.at (row).g2_card_levelleft, state.g2_player2.at (row).g2_card_levelright, state.g2_player2.at (row).g2_card_element)
							card_new.set_board_game (board)
							player_2.put (card_new, row)
						end
						row := row + 1
					end
					board.set_card_player2 (player_2)
				end
				board.set_score_player_2 (state.g2_player2_number_cards)
				board.block_card_player_2
			else
				create player_2.make_filled (Void, 1, 5)
					--convert card G2_LOGIC_CARD to card G2_GUI_CARD
				from
					row := 1
				until
					row > 5
				loop
					if (state.g2_player2.at (row) /= Void) then
						create card_new.make_gui_card (state.g2_player2.at (row).g2_card_color, state.g2_player2.at (row).g2_card_levelup, state.g2_player2.at (row).g2_card_leveldown, state.g2_player2.at (row).g2_card_levelleft, state.g2_player2.at (row).g2_card_levelright, state.g2_player2.at (row).g2_card_element)
						card_new.set_board_game (board)
						player_2.put (card_new, row)
					end
					row := row + 1
				end
				board.set_card_player2 (player_2)
				board.set_score_player_2 (state.g2_player2_number_cards)
				if (logic.g2_open) then
					create player_1.make_filled (Void, 1, 5)
						--convert card G2_LOGIC_CARD to card G2_GUI_CARD
					from
						row := 1
					until
						row > 5
					loop
						if (state.g2_player1.at (row) /= Void) then
							create card_new.make_gui_card (state.g2_player1.at (row).g2_card_color, state.g2_player1.at (row).g2_card_levelup, state.g2_player1.at (row).g2_card_leveldown, state.g2_player1.at (row).g2_card_levelleft, state.g2_player1.at (row).g2_card_levelright, state.g2_player1.at (row).g2_card_element)
							card_new.set_board_game (board)
							player_1.put (card_new, row)
						end
						row := row + 1
					end
					board.set_card_player1 (player_1)
				end
				board.set_score_player_1 (state.g2_player1_number_cards)
				board.block_card_player_1
			end
			amount := 1
			board.set_turn_player_1 (state.g2_player)
			board.set_turn_player_2 (not state.g2_player)
			board.refresh_now
		end

	get_inform_disconnect
			-- disconnect the game
		do
			logic.quit
		end

	get_inform_game
			-- return info the play card
		do
			logic.play_card (create {G2_LOGIC_CARD}.make (card.color, card.element.element, card.north, card.south, card.east, card.west), row_x, col_y)
		end

	get_inform_new_game
			-- return info the connection host
		do
			logic.create_new_game (true)
			logic.run_game
		end

	get_inform_join_game
			-- return info the connection join
		do
			logic.create_new_game (false)
			logic.run_game
		end

	on_win
			--dialog Win
		local
			win_dialog: USER_INFO_DIALOG
		do
			create win_dialog.make ({INTERFACE_NAMES}.Path_main_menu_win, "WIN", " You are a Win!")
			win_dialog.show_modal_to_window (current)
			board.hide
		end

	on_lose
			--dialog Loser
		local
			lose_dialog: USER_INFO_DIALOG
		do
			create lose_dialog.make ({INTERFACE_NAMES}.Patch_main_menu_loser, "LOSER", " You are a Loser!")
			lose_dialog.show_modal_to_window (current)
			board.hide
		end

	on_draw
			--dialog Draw
		local
			draw_dialog: USER_INFO_DIALOG
		do
			create draw_dialog.make ({INTERFACE_NAMES}.Path_main_menu_draw, "DRAW", " You are a Draw!")
			draw_dialog.show_modal_to_window (current)
		end

feature {G2_GUI_JOIN_GAME, G2_GUI_HOST_GAME} -- Implementation the info_connectioni

	set_ip (ip_1: STRING)
			--set ip
		do
			ip := ip_1
		end

	set_port (port_1: INTEGER)
			--set port
		do
			port := port_1
		end

feature {ANY}

	set_rules (rules_1: ARRAY [BOOLEAN])
			--set rules
		do
			rules := rules_1
		end

	block_board
			-- blocks the board game
		do
			board.block_board
		end

	unblock_board
			-- unblocks the board game
		do
			board.unblock_board
		end

	resfresh_board
			--resfressh the board
		do
			board.refresh_now
		end

feature {G2_GUI_BOARD_GAME} -- implementation play card

	set_move (card_1: G2_GUI_CARD; row_1, col_1: INTEGER)
			--save the move
		do
			card := card_1
			row_x := row_1
			col_y := col_1
		end

feature {ANY} --attribute connection and play card

	ip: STRING

	port: INTEGER

	rules: ARRAY [BOOLEAN]

	card: G2_GUI_CARD

	row_x, col_y: INTEGER

feature {NONE} -- Implementation

	amount: INTEGER

	main_container: EV_FIXED

	b_new_game, b_join_game, b_help_game, b_close_game: EV_BUTTON

	i_image_background: EV_PIXMAP

	w_new_game: G2_GUI_HOST_GAME

	w_join_game: G2_GUI_JOIN_GAME

	w_help_game: G2_GUI_HELP_GAME

	board: G2_GUI_BOARD_GAME

	logic: G2_LOGIC_LOGIC

	master: BOOLEAN

	window: MAIN_WINDOW

feature {NONE} -- Implementation / Constants

	Window_title: STRING = "Main_Menu"
			-- Title of the window.

	Window_width: INTEGER = 600
			-- Initial width for this window.

	Window_height: INTEGER = 350
			-- Initial height for this window.

end
