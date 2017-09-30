# Prompt: inverted directory path with newline
export PS1='\[\e[7m\]\w\[\e[m\]\n'

# Command history
export HISTSIZE=2000
export HISTCONTROL='ignoredups:erasedups'
export HISTIGNORE='ls:cd:d:pwd:h'
shopt -s histappend
alias h='history 50'

export EDITOR='vim'
alias ls='ls -F'

# Change directory to path or from history
cd() {
    local idx
    local len="${#__dirs[@]}"
    local dir="${1:-${HOME}}"

    if [[ ${dir} =~ ^-[0-9]+$ ]]; then
        # cd from history
        idx="${dir:1}"
        if (( ${idx} >= ${len} )); then
            echo "cd: out of range"
            return
        fi
        dir="${__dirs[${idx}]}"
        unset -v '__dirs[${idx}]'
        builtin cd "${dir}"
    else
        # cd to path
        builtin cd "${dir}" || return

        # Ensure full path
        dir=$(pwd)

        # Search history for path
        for ((idx=0; idx<"${len}"; idx++)) do
            if [[ ${dir} = ${__dirs[${idx}]} ]]; then
                unset -v '__dirs[${idx}]'
                break
            fi
        done
    fi

    # Push path
    __dirs=("${dir}" "${__dirs[@]}")
}

# Show directory stack
d() {
    local len="${#__dirs[@]}"
    for ((idx=0; idx<"${len}"; idx++)) do
        echo "${idx}: ${__dirs[${idx}]/${HOME}/~}"
    done
}
