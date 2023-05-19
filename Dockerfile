FROM ubuntu:latest

CMD ["bash"]
ARG DOCKER_UID=1000
ARG DOCKER_USER=is-user
ARG DOCKER_PASSWORD=is-user
ENV TZ=Asia/Tokyo
ENV TERM=xterm-256color
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 
RUN echo $TZ > /etc/timezone

RUN apt-get update 
RUN apt-get install -y tzdata build-essential dnsutils emacs file git \
    iputils-ping net-tools sudo telnet traceroute vim wget zip curl \
    net-tools traceroute inetutils-traceroute iproute2 sqlite3 \
    openjdk-17-jdk \
    language-pack-ja-base language-pack-ja 
RUN apt-get -y clean 
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get install -y nvm
RUN nvm install --lts
RUN nvm default --lts
RUN nvm alias default lts/*


RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd
USER $DOCKER_USER
WORKDIR /home/$DOCKER_USER/


RUN touch /home/$DOCKER_USER/.sudo_as_admin_successful
COPY --chown=is-user:is-user .emacs.d/ /home/$DOCKER_USER/.emacs.d/

RUN emacs --script /home/$DOCKER_USER/.emacs.d/package.el