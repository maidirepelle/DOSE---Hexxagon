note
	description: "Summary description for {HX_L_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HX_L_BOARD

inherit
	HX_L_IBOARD


create
	make,
	make_copy

	-- TODO: Handle the players, decide which one is active...

feature {HX_L_IBOARD} -- Initialization

	existing_places_count: INTEGER
		-- The number of existing places on the board.

	board_player_1: HX_L_PLAYER
	board_player_2: HX_L_PLAYER

	board_last_move: HX_L_IMOVE

	logic: separate HX_L_LOGIC
		-- The reference to the logic component.

	make_copy(board: HX_L_BOARD)
		-- Make a copy of the given board.
		require
			non_void: board /= Void
		local
			l_x, l_y: INTEGER
			l_place: HX_L_IPLACE
		do
			logic := board.logic
			board_serializer := board.board_serializer
			height := board.height
			width := board.width
			create board_player_1.make (
				Current, board.board_player_1.id,
				board.board_player_1.name, board.board_player_1.is_human)
			create board_player_2.make (
				Current, board.board_player_2.id,
				board.board_player_2.name, board.board_player_2.is_human)
			player_1 := board_player_1
			player_2 := board_player_2
			if board.board_active_player = board.player_1 then
				board_active_player := player_1
			else
				board_active_player := player_2
			end
			existing_places_count := board.existing_places_count
			moves_count := board.moves_count
			create board_array.make_filled (Void, width, height)
			from
				l_x := 1
			until
				l_x > height
			loop
				from
					l_y := 1
				until
					l_y > width
				loop
					l_place := board.place (l_x, l_y)
					if not l_place.exists then
						board_array.put (
							create {HX_L_PLACE}.make(FALSE, TRUE, Void), l_x, l_y)
					elseif l_place.is_empty then
						board_array.put (
							create {HX_L_PLACE}.make(TRUE, TRUE, Void), l_x, l_y)
					elseif l_place.player = board.player_1 then
						board_array.put (
							create {HX_L_PLACE}.make(TRUE, FALSE, player_1), l_x, l_y)
						board_player_1.inc_pieces_count
					else
						board_array.put (
							create {HX_L_PLACE}.make(TRUE, FALSE, player_2), l_x, l_y)
						board_player_2.inc_pieces_count
					end
					l_y := l_y + 1
				end
				l_x := l_x + 1
			end
		ensure
			same_size: height = board.height and width = board.width
			different_player1: player_1 /= board.player_1
			different_player2: player_2 /= board.player_2
			board_active_player: active_player = player_1 or active_player = player_2
			same_moves_count: moves_count = board.moves_count
			player1_pieces: player_1.pieces_count = board.player_1.pieces_count
			player2_pieces: player_2.pieces_count = board.player_2.pieces_count
		end

	make(a_player_name_1, a_player_name_2: STRING;
		a_player_1_is_human, a_player_2_is_human:BOOLEAN;
		a_template: ARRAY2 [INTEGER]; a_logic: separate HX_L_LOGIC)
		-- Make a board with given height and with, filled with places
		-- inialized with exists=TRUE and is_empty=TRUE
		require
			good_height: 1 < a_template.height and a_template.height <= max_height
			good_width: 1 < a_template.width and a_template.width <= max_width
		local
			l_template: ARRAY2 [HX_L_IPLACE]
			x: INTEGER
			y: INTEGER
		do
			logic := a_logic
			height := a_template.height
			width := a_template.width

			create board_player_1.make(Current, 1, a_player_name_1, a_player_1_is_human)
			player_1 := board_player_1
			create board_player_2.make(Current, 2, a_player_name_2, a_player_2_is_human)
			player_2 := board_player_2

			board_active_player := player_1
			existing_places_count := 0

			create l_template.make_filled(Void, width, height)
			from
				x := 1
			until
				x > height
			loop
				from
					y := 1
				until
					y > width
				loop
					if a_template.item (x, y) = 0 then
						existing_places_count := existing_places_count + 1
						l_template.put (create {HX_L_PLACE}.make(TRUE, TRUE, Void), x, y)
					elseif a_template.item (x, y) = 3 then
						l_template.put (create {HX_L_PLACE}.make(FALSE, TRUE, Void), x, y)
					elseif a_template.item (x, y) = 1 then
						l_template.put (create {HX_L_PLACE}.make(TRUE, FALSE, player_1), x, y)
						board_player_1.inc_pieces_count()
						existing_places_count := existing_places_count + 1
					elseif a_template.item (x, y) = 2 then
						l_template.put (create {HX_L_PLACE}.make(TRUE, FALSE, player_2), x, y)
						board_player_2.inc_pieces_count()
						existing_places_count := existing_places_count + 1
					end
					y := y + 1
				end
				x := x + 1
			end

			create board_serializer
			board_array := l_template
		end

