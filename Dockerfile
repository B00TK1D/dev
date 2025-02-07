FROM debian AS build

# Fix apt on apple silicon
RUN echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::BrokenProxy    true;" >> /etc/apt/apt.conf.d/99custom

# Install build dependencies
RUN apt update && apt install -y ca-certificates curl apt-transport-https gnupg

# Add apt sources for gcpcli
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg |  gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Add apt sources for docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc

RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install everything
RUN apt update && apt install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    unzip \
    zip \
    tar \
    gzip \
    bzip2 \
    traceroute \
    htop \
    btop \
    tcpdump \
    gh \
    build-essential \
    net-tools \
    cmake \
    gcc \
    fzf \
    strace \
    jq \
    openvpn \
    ffmpeg \
    xxd \
    python3 \
    python3-pip \
    pipx \
    nmap \
    sqlmap \
    hydra \
    john \
    hashcat \
    aircrack-ng \
    gobuster \
    dirb \
    cewl \
    python3-impacket \
    ettercap-common \
    autopsy \
    mdk3 \
    steghide \
    binwalk \
    exiftool \
    apktool \
    foremost \
    awscli \
    google-cloud-cli \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    wireguard \
    iproute2 \
    iptables \
    iputils-ping \
    openssh-server \
    lsb-release \
    software-properties-common \
    gnupg \
    lld \
    liblld-19 \
    liblld-19-dev \
    llvm-dev \
    nodejs \
    npm \
    lua5.3 \
    luarocks \
    ruby-full \
    default-jre \
    default-jdk \
    perl \
    gdb \
    tmux \
    zsh \
    ninja-build \
    pkg-config \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    gettext \
    universal-ctags \
    ripgrep \
    fd-find \
    silversearcher-ag \
    bat \
    neofetch \
    luarocks


# Install radare2
RUN git clone https://github.com/radareorg/radare2 /usr/local/src/radare2 && \
  cd /usr/local/src/radare2 && \
  sys/install.sh


# Install metasploit
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall && rm msfinstall


# Install golang
RUN curl -fsSLo- https://raw.githubusercontent.com/codenoid/install-latest-go-linux/main/install-go.sh | bash && \
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile && \
    echo "export GOPATH=$HOME/go" >> /etc/profile && \
    echo "export PATH=$PATH:$GOPATH/bin" >> /etc/profile

# Install tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Install llvm
RUN curl -sL https://apt.llvm.org/llvm.sh | bash -s -- 19 all

# Install zig
RUN git clone https://github.com/ziglang/zig.git && \
    cd zig && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j 8 install && \
    cp -r ./stage3/lib/zig /usr/lib/ && \
    cp -r ./stage3/bin/zig /usr/bin/ && \
    cd ../.. && \
    rm -rf zig

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo "export PATH=$PATH:/root/.cargo/bin" >> /etc/profile && \
    /root/.cargo/bin/rustup component add rust-analyzer rustfmt


# Install gef for gdb
RUN bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Install qiq
RUN git clone https://github.com/B00TK1D/sideqiq && cd sideqiq && pip install --break-system-packages . && cd .. && rm -rf sideqiq

# Install tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install mitmproxy
RUN pipx install mitmproxy
RUN ln -s /root/.local/bin/mitmproxy /usr/local/bin/mitmproxy
RUN ln -s /root/.local/bin/mitmdump /usr/local/bin/mitmdump
RUN ln -s /root/.local/bin/mitmweb /usr/local/bin/mitmweb

# Setup ssh
RUN ssh-keygen -A
RUN mkdir /run/sshd

# Set up locales
RUN apt update && apt install -y locales
RUN echo "LC_ALL=en_US.UTF-8" | tee -a /etc/environment && \
    echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" | tee -a /etc/locale.conf && \
    locale-gen en_US.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Set up tmux config
COPY .tmux.conf /root/.tmux.conf
COPY .tmux.conf.local /root/.tmux.conf.local

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh plugins
RUN cd ~/.oh-my-zsh/custom/plugins && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git && \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

# Install neovim
RUN git clone https://github.com/neovim/neovim.git && \
    cd neovim && \
    git checkout stable && \
    CFLAGS="-fno-lto" CXXFLAGS="-fno-lto" CMAKE_BUILD_TYPE=Release make -j 8 && \
    make -j 8 install && \
    cd ../.. && \
    rm -rf neovim

# Install lazygit
RUN git clone https://github.com/jesseduffield/lazygit.git && \
    cd lazygit && \
    CGO_ENABLED=0 /root/go/bin/go install && \
    cd .. && \
    rm -rf lazygit

# Install lazydocker
RUN curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Install zoxide
RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install Python dependancies
COPY requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# Set up general config
COPY .config /root/.config

# Set up zsh config
COPY .zshrc /root/.zshrc


# Install lsps
RUN npm install -g tree-sitter-cli && \
    pip install --break-system-packages "python-lsp-server[all]" "vim-vint" "python-lsp-isort" "pylsp-mypy" "python-lsp-black" && \
    PATH="$PATH:/root/go/bin" CGO_ENABLED=0 nvim --headless +"MasonInstall gopls" +qall && \
    PATH="$PATH:/root/go/bin" nvim --headless +"MasonInstall vim-language-server bash-language-server cmake-language-server css-lsp dockerfile-language-server flake8 html-lsp jq json-lsp kotlin-language-server nimlangserver pyright yaml-language-server goimports gofumpt snyk semgrep" +"TSUpdate" +qall

# Clean up home directory
RUN rm -rf /root/*.tar.gz
RUN mkdir -p /root/w
RUN mkdir -p /root/s
RUN mkdir -p /root/p


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


WORKDIR /root/w
CMD ["/bin/sh", "/entrypoint.sh"]

