FROM library/alpine:edge

RUN apk add --no-cache coreutils sudo build-base curl git vim ruby=3.2.2-r0 ruby-dev elixir=1.15.7-r1 perl perl-utils zsh
RUN apk update && apk upgrade
RUN gem install bundler --no-document && gem install solargraph --no-document

### Gitpod user ###
COPY ./sudoers /etc
RUN addgroup -S -g 33333 gitpod
RUN adduser -S -u 33333 -G wheel -s /bin/zsh -D gitpod
RUN addgroup gitpod gitpod
# To emulate the workspace-session behavior within dazzle build env
RUN mkdir /workspace && chown -hR gitpod:gitpod /workspace

ENV HOME=/home/gitpod
WORKDIR $HOME

USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success"

# Install oh-my-zsh for gitpod
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Optionally, customize the .zshrc file
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="gallois"/g' ~/.zshrc
RUN sed -i 's/plugins=(git)/plugins=(bundler docker git github mix rails rake ruby sudo)/g' ~/.zshrc
# RUN echo "alias ll='ls -al'" >> ~/.zshrc

USER gitpod
RUN zsh
# Custom PATH additions
ENV PATH=$HOME/.local/bin:$PATH

CMD ["zsh"]
