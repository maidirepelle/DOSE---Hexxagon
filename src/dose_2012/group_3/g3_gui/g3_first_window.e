note
	description: "THE FIRST WINDOW APPEAR TO THE USER TO CHOOSE PLAY"
	author: "LYDATAKIS GEORGIOU KATEROS"
	date: "$Date$"
	revision: "$0.1$"

class
	G3_FIRST_WINDOW



inherit
	EV_TITLED_WINDOW
	    redefine
			create_interface_objects,initialize, is_in_default_state
		end
create
	make

feature{ANY} --intialize

	make(a_main_wind_window: MAIN_WINDOW)
		--use
		do

			default_create
			main_wind := a_main_wind_window
			make_with_title ("tichu")

      		disable_user_resize
      		close_request_actions.extend (agent destroy)

		end

	initialize
		--intialize main window components
		local
			internal_pixmap: EV_PIXMAP
		do
			Precursor {EV_TITLED_WINDOW}
			close_request_actions.extend (agent request_close_window)
			create_interface_objects
			create internal_pixmap
			internal_pixmap.set_with_named_file ("dose_2012/images/group_03/font1.png")
			game_con.set_background_pixmap (internal_pixmap)
			put (main_cont)
			main_cont.extend_with_position_and_size (game_con, 0, 0, 1000, 600)
			game_con.extend_with_position_and_size (play_button,80,360,150,90)
			game_con.extend_with_position_and_size (exit_button,700,360,150,90)

		end

		show_window
		do
			main_window.show
		end
feature {NONE} -- Implementation

	create_interface_objects
			-- Create objects
		local
			internal_pixmap1: EV_PIXMAP
			internal_pixmap2: EV_PIXMAP
		do
			create internal_pixmap1
			create internal_pixmap2
			internal_pixmap1.set_with_named_file ("dose_2012/images/group_03/play1.png")
			internal_pixmap2.set_with_named_file ("dose_2012/images/group_03/quit1.png")
				-- Create all widgets.
			create game_con
			create main_cont
			create play_button.default_create
			play_button.set_background_pixmap (internal_pixmap1)
			play_button.pointer_button_release_actions.extend (agent play_game(?,?,?,?,?,?,?,?))
			play_button.pointer_enter_actions.extend (agent enter_pixmap(play_button))
			play_button.pointer_leave_actions.extend (agent leave_pixmap(play_button))
			create exit_button.default_create
			exit_button.set_background_pixmap (internal_pixmap2)
			exit_button.pointer_enter_actions.extend (agent enter_pixmap(exit_button))
			exit_button.pointer_leave_actions.extend (agent leave_pixmap(exit_button))
			exit_button.pointer_button_release_actions.extend (agent exit_game(?,?,?,?,?,?,?,?))
		end

	is_in_default_state: BOOLEAN
			-- Is `Current' in its default state?
		do
			Result := True
		end

	user_create_interface_objects
			-- Feature for custom user interface object creation, called at end of `create_interface_objects'.
		do

		end

	user_initialization
			-- Feature for custom initialization, called at end of `initialize'.
		do
		end



feature{NONE}
	request_close_window
			-- The user wants to close the window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do

			create question_dialog.make_with_text ("ARE U SURE YOU WANT TO QUIT? ")

			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
					-- Restore the main UI which is currently minimized
				if attached main_wind then
					main_wind.restore
					main_wind.remove_reference_to_game (Current)
				end
					-- Destroy the window
				destroy
			end
		end

	play_game (a_a,a_b,a_c:INTEGER_32 b_a,b_b,b_c:REAL_64 c_a,c_b:INTEGER_32)
		--calls when player push play button
	local
		window:G3_START_GAME

	do
		--destroy;

		game_con.wipe_out
		create window
		window.initialize_start_game (main_cont)
	end

	exit_game (a_a,a_b,a_c:INTEGER_32 b_a,b_b,b_c:REAL_64 c_a,c_b:INTEGER_32)
		--calls when player pusg exit button and exit the game
	do
		destroy;
	end

	enter_pixmap (pix:EV_FIXED)
	local
			internal_pixmap: EV_PIXMAP
	do
		create internal_pixmap
		if pix = play_button then
			internal_pixmap.set_with_named_file ("dose_2012/images/group_03/play2.png")
			play_button.set_background_pixmap (internal_pixmap)
		else
			internal_pixmap.set_with_named_file ("dose_2012/images/group_03/quit2.png")
			pix.set_background_pixmap (internal_pixmap)
		end

	end

	leave_pixmap (pix:EV_FIXED)
	local
			internal_pixmap: EV_PIXMAP
	do
		create internal_pixmap
		if pix = play_button then
			internal_pixmap.set_with_named_file ("dose_2012/images/group_03/play1.png")
			play_button.set_background_pixmap (internal_pixmap)
		else
			internal_pixmap.set_with_named_file ("dose_2012/images/group_03/quit1.png")
			pix.set_background_pixmap (internal_pixmap)
		end

	end


feature {NONE}	-- Attributes

	play_button : EV_FIXED
		--Button that player use to play game
	exit_button : EV_FIXED
		--Button that player use to exit the game
	window_height : INTEGER = 800
		--the window height
	window_widtht : INTEGER = 600
		--the window width
	main_wind: MAIN_WINDOW
		--use to store main_window
	main_cont: EV_FIXED
			-- the main container to which the button will be added
	game_con:EV_FIXED

	comps:G3_COMPS

	main_window:EV_TITLED_WINDOW
end
