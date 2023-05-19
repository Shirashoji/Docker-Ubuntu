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
RUN apt-get install -y \
  build-essential \
  curl \
  dnsutils \
  emacs \
  file \
  git \
  inetutils-traceroute \
  iproute2 \
  iputils-ping \
  net-tools \
  npm \
  openjdk-17-jdk \
  sqlite3 \
  sudo \
  telnet \
  traceroute \
  tzdata \
  vim \
  wget \
  zip \
  language-pack-ja \
  language-pack-ja-base

RUN apt-get -y clean 
RUN rm -rf /var/lib/apt/lists/*

RUN npm install n -g
RUN n lts
RUN npm install npm@latest -g


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