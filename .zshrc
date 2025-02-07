# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose dotenv colorize colored-man-pages copyfile copypath fancy-ctrl-z fzf git-auto-fetch git-prompt golang per-directory-history safe-paste zsh-interactive-cd zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias cl="clear"
alias ps="ps -aux"
alias nv="nvim ."
alias dp="docker ps"
alias dpa="docker ps -a"
alias de="docker exec -it"
alias dc="docker compose"
alias dcu="docker compose up --build -d && docker compose logs -f"
alias dcd="docker compose down"
alias apti="apt install -y"
alias aptu="apt update"
alias bat="batcat"
alias sshd="/usr/sbin/sshd"
alias around="grep -A 20 -B 20"
alias bw="binwalk --dd='.*'"
alias targz="tar -czvf"
alias untargz="tar -xvzf"
alias pass="openssl rand -hex 16"

clone() {
  git clone "https://github.com/$1"
  cd "$(basename "$1")"
}

ip() {
  # If no arguments are passed, show the local IP address
  if [ $# -eq 0 ]; then
    hostname -I
  else
    # Otherwise run the ip command with remaining arguments
    command ip "$@"
  fi
}

setup() {
  gh auth login
  nvim --headless +qall > /dev/null 2>&1
  nvim --headless +Copilot +qall
  mkdir -p /etc/tailscale
  nohup tailscaled > /etc/tailscale/tailscaled.log 2>&1 &
  # Get the github username from the user
  echo "Enter your github username: "
  read username
  # Set ssh public keys as authorized
  mkdir -p /root/.ssh
  wget -O /root/.ssh/authorized_keys "github.com/$username.keys"
  nohup /usr/sbin/sshd > /dev/null 2>&1 &
  tailscale up
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:/root/.rvm/bin"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# Go
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/root/go/bin"
export PATH="$PATH:/root/.local/bin"

# Rust
export "PATH=$PATH:/root/.cargo/bin"

eval "$(zoxide init zsh)"

export GOEXPERIMENT=rangefunc

export TERM=tmux-256color

neofetch
