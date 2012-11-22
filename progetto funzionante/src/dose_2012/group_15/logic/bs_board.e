note
	description: "Summary description for {BS_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BS_BOARD

create
	make

feature

	make
		--initialize board state
	do
		create board.make_filled ( empty_value, 20, 20 )
		create board_colors.make_filled ( empty_value, 20, 20 )

		create players_moves.make_filled (Void, 1, 4)
		players_moves.put(create {ARRAY[BS_MOVE]}.make_empty, 1 )
		players_moves.put(create {ARRAY[BS_MOVE]}.make_empty, 2 )
		players_moves.put(create {ARRAY[BS_MOVE]}.make_empty, 3 )
		players_moves.put(create {ARRAY[BS_MOVE]}.make_empty, 4 )

		last_insertion_response := -1
	end

	insert_player_tile(player_number: INTEGER; new_move: BS_MOVE)
		--update board with player movement
	require
		correct_player_number: player_number >= 1 and player_number <= 4
		not_void_move: new_move /= Void
	local
		local_player_moves: ARRAY[BS_MOVE]
	do
		--verify if tile will fit inside board
		if is_inside_board (new_move) then

			--verify if needed square spaces are empty
			if has_space_for_insertion(new_move) then

				--verify if tile will touch another tile corner
				if is_touching_player_corner(player_number, new_move) then

					--verify if tile is not touching another tile side
					if is_touching_player_side(player_number, new_move) then
						last_insertion_response := 3
					else
						--fill board state with tile
						update_board (player_number, new_move)

						--add move to players list
						local_player_moves := players_moves.item (player_number)
					--	local_player_moves.resize(1, players_moves.count + 1)
						local_player_moves.conservative_resize_with_default (Void, 1, players_moves.count + 1)
						local_player_moves.put (new_move, players_moves.count + 1)

						last_insertion_response := 0
					end
				else
					last_insertion_response := 2
				end
			else
				last_insertion_response := 1
			end
		else
			last_insertion_response := 4
		end
	end

	last_insertion_result: INTEGER
		--0 is success
		--1 position overlap with another tile
		--2 piece corners does not touch another player's tile corner
		--3 piece side touches another player's tile side
		--4 invalid position
	require
		at_least_one_insertion: last_insertion_response /= -1
	do
		Result := last_insertion_response
	end

	get_state: ARRAY2[INTEGER]
		--return current board state, where numbers represents squares filled by some player id tile
	do
		Result := board
	ensure
		board /= Void
	end

	get_colors_state: ARRAY2[INTEGER]
		--return current colors board state, where numbers represents square colors
	do
		Result := board_colors
	ensure
		board_colors /= Void
	end

	get_player_moves( player_number: INTEGER): ARRAY[BS_MOVE]
		--return a player's moves
	require
		valid_player_number: player_number > 0 and player_number < 5
	do
		Result := players_moves.item (player_number)
	ensure
		Result /= Void
	end

