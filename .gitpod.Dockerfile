FROM library/archlinux:latest
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm base-devel git git-lfs htop sudo nano vim man-db zsh ripgrep stow which libyaml \
    elixir gauche openssh lsof jq zip unzip meson docker rlwrap cmake nginx python-pip nodejs npm wget \
    python-setuptools python-wheel python-virtualenv python-pipenv python-pylint python-rope python-pydocstyle python-twine
RUN locale-gen en_US.UTF-8

### Gitpod user ###
COPY ./sudoers /etc
RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # To emulate the workspace-session behavior within dazzle build env
    && mkdir /workspace && chown -hR gitpod:gitpod /workspace

ENV HOME=/home/gitpod
WORKDIR $HOME

# configure git-lfs
RUN git lfs install --system --skip-repo

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" && \
    mkdir -p /home/gitpod/.bashrc.d && \
    (echo; echo "for i in \$(ls -A \$HOME/.bashrc.d/); do source \$HOME/.bashrc.d/\$i; done"; echo) >> /home/gitpod/.bashrc && \
    mkdir -p /home/gitpod/.local/share/bash-completion/completions

RUN curl -sSL https://install.python-poetry.org | python
RUN sudo rm -rf /tmp/*

# Install oh-my-zsh for gitpod
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="gallois"/g' ~/.zshrc
RUN sed -i 's/plugins=(git)/plugins=(asdf bundler docker git github mix rails rake ruby sudo)/g' ~/.zshrc

CMD ["zsh"]

# Install asdf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf
RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
RUN echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
RUN source ~/.bashrc

# Install Ruby
RUN ~/.asdf/bin/asdf plugin-add ruby
RUN ~/.asdf/bin/asdf install ruby 3.2.2
RUN ~/.asdf/bin/asdf global ruby 3.2.2
#RUN ruby -v

#RUN gem install bundler --no-document \
#        && gem install solargraph --no-document \
#        && gem install rspec --no-document

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH
ENV MANPATH="$MANPATH:/home/linuxbrew/.linuxbrew/share/man"
ENV INFOPATH="$INFOPATH:/home/linuxbrew/.linuxbrew/share/info"
ENV HOMEBREW_NO_AUTO_UPDATE=1

# Configure Docker
USER root
RUN wget -O /usr/bin/slirp4netns https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-x86_64 \
    && chmod +x /usr/bin/slirp4netns

RUN wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 \
    && chmod +x /usr/local/bin/docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

RUN wget -O /tmp/dive.tar.gz https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.tar.gz \
    && tar -xf /tmp/dive.tar.gz && cp dive /usr/bin \
    && rm -rf /tmp/* dive LICENSE README.md

USER gitpod

# Configure Nginx
USER root
RUN mkdir -p /var/run/nginx
COPY --chown=gitpod:gitpod ./webserver/nginx/ /etc/nginx/
ENV NGINX_DOCROOT_IN_REPO="public"
USER gitpod

# Custom PATH additions
ENV PATH=$HOME/.local/bin:$PATH
