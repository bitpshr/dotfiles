set_prompt() {
    local default_username='bitpshr'

    tput sgr0
    local reset=$(tput sgr0)
    local green=$(tput setaf 2)
    local base1=$(tput setaf 9)
    local red=$(tput setaf 1)
    local blue=$(tput setaf 4)
    local bold=$(tput bold)

    usernamehost() {
        local userhost=""
        userhost+="$green$USER"
        userhost+="$base1 at"
        userhost+="$green $HOSTNAME"
        userhost+="$base1 in"
        if [ $USER != "$default_username" ]; then echo $userhost ""; fi
    }

    function prompt_git() {
        git rev-parse --is-inside-work-tree &>/dev/null || return

        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git describe --all --exact-match HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')";

        dirty=$(git diff --no-ext-diff --quiet --ignore-submodules --exit-code || echo -e "*")

        [ -n "${s}" ] && s=" [${s}]";
        echo -e "${1}${branchName}${2}$dirty";
        return
    }

    PS1="\n\[$bold\]"
    PS1+="$(usernamehost)"
    PS1+="\[$green\]\w"
    PS1+=$(prompt_git "$base1 on $blue" "$red")
    PS1+="\[$red\]\n⇢\[$reset\] "
    export PS1
}

# Set a git-enabled prompt
set_prompt
unset set_prompt

# Differentiate file types
alias ls="ls -F"