feature -- Internal

	board_serializer: HX_L_SERIALIZER

feature -- Access

	place(x: INTEGER; y: INTEGER): HX_L_IPLACE
		-- Place at position (x, y).
		local
			l_place: HX_L_PLACE
		do
			if (1 <= x and x <= width) and (1 <= y and y <= height) then
				Result := board_array[x, y]
			else
				create l_place.make(FALSE, TRUE, Void)
				Result := l_place
			end
		end

	active_player: HX_L_IPLAYER
		-- Currently active player.
		do
			Result := board_active_player
		end

	legal_moves: LIST[HX_L_IMOVE]
		local
			l_list: LINKED_LIST[HX_L_IMOVE]
			x, y: INTEGER
		do
			-- TODO: Cache results, because AI is going to use this function twice: by calling
			-- is_end and by calling this function directly. Cache should be invalidated, when
			-- move_piece is called.
			create l_list.make

			from x:=1
			until x>width
			loop
			  	from y:=1
			  	until y>height
			  	loop
			  		if place(x,y).exists AND NOT place(x,y).is_empty AND place(x,y).player.is_equal(active_player)
			  		then
						l_list.append (possible_moves(x, y))
			  		end
			  		y := y + 1
			  	end
			  	x  := x + 1
			end

			Result := l_list

		end

	is_end: BOOLEAN
		-- Is it the end of the game?
		-- Game is finished if all existing places are not empty.
		do
			if existing_places_count - player_1.pieces_count - player_2.pieces_count = 0 then
				Result := TRUE
			elseif player_1.pieces_count = 0 or player_2.pieces_count = 0 then
				Result := TRUE
			elseif legal_moves.count = 0 then
				Result := TRUE
			else
				Result := FALSE
			end
		end

	winner: HX_L_IPLAYER
		-- The winner of the game (The one who has more pieces or
		-- in case both have the same amount then the player,
		-- who started second).
		do
			if player_1.pieces_count > player_2.pieces_count then
				Result := player_1
			elseif player_1.pieces_count < player_2.pieces_count then
				Result := player_2
			else
				Result := player_2
			end
		end

	pieces_count(a_player: HX_L_IPLAYER): INTEGER
		-- Counts player's pieces.
		do
			Result := a_player.pieces_count
		end

	is_piece_selectable(x: INTEGER; y: INTEGER): BOOLEAN
		-- Can piece in this place be selected?
		do
			Result := place(x,y).exists AND NOT place(x,y).is_empty AND place(x,y).player.is_equal(active_player)
		end

	possible_moves(x: INTEGER; y: INTEGER): LIST[HX_L_IMOVE]
		-- Return possible moves.
		local
			l_list: LINKED_LIST[HX_L_IMOVE]
			l_from: HX_L_LOCATION
			l_to: HX_L_ILOCATION
			l_move: HX_L_MOVE
		do
			create l_list.make()

			-- Get all the the free places which are first grade neighbors
			across first_grade_neighbors_of_location (x, y) as neighbor
			loop
				l_to := neighbor.item
				if place(l_to.x, l_to.y).exists and place(l_to.x, l_to.y).is_empty then
					create l_from.make (x, y)
					create l_move.make(l_from, l_to)
					l_list.extend(l_move)
				end
			end

			-- Get all the the free places which are second grade neighbors
			across second_grade_neighbors_of_location (x, y) as neighbor
			loop
				l_to := neighbor.item
				if place(l_to.x, l_to.y).exists and place (l_to.x, l_to.y).is_empty then
					create l_from.make (x, y)
					create l_move.make (l_from, l_to)
					l_list.extend (l_move)
				end
			end

			Result := l_list
		end

	is_piece_movable(from_x: INTEGER; from_y: INTEGER; to_x: INTEGER; to_y: INTEGER): BOOLEAN
		-- Is piece movable?
		local
			source, dest: HX_L_IPLACE
			source_ok, dest_ok: BOOLEAN
			l_neighbour: BOOLEAN
		do
			source := place(from_x,from_y)
			dest :=  place(to_x, to_y)

			source_ok := (
				source.exists AND
				NOT source.is_empty AND
				source.player.is_equal(active_player)
				)
			l_neighbour := is_first_grade_neighbor (from_x, from_y, to_x, to_y)
			l_neighbour := is_second_grade_neighbor (from_x, from_y, to_x, to_y) OR l_neighbour
			dest_ok := dest.exists AND dest.is_empty AND l_neighbour

			Result := source_ok AND dest_ok
		end


	move_piece(a_move: HX_L_IMOVE)
		-- Move a piece to a new location.
		local
			l_source, l_dest: HX_L_IPLACE
			l_from, l_to: HX_L_ILOCATION
			l_active_player: HX_L_PLAYER
			l_passive_player: HX_L_PLAYER
		do
			l_from := a_move.source
			l_to := a_move.destination
			l_source := place(l_from.x, l_from.y)
			l_dest := place(l_to.x, l_to.y)

			if active_player = player_1 then
				l_active_player := board_player_1
				l_passive_player := board_player_2
			else
				l_active_player := board_player_2
				l_passive_player := board_player_1
			end

			-- Case 1: Doubling piece
			if is_first_grade_neighbor(l_from.x, l_from.y, l_to.x, l_to.y) then
				-- Set destination place properties
				l_dest.set_is_empty (FALSE)
				l_dest.set_player (l_active_player)
				l_active_player.inc_pieces_count()
			end

			-- Case 2: Jump with piece
			if is_second_grade_neighbor (l_from.x, l_from.y, l_to.x, l_to.y) then
				-- Set destination place properties
				l_dest.set_is_empty (FALSE)
				l_dest.set_player (l_active_player)

				-- Set source place properties
				l_source.set_is_empty (TRUE)
			end

			across first_grade_neighbors_of_place(l_to.x, l_to.y) as neighbor
				loop
					if neighbor.item.exists AND
						not neighbor.item.is_empty AND
						neighbor.item.player = l_passive_player
					then
						neighbor.item.set_player (active_player)
						l_passive_player.dec_pieces_count
						l_active_player.inc_pieces_count
					end
				end

			moves_count := moves_count + 1
			board_last_move := a_move

		end

	change_active_player()
		do
			if board_active_player = player_1 then
				board_active_player := player_2
			else
				board_active_player := player_1
			end
		end

	move_piece_and_continue(from_x: INTEGER; from_y: INTEGER; to_x: INTEGER; to_y: INTEGER)
		local
			a_move: HX_L_MOVE
			a_from: HX_L_LOCATION
			a_to: HX_L_LOCATION
			l_message: HX_L_GAME_END_MESSAGE
		do
			if board_active_player.is_human then
				print("UI is making a move...%N")
			end

			create a_from.make(from_x, from_y)
			create a_to.make(to_x, to_y)
			create a_move.make(a_from, a_to)
			logic.logic_gui.repaint
			move_piece(a_move)

			if is_end then

				fill_empty_places

				create l_message.make (winner.id, player_1.pieces_count, player_2.pieces_count)
				logic.logic_gui.game_finished (l_message)
			else

				change_active_player()

				if not board_active_player.is_human then
					print("UI finished move...  %N")
					logic.ai_move (board_active_player)
				else
					print("AI finished move...  %N")
					logic.logic_gui.request_move
				end

			end

		end

	last_move: HX_L_IMOVE
		do
			Result := board_last_move
		end

	clone_board(): HX_L_IBOARD
		-- Returns a copy of a board.
		do
			create {HX_L_BOARD} Result.make_copy(Current)
		end

