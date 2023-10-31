function hx --wraps=helix --description 'alias hx helix'
    if command -q helix
        helix $argv
    else if command -q /usr/libexec/hx # For Fedora toolbox
        HELIX_RUNTIME=/usr/share/helix/runtime /usr/libexec/hx $argv
    end
end
