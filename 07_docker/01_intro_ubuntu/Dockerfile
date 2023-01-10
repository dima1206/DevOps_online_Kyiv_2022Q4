FROM ubuntu:22.10

ENV TZ=Europe/Kyiv
RUN apt-get -y update
RUN DEBIAN_FRONTEND="noninteractive"\
  apt-get -y install apache2 tzdata
RUN echo 'Hi there' > /var/www/html/index.html

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]

EXPOSE 80
