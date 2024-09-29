set -gx EDITOR nvim 
set -U fish_greeting


if status is-interactive
	alias aur="yay"

	function yy
		set tmp (mktemp -t "yazi-cwd.XXXXXX")
		yazi $argv --cwd-file="$tmp"
		if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
			cd -- "$cwd"
		end
		rm -f -- "$tmp"
	end

	function cppc
		g++ -std=c++17 -Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic -Werror -o $argv[1] $argv[1].cpp && ./$argv[1]
	end

	function cpps
		g++ -std=c++17 -o $argv[1] $argv[1].cpp && ./$argv[1]
	end

	starship init fish | source
end
