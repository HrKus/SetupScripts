# powerline shell
function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"$'\n$'
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" -a -x "$(command -v powerline-shell)" ]; then
    install_powerline_precmd
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# pyenv shell function for conda
function pyenv_global() {
    # >>> conda deactivate >>>
    if [[ "$(pyenv version-name)" =~ "conda" ]]; then
        conda deactivate 1>/dev/null 2>&1
        unset -f conda 1>/dev/null 2>&1
    fi
    # >>> conda deactivate >>>
    
    # If conda_path is in PATH, remove it
    if [[ ":$PATH:" == *":"$(pyenv prefix)/condabin":"* ]]; then
        PATH=$(echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$(pyenv prefix)/condabin'"' | sed 's/:$//')
    fi
    
    # Set pyenv version
    pyenv global $1

    # >>> conda initialize >>>
    if [[ "$(pyenv version-name)" =~ "conda" ]]; then
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('$(pyenv prefix)/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
            echo "1"
        else
            if [ -f "$(pyenv prefix)/etc/profile.d/conda.sh" ]; then
                . "$(pyenv prefix)/etc/profile.d/conda.sh"
                echo "$(pyenv prefix)/etc/profile.d/conda.sh"
            else
                export PATH="$(pyenv prefix)/bin:$PATH"
                echo "3"
            fi
        fi
        unset __conda_setup
    fi
    # <<< conda initialize <<<

    pyenv versions | sed -E 's/([a-z]+)(.+)envs\/(.+)/--\3/g'
}

function pyenv_local() {
    # >>> conda deactivate >>>
    if [[ "$(pyenv version-name)" =~ "conda" ]]; then
        conda deactivate 1>/dev/null 2>&1
        unset -f conda 1>/dev/null 2>&1
    fi
    # >>> conda deactivate >>>
    
    # If conda_path is in PATH, remove it
    if [[ ":$PATH:" == *":"$(pyenv prefix)/condabin":"* ]]; then
        PATH=$(echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$(pyenv prefix)/condabin'"' | sed 's/:$//')
    fi
    
    # Set pyenv version
    pyenv local $1

    # >>> conda initialize >>>
    if [[ "$(pyenv version-name)" =~ "conda" ]]; then
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('$(pyenv prefix)/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
            echo "1"
        else
            if [ -f "$(pyenv prefix)/etc/profile.d/conda.sh" ]; then
                . "$(pyenv prefix)/etc/profile.d/conda.sh"
                echo "$(pyenv prefix)/etc/profile.d/conda.sh"
            else
                export PATH="$(pyenv prefix)/bin:$PATH"
                echo "3"
            fi
        fi
        unset __conda_setup
    fi
    # <<< conda initialize <<<

    pyenv versions | sed -E 's/([a-z]+)(.+)envs\/(.+)/--\3/g'
}

function pyenv_versions() {
    pyenv versions | sed -E 's/([a-z]+)(.+)envs\/(.+)/--\3/g'
}