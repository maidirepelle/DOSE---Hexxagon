note
	description: "Summary description for {G10_GUI_SCORE}."
	author: "Eleytherios S. Benisis"
	date: "$Date 9/12"
	revision: "$score class represents the score number display a player has in the game$"

class
	G10_GUI_SCORE
inherit
	EV_LABEL

create
	make

-- attributes
feature {NONE}
	score_number_display : INTEGER

-- costructors.
feature {ANY}
	make()
	do
		default_create()
		update_score(5)
		update_background_color()
		set_minimum_height (30)
		set_minimum_width (100)
	end

-- accesor methods.
feature {G10_GUI_PLAYER_INFO , G10_GUI_GAME_MAIN}
	get_background_color() : EV_COLOR -- routine returns the color of this object's background color attribute
	do
		result := current.background_color
		ensure
			background_color_not_mutated : background_color = old background_color
	end

	get_score_number_display() : INTEGER -- routine returns the score attribute of this object
	do
		result := score_number_display
		ensure
			score_not_mutated : score_number_display = old score_number_display
	end

-- mutator methods.
feature {G10_GUI_PLAYER_INFO}
	update_score(num : INTEGER) -- routine ipdates the score attribute of this object to num
	require
		valid_arg : num >= 0
	do
		score_number_display := num
		ensure
			valid_mutation : old num = score_number_display
			valid_attribute :  score_number_display >= 0
	end

	update_background_color_c(c : EV_COLOR) -- routine sets the background color of this object to c
	require
		color_not_void : c /= void
	do
		set_background_color(c)
		ensure
			color_changed_to_c : background_color = c
	end

	update_background_color() -- routine sets the background color of this object to white
	local
		c : EV_COLOR
	do
		create c.make_with_8_bit_rgb (130, 30, 130)
		set_background_color(c)
	end

-- class invariants.
invariant
	valid_attributes : score_number_display >= 0

end
