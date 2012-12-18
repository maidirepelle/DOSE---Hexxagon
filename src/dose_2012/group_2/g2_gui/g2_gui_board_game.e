note
	description: "Main window for this application"
	author: "Generated by the New Vision2 Application Wizard."
	date: " 2012/12/12  "
	revision: "1.0.1"

class
	G2_GUI_BOARD_GAME

inherit

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
				--initialize color
			create color_blue.make_with_8_bit_rgb (29, 49, 226)
			create color_green.make_with_8_bit_rgb (0, 255, 0)
			create color_red.make_with_8_bit_rgb (255, 0, 0)
			create color_morrow.make_with_8_bit_rgb (155, 78, 0)
			create card_captured.make_default
			build_main_container
			extend (main_container)
				-- Set the title of the window
			set_title (Window_title)
			b_disconnect.select_actions.extend (agent disconnect)
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

feature {NONE} -- Implementation

	get_font_board (size_font: INTEGER): EV_FONT
			-- build font
		require
			size_positive: size_font > 0
		local
			internal_font: EV_FONT
		do
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_typewriter)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_bold)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (size_font)
			internal_font.preferred_families.extend ("Comic Sans MS")
			Result := internal_font
		ensure
			font_not_void: Result /= Void
		end

	build_main_container
			-- Create and populate `main_container'.
		require
			main_container_not_yet_created: main_container = Void
		do
			create main_container
				--create fixed player
			build_fixed_player_1
			build_fixed_board
			build_fixed_player_2
				--put fixed player
			main_container.extend (f_fixed_player1)
			main_container.extend (f_fixed_board)
			main_container.extend (f_fixed_player2)
			set_image_background
		ensure
			main_container_created: main_container /= Void
		end

	build_fixed_player_1
		do
			create f_fixed_player1
				-- set background
				--create object fixed_player1
			build_object_player_1
				-- put object at fixed
			f_fixed_player1.extend (l_turn1)
			f_fixed_player1.extend (b_player1_card1)
			f_fixed_player1.extend (b_player1_card2)
			f_fixed_player1.extend (b_player1_card3)
			f_fixed_player1.extend (b_player1_card4)
			f_fixed_player1.extend (b_player1_card5)
			f_fixed_player1.extend (l_score_player_1)
				--set position object
			set_position_object_player_1
				--set turn
			set_turn_player_1 (true)
				--set score
			set_score_player_1 (0)
		end

	build_fixed_board
			--create fixed board
		local
			cell: G2_GUI_CELL
			row, col: INTEGER
		do
			create f_fixed_board
			build_object_board
			f_fixed_board.extend (l_title)
			f_fixed_board.extend (table_board_game)

				--make table
			table_board_game.resize (3, 3)
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

						-- the button was not created
					create cell.make_gui_cell (row, col)
					cell.set_board_game (current)
					cell.pointer_button_press_actions.extend (agent cell.on_click)
					table_board_game.put_at_position (cell, col, row, 1, 1)
					col := col + 1
				end
				row := row + 1
			end
			f_fixed_board.set_item_x_position (table_board_game, 0000)
			f_fixed_board.set_item_y_position (table_board_game, 0080)
			f_fixed_board.extend (b_disconnect)
			b_disconnect.set_text ("Disconnect")
			set_position_object_board
			set_title_board ("Triple Triad New Generation")
		end

	build_fixed_player_2
		do
			create f_fixed_player2
				-- set background
				--create object fixed_player2
			build_object_player_2
				-- put object at fixed
			f_fixed_player2.extend (l_turn2)
			f_fixed_player2.extend (b_player2_card1)
			f_fixed_player2.extend (b_player2_card2)
			f_fixed_player2.extend (b_player2_card3)
			f_fixed_player2.extend (b_player2_card4)
			f_fixed_player2.extend (b_player2_card5)
			f_fixed_player2.extend (l_score_player_2)
				--set position object
			set_position_object_player_2
			set_turn_player_2 (false)
			set_score_player_2 (0)
		end

	build_object_player_1
		do
				-- create button card1
			create b_player1_card1.make_default
			b_player1_card1.set_board_game (Current)
			b_player1_card1.pointer_button_press_actions.extend (agent b_player1_card1.on_click)
				-- create button card2
			create b_player1_card2.make_default
			b_player1_card2.set_board_game (Current)
			b_player1_card2.pointer_button_press_actions.extend (agent b_player1_card2.on_click)
				-- create button card3
			create b_player1_card3.make_default
			b_player1_card3.set_board_game (Current)
			b_player1_card3.pointer_button_press_actions.extend (agent b_player1_card3.on_click)
				-- create button card4
			create b_player1_card4.make_default
			b_player1_card4.set_board_game (Current)
			b_player1_card4.pointer_button_press_actions.extend (agent b_player1_card4.on_click)
				-- create button card5

			create b_player1_card5.make_default
			b_player1_card5.set_board_game (Current)
			b_player1_card5.pointer_button_press_actions.extend (agent b_player1_card5.on_click)
				-- create label score
			create l_score_player_1.default_create
				-- create label turn
			create l_turn1
		end

	build_object_board
		do
			create table_board_game
				-- create button disconnect
			create b_disconnect
				-- create label turn
			create l_title
		end

	build_object_player_2
		do
				-- create button card1
			create b_player2_card1.make_default
			b_player2_card1.set_board_game (Current)
			b_player2_card1.pointer_button_press_actions.extend (agent b_player2_card1.on_click)

				-- create button card2
			create b_player2_card2.make_default
			b_player2_card2.set_board_game (Current)
			b_player2_card2.pointer_button_press_actions.extend (agent b_player2_card2.on_click)

				-- create button card3
			create b_player2_card3.make_default
			b_player2_card3.set_board_game (Current)
			b_player2_card3.pointer_button_press_actions.extend (agent b_player2_card3.on_click)

				-- create button card4
			create b_player2_card4.make_default
			b_player2_card4.set_board_game (Current)
			b_player2_card4.pointer_button_press_actions.extend (agent b_player2_card4.on_click)

				-- create button card5
			create b_player2_card5.make_default
			b_player2_card5.set_board_game (Current)
			b_player2_card5.pointer_button_press_actions.extend (agent b_player2_card5.on_click)

				-- create label score
			create l_score_player_2
				-- create label turn
			create l_turn2
		end

	set_position_object_board
		do
				--set position label title
			f_fixed_board.set_item_position_and_size (l_title, 0080, 0020, 0272, 0040)
				--set position button disconnect
			f_fixed_board.set_item_position_and_size (b_disconnect, 0160, 0640, 0125, 0044)
		end

	set_position_object_player_1
		do
				--set position label l_turn
			f_fixed_player1.set_item_position_and_size (l_turn1, 0040, 0020, 0080, 0040)
				--set position button b_player1_card1
			f_fixed_player1.set_item_position_and_size (b_player1_card1, 0020, 0080, 0137, 0166)
				--set position button b_player1_card2
			f_fixed_player1.set_item_position_and_size (b_player1_card2, 0020, 0160, 0137, 0166)
				--set position button b_player1_card3
			f_fixed_player1.set_item_position_and_size (b_player1_card3, 0020, 0240, 0137, 0166)
				--set position button b_player1_card4
			f_fixed_player1.set_item_position_and_size (b_player1_card4, 0020, 0320, 0137, 0166)
				--set position button b_player1_card5
			f_fixed_player1.set_item_position_and_size (b_player1_card5, 0020, 0400, 0137, 0166)
				--set position label l_score_player_1
			f_fixed_player1.set_item_position_and_size (l_score_player_1, 0020, 0620, 0140, 0120)
		end

	set_position_object_player_2
		do
				--set position label l_turn
			f_fixed_player2.set_item_position_and_size (l_turn2, 0020, 0020, 0080, 0040)
				--set position button b_player2_card1
			f_fixed_player2.set_item_position_and_size (b_player2_card1, 0000, 0080, 0137, 0166)
				--set position button b_player2_card2
			f_fixed_player2.set_item_position_and_size (b_player2_card2, 0000, 0160, 0136, 0166)
				--set position button b_player2_card3
			f_fixed_player2.set_item_position_and_size (b_player2_card3, 0000, 0240, 0137, 0166)
				--set position button b_player2_card4
			f_fixed_player2.set_item_position_and_size (b_player2_card4, 0000, 0320, 0137, 0166)
				--set position button b_player2_card5
			f_fixed_player2.set_item_position_and_size (b_player2_card5, 0000, 0400, 0137, 0166)
				--set position label l_score_player_2
			f_fixed_player2.set_item_position_and_size (l_score_player_2, 0000, 0620, 0140, 0120)
		end

	set_title_board (title_board: STRING)
		do
			l_title.set_background_color (color_morrow)
			l_title.set_font (get_font_board (11))
			l_title.set_text (title_board)
		end

	set_image_background
		local
			internal_pixmap: EV_PIXMAP
		do
			create internal_pixmap
			internal_pixmap.set_with_named_file ({INTERFACE_NAMES}.path_background_players)
			f_fixed_player1.set_background_pixmap (internal_pixmap)
			internal_pixmap.set_with_named_file ({INTERFACE_NAMES}.path_background_players)
			f_fixed_board.set_background_pixmap (internal_pixmap)
			internal_pixmap.set_with_named_file ({INTERFACE_NAMES}.path_background_players)
			f_fixed_player2.set_background_pixmap (internal_pixmap)
		end

feature --set date the Board

	set_main_menu (w_main_menu_1: G2_GUI_MAIN_MENU)
			--save one instance the main_menu
		do
			w_main_menu := w_main_menu_1
		end

	disconnect
		do
			w_main_menu.get_inform_disconnect
			w_main_menu.show
			current.destroy
		end

	set_turn_player_1 (your_turn: BOOLEAN)
			--set the turn of the player 1
		do
			if (your_turn = true) then
				l_turn1.set_background_color (color_green)
			else
				l_turn1.set_background_color (color_red)
			end
		end

	set_turn_player_2 (your_turn: BOOLEAN)
			--set the turn of the player 2
		do
			if (your_turn = true) then
				l_turn2.set_background_color (color_green)
			else
				l_turn2.set_background_color (color_red)
			end
		end

	set_score_player_1 (value: INTEGER)
			--set the score of the player 1
		require
			value_positive: value >= 0
		do
			l_score_player_1.set_background_color (color_blue)
			l_score_player_1.set_font (get_font_board (60))
			l_score_player_1.set_text (value.out)
		end

	set_score_player_2 (value: INTEGER)
			--set the score of the player 2
		require
			value_positive: value >= 0
		do
			l_score_player_2.set_background_color (color_blue)
			l_score_player_2.set_font (get_font_board (60))
			l_score_player_2.set_text (value.out)
		end

	set_card_player1 (cards_1: ARRAY [G2_GUI_CARD])
			--set the card of the player 1
		do
			assig_card_or_destroy (b_player1_card1, cards_1.at (1))
			assig_card_or_destroy (b_player1_card2, cards_1.at (2))
			assig_card_or_destroy (b_player1_card3, cards_1.at (3))
			assig_card_or_destroy (b_player1_card4, cards_1.at (4))
			assig_card_or_destroy (b_player1_card5, cards_1.at (5))
		end

	set_card_player2 (cards_1: ARRAY [G2_GUI_CARD])
			--set the score of the player 2
		do
			assig_card_or_destroy (b_player2_card1, cards_1.at (1))
			assig_card_or_destroy (b_player2_card2, cards_1.at (2))
			assig_card_or_destroy (b_player2_card3, cards_1.at (3))
			assig_card_or_destroy (b_player2_card4, cards_1.at (4))
			assig_card_or_destroy (b_player2_card5, cards_1.at (5))
		end

	assig_card_or_destroy (card_1, card_2: G2_GUI_CARD)
			--set the card of the player or allows destroy card
		do
			if (card_2 = Void or card_1.is_destroyed) then
				card_1.destroy
			else
				card_1.set_card (card_2)
			end
		end

	set_board_game (matriz: ARRAY2 [G2_GUI_CELL])
			--set of the game table
		local
			row_1, col_1: INTEGER
		do
			from
				row_1 := 1
			until
				row_1 > 3
			loop
				from
					col_1 := 1
				until
					col_1 > 3
				loop
					if (attached {G2_GUI_CELL} table_board_game.item_at_position (col_1, row_1) as button) then
						if (matriz.item (row_1, col_1) /= void) then
							button.set_cell (matriz.item (row_1, col_1).card, matriz.item (row_1, col_1).element.element)
						end
					end
					col_1 := col_1 + 1
				end
				row_1 := row_1 + 1
			end
		end

	capture (card_1: G2_GUI_CARD)
		do
			card_captured := card_1
		end

	move (row_1, col_1: INTEGER)
			-- takes the card played
		local
			card_copy: G2_GUI_CARD
		do
			if (card_captured.board /= Void and not card_captured.is_destroyed) then
				if (attached {G2_GUI_CELL} table_board_game.item_at_position (col_1, row_1) as button) then
					if (not button.is_occupied) then
						create card_copy.make_gui_card (card_captured.color, card_captured.north, card_captured.south, card_captured.east, card_captured.west, card_captured.element.element)
						button.set_cell (card_copy, button.element.element)
						card_captured.destroy
						button.set_occupied (true)
						w_main_menu.set_move (card_copy, row_1, col_1)
						w_main_menu.get_inform_game
					end
				end
			end
		end

	block_board
			-- blocks the board game
		do
			table_board_game.disable_sensitive
		end

	unblock_board
			--unblocks the board game
		do
			table_board_game.enable_sensitive
		end

	block_card_player_1
			-- blocks the card  game of the player 1
		do
			f_fixed_player1.disable_sensitive
		end

	block_card_player_2
			-- blocks the card  game of the player 2
		do
			f_fixed_player2.disable_sensitive
		end

feature {NONE} -- Implementation atthribute

	main_container: EV_HORIZONTAL_BOX
			-- Main container (contains all widgets displayed in this window)

	f_fixed_player1, f_fixed_player2, f_fixed_board: EV_FIXED

	table_board_game: EV_TABLE

	l_turn1, l_score_player_1, l_title, l_turn2, l_score_player_2: EV_LABEL

	card_captured, b_player1_card1, b_player1_card2, b_player1_card3, b_player1_card4, b_player1_card5, b_player2_card1, b_player2_card2, b_player2_card3, b_player2_card4, b_player2_card5: G2_GUI_CARD

	b_disconnect: EV_BUTTON

	color_red, color_green, color_blue, color_morrow: EV_COLOR

	w_main_menu: G2_GUI_MAIN_MENU

feature {NONE} -- Implementation / Constants

	Window_title: STRING = "board_game"
			-- Title of the window.

	Window_width: INTEGER = 800
			-- Initial width for this window.

	Window_height: INTEGER = 800
			-- Initial height for this window.

end
