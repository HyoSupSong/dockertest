FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y sudo vim net-tools ssh openssh-server openjdk-11-jdk

ENV USER hyosup

# 접근 환경 설정
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/#UserPAM yes/g' /etc/ssh/sshd_config

#사용자 추가
RUN groupadd -g 999 $USER
RUN useradd -m -r -u 999 -g $USER $USER

# root & user 패스워드 설정
RUN echo 'root:root' | chpasswd
RUN echo $USER':1q2w3e4r!' | chpasswd

# bin bash 설정
RUN chsh -s /bin/bash $USER

# ssh 서비스 재시
RUN service ssh restart && bash

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

USER $USER