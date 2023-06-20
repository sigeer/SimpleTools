from demisto/powershell:7.2.1.34341

COPY . ./app
WORKDIR /app
ENV TERM=xterm-256color
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN chmod 777 *
ENTRYPOINT ["pwsh", "./GetStar.ps1 -LessThan 1"]

#docker -t get-star -f Dockerfile .
#docker run -d get-star