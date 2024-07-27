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

    starship init fish | source
end
