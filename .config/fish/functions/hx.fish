function hx --wraps=helix --description 'alias hx helix'
    if command -q helix
        helix $argv
    else if command -q /usr/libexec/hx # For old Fedora toolbox
        HELIX_RUNTIME=/usr/share/helix/runtime /usr/libexec/hx $argv
    else if command -q /usr/bin/hx # For new Fedora toolbox
        /usr/bin/hx $argv
    end
end
