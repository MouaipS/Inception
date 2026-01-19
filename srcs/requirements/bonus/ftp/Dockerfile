FROM debian:bookworm

RUN apt update -y && apt install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*
# vsftpd = Very Secure FTP Daem

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY tools/setup.sh /usr/local/bin
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 21 21000-21010

ENTRYPOINT [ "/usr/local/bin/setup.sh" ]
CMD [ "vsftpd", "/etc:vsftpd.conf" ]