set -gx EDITOR nvim
set -U fish_greeting
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

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

    function clearnvim
        rm -rf ~/.local/share/nvim
        rm -rf ~/.local/state/nvim
        rm -rf ~/.cache/nvim
    end

    function cppc
        g++ -std=c++17 -Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic -Werror -o $argv[1] $argv[1].cpp && ./$argv[1]
    end

    function cpps
        g++ -std=c++17 -o $argv[1] $argv[1].cpp && ./$argv[1]
    end

    # SSH agent management with keychain
    if command -v keychain >/dev/null 2>&1
        eval (keychain --eval --quiet --inherit any-once id_ed25519)
    end

    starship init fish | source
end