feature {NONE} --auxiliar private methods

	update_board(player_number: INTEGER; a_move: BS_MOVE)
		--update board state with player move
		--to maintain consistency it can be executed only after all verifications of move validity
	local
		row, column: INTEGER
		tile_state: ARRAY2[INTEGER]
		position: BS_POSITION
	do
		tile_state := a_move.get_tile.get_state
		position := a_move.get_position

		from
			row := 1
		until
			row > tile_state.height
		loop
			from
				column := 1
			until
				column > tile_state.width
			loop
				--if is not an empty square of the tile then
				if tile_state.item(row, column) /= 0 then
					board.item (position.y + row - 1, position.x + column - 1) := player_number
					board_colors.item (position.y + row - 1, position.x + column - 1) := a_move.get_tile.get_color
				end

				column := column + 1
			end
			row := row + 1
		end
	end

	is_touching_player_corner( player_number: INTEGER; a_move: BS_MOVE ): BOOLEAN
		--verify if the position of each square tile will touch at least one players corner tile
		--do this by verifying neighbours squares already on board				
	local
		row, column: INTEGER
		is_touching_corner: BOOLEAN
		tile_state: ARRAY2[INTEGER]
		position: BS_POSITION
		corner_row, corner_column: INTEGER
		corners_position: LINKED_LIST[BS_POSITION]
	do

		create corners_position.make
		is_touching_corner := false
		tile_state := a_move.get_tile.get_state
		position := a_move.get_position

		--verify if player tile is touching player corner
		is_touching_corner := is_touching_right_corner(player_number, a_move)

		from
			row := 1
		until
			row > tile_state.height or is_touching_corner
		loop
			from
				column := 1
			until
				column > tile_state.width or is_touching_corner
			loop
				--if is not an empty square of the tile then
				if tile_state.item(row, column) /= 0 then
					--verify if it touches another tile corner of the same player

					--bottom right corner
					corner_row := position.x + row - 1 + 1
					corner_column := position.y + column - 1 + 1
					if corner_row > 0 and corner_column > 0 then
						corners_position.extend (create {BS_POSITION}.make(corner_row, corner_column))
					end

					--bottom left corner
					corner_row := position.x + row - 1 + 1
					corner_column :=  position.y + column - 1 - 1
					if corner_row > 0 and corner_column > 0 then
						corners_position.extend (create {BS_POSITION}.make(corner_row, corner_column))
					end

					--top right corner
					corner_row := position.x + row - 1 - 1
					corner_column := position.y + column - 1 + 1
					if corner_row > 0 and corner_column > 0 then
						corners_position.extend (create {BS_POSITION}.make(corner_row, corner_column))
					end

					--top left corner
					corner_row := position.x + row - 1 - 1
					corner_column :=  position.y + column - 1 - 1
					if corner_row > 0 and corner_column > 0 then
						corners_position.extend (create {BS_POSITION}.make(corner_row, corner_column))
					end

					from
						corners_position.start
					until
						corners_position.after
					loop

						--verify if possible corner position is inside board
						if corners_position.item.y <= board.height
							or corners_position.item.x <= board.width
						then
							--verify if corner position is equals to player number
							if board.item ( corners_position.item.y, corners_position.item.x ) = player_number then
								is_touching_corner := true
							end
						end

						corners_position.forth
					end
				end

				column := column + 1
			end
			row := row + 1
		end

		Result := is_touching_corner
	end

	is_touching_right_corner( player_number: INTEGER; a_move: BS_MOVE ): BOOLEAN
	local
		tile_state: ARRAY2[INTEGER]
		position: BS_POSITION
	do
		tile_state := a_move.get_tile.get_state
		position := a_move.get_position
		if (position.x = 1 and position.y = 1 and tile_state.item (1, 1) = 1)
			or (position.x + tile_state.width = 20 and position.y = 1 and tile_state.item (tile_state.width, 1) = 1)
			or (position.x = 1 and position.y + tile_state.height = 20 and tile_state.item (1, tile_state.height) = 1)
			or (position.x + tile_state.width = 20 and position.y + tile_state.height = 20 and tile_state.item (tile_state.width, tile_state.height) = 1)
			then
			Result := true
		else
			Result := false
		end
	end

	is_touching_player_side( player_number: INTEGER; a_move: BS_MOVE ): BOOLEAN
		--verify if the position of each square tile will touch one player tile side
		--do this by verifying neighbours squares already on board				
	local
		row, column: INTEGER
		is_touching_side: BOOLEAN
		tile_state: ARRAY2[INTEGER]
		position: BS_POSITION
		side_row, side_column: INTEGER
		sides_position: LINKED_LIST[BS_POSITION]
	do
		create sides_position.make
		is_touching_side := false
		tile_state := a_move.get_tile.get_state
		position := a_move.get_position

		from
			row := 1
		until
			row > tile_state.height or is_touching_side
		loop
			from
				column := 1
			until
				column > tile_state.width or is_touching_side
			loop
				--if is not an empty square of the tile then
				if tile_state.item(row, column) /= 0 then
					--verify if it touches another tile side of the same player

					--right side
					side_row := position.x + row - 1
					side_column := position.y + column + 1
					if side_row > 0 and side_column > 0 then
						sides_position.extend (create {BS_POSITION}.make(side_row, side_column))
					end

					--left side
					side_row := position.x + row - 1
					side_column :=  position.y + column - 1 - 1
					if side_row > 0 and side_column > 0 then
						sides_position.extend (create {BS_POSITION}.make(side_row, side_column))
					end

					--top side
					side_row := position.x + row - 1 - 1
					side_column := position.y + column - 1
					if side_row > 0 and side_column > 0 then
						sides_position.extend (create {BS_POSITION}.make(side_row, side_column))
					end

					--bottom side
					side_row := position.x + row + 1
					side_column :=  position.y + column - 1
					if side_row > 0 and side_column > 0 then
						sides_position.extend (create {BS_POSITION}.make(side_row, side_column))
					end

				--	io.put_string ("origin " + position.x.out + "," + position.y.out )
			--		io.put_string ("sssss")
					from
						sides_position.start
					until
						sides_position.after
					loop
				--		io.put_string ("side position " + sides_position.item.x.out + "," + sides_position.item.y.out )

						--verify if possible side position is inside board
						if sides_position.item.y <= board.height
							or sides_position.item.x <= board.width
						then
							--verify if side position is equals to player number
							if board.item ( sides_position.item.y, sides_position.item.x ) = player_number then
								is_touching_side := true
							end
						end

						sides_position.forth
					end
				end

				column := column + 1
			end
			row := row + 1
		end

		Result := is_touching_side
	end

	is_inside_board( a_move: BS_MOVE ): BOOLEAN
	local
		position: BS_POSITION
		tile_state: ARRAY2[INTEGER]
	do
		position := a_move.get_position
		tile_state := a_move.get_tile.get_state
		--verify if whole tile will fit inside board
		if tile_state.height + position.y -1 > board.height
			or tile_state.width + position.x -1 > board.width
			then
			Result := false
		else
			Result := true
		end

	end

	has_space_for_insertion( a_move: BS_MOVE ): BOOLEAN
	local
		row, column: INTEGER
		has_space: BOOLEAN
		tile_state: ARRAY2[INTEGER]
		position: BS_POSITION
	do
		has_space := true
		tile_state := a_move.get_tile.get_state
		position := a_move.get_position

		from
			row := 1
		until
			row > tile_state.height or not has_space
		loop
			from
				column := 1
			until
				column > tile_state.width or not has_space
			loop
				--if is not an empty square of the tile then
				if tile_state.item(row, column) /= 0 then
					--verify if board state is empty in this position
					if board.item (position.y + row - 1, position.x + column - 1) /= 0 then
						has_space := false
					end
				end

				column := column + 1
			end
			row := row + 1
		end

		Result := has_space
	end

feature {NONE}

	players_moves : ARRAY[ ARRAY[BS_MOVE] ]

	empty_value: INTEGER = 0
	board: ARRAY2[INTEGER]

	board_colors: ARRAY2[INTEGER]

	last_insertion_response: INTEGER

end