FEATURE {HX_L_IBOARD} -- Internal details

	board_active_player: HX_L_IPLAYER

FEATURE {NONE} -- Helper functions


	fill_empty_places()
		do
			across board_array as l_place
			loop
				if l_place.item.exists AND l_place.item.is_empty then

					l_place.item.set_is_empty (FALSE)
					l_place.item.set_player (active_player)

					if l_place.item.player = board_player_1 then
						board_player_1.inc_pieces_count
					else
						board_player_2.inc_pieces_count
					end

				end
			end
		end

	first_grade_neighbors_of_place(x,y: INTEGER): LIST[HX_L_IPLACE]
		-- Returns a list containing the neighboring places, where the piece can potentially be duplicated.
		local
			l_list: LINKED_LIST[HX_L_IPLACE]
		do
			create l_list.make

			across first_grade_neighbors_of_location (x, y) as l_location
			loop
				l_list.extend (place(l_location.item.x, l_location.item.y))
			end

			Result := l_list
		end

	first_grade_neighbors_offset_even: LINKED_LIST[TUPLE[x: INTEGER; y: INTEGER]]
		once
			create Result.make
			Result.extend ([-1,  0])
			Result.extend ([ 0, +1])
			Result.extend ([+1, +1])
			Result.extend ([+1,  0])
			Result.extend ([+1, -1])
			Result.extend ([ 0, -1])
		end

	first_grade_neighbors_offset_odd: LINKED_LIST[TUPLE[x: INTEGER; y: INTEGER]]
		once
			create Result.make
			Result.extend ([-1,  0])
			Result.extend ([-1, +1])
			Result.extend ([ 0, +1])
			Result.extend ([+1,  0])
			Result.extend ([ 0, -1])
			Result.extend ([-1, -1])
		end

	first_grade_neighbors_offset(a_x, a_y: INTEGER): LINKED_LIST[TUPLE[x: INTEGER; y: INTEGER]]
		do
			if a_y \\ 2 = 1 then
				Result := first_grade_neighbors_offset_odd
			else
				Result := first_grade_neighbors_offset_even
			end
		end

	is_first_grade_neighbor(from_x, from_y, to_x, to_y: INTEGER): BOOLEAN
		local
			l_x: INTEGER
			l_y: INTEGER
		do
			l_x := to_x - from_x
			l_y := to_y - from_y
			Result := False
			across first_grade_neighbors_offset(from_x, from_y) as l_offset
			loop
				if l_offset.item.x = l_x and l_offset.item.y = l_y then
					Result := True
				end
			end
		end

	first_grade_neighbors_of_location(x, y: INTEGER): LIST[HX_L_ILOCATION]
		-- Returns a list containing the neighboring places, where the piece can potentially be duplicated.
		local
			l_list: LINKED_LIST[HX_L_ILOCATION]
			l_location: HX_L_LOCATION
			l_x, l_y: INTEGER
		do
			create l_list.make
			across first_grade_neighbors_offset(x, y) as l_offset
			loop
				l_x := l_offset.item.x + x
				l_y := l_offset.item.y + y
				if 1 <= l_x and l_x <= height and 1 <= l_y and l_y <= width then
					create l_location.make (l_x, l_y)
					l_list.extend (l_location)
				end
			end

			Result := l_list
		end

	second_grade_neighbors_of_place (x, y: INTEGER): LIST[HX_L_IPLACE]
		-- Returns a list containing places, where the piece could potentially jump to
		local
			l_list: LINKED_LIST[HX_L_IPLACE]
		do
			create l_list.make

			across first_grade_neighbors_of_location (x, y) as l_location
			loop
				l_list.extend (place (l_location.item.x, l_location.item.y))
			end

			Result := l_list

		end

	second_grade_neighbors_offset_even: LINKED_LIST[TUPLE[x: INTEGER; y: INTEGER]]
		once
			create Result.make
			Result.extend ([-2,  0])
			Result.extend ([-1, +1])
			Result.extend ([-1, +2])
			Result.extend ([ 0, +2])
			Result.extend ([+1, +2])
			Result.extend ([+2, +1])
			Result.extend ([+2,  0])
			Result.extend ([+2, -1])
			Result.extend ([+1, -2])
			Result.extend ([ 0, -2])
			Result.extend ([-1, -2])
			Result.extend ([-1, -1])
		end

	second_grade_neighbors_offset_odd: LINKED_LIST[TUPLE[x: INTEGER; y: INTEGER]]
		once
			create Result.make
			Result.extend ([-2,  0])
			Result.extend ([-2, +1])
			Result.extend ([-1, +2])
			Result.extend ([ 0, +2])
			Result.extend ([+1, +2])
			Result.extend ([+1, +1])
			Result.extend ([+2,  0])
			Result.extend ([+1, -1])
			Result.extend ([+1, -2])
			Result.extend ([ 0, -2])
			Result.extend ([-1, -2])
			Result.extend ([-2, -1])
		end

	second_grade_neighbors_offset(a_x, a_y: INTEGER): LINKED_LIST[TUPLE[x: INTEGER; y: INTEGER]]
		do
			if a_y \\ 2 = 1 then
				Result := second_grade_neighbors_offset_odd
			else
				Result := second_grade_neighbors_offset_even
			end
		end

	is_second_grade_neighbor(from_x, from_y, to_x, to_y: INTEGER): BOOLEAN
		local
			l_x: INTEGER
			l_y: INTEGER
		do
			l_x := to_x - from_x
			l_y := to_y - from_y
			Result := False
			across second_grade_neighbors_offset(from_x, from_y) as l_offset
			loop
				if l_offset.item.x = l_x and l_offset.item.y = l_y then
					Result := True
				end
			end
		end

	second_grade_neighbors_of_location (x, y: INTEGER): LIST[HX_L_ILOCATION]
		-- Returns a list containing places, where the piece could potentially jump to
		local
			l_list: LINKED_LIST[HX_L_ILOCATION]
			l_location: HX_L_LOCATION
			l_x, l_y: INTEGER
		do
			create l_list.make

			across second_grade_neighbors_offset(x, y) as l_offset
			loop
				l_x := l_offset.item.x + x
				l_y := l_offset.item.y + y
				if 1 <= l_x and l_x <= height and 1 <= l_y and l_y <= width then
					create l_location.make (l_x, l_y)
					l_list.extend (l_location)
				end
			end

			Result := l_list

		end

end
