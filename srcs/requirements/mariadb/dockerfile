FROM debian:bookworm

RUN apt update && apt upgrade -y
RUN apt install mariadb-server -y
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql
COPY tools/help.sh /usr/local/bin/help.sh
RUN chmod +x /usr/local/bin/help.sh

ENTRYPOINT ["/usr/local/bin/help.sh"]
CMD ["mysqld"]
