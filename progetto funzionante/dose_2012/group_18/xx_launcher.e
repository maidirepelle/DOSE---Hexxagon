note
	description: "Launcher for the Hexxagon main window."
	author: "Cairo2, Crete2, Milano2"
	date: "30/10/2012"
	revision: "1.0"

class
	XX_LAUNCHER

inherit
	LAUNCHER

feature -- Implementation

	test: XX_HEXXAGON

	launch (main_ui_window: MAIN_WINDOW)
			-- shows a dummy output
		do
		 	io.put_string("Hexxagon coming soon")
		end

end
