from mcr.microsoft.com/powershell:preview

COPY . ./app
WORKDIR /app
RUN chmod 777 "./GetStar.ps1"
RUN chmod 777 "./DelIng.ps1"
RUN chmod 777 "./PostIng.ps1"
RUN chmod 777 "./CheckStar.ps1"
ENTRYPOINT ["pwsh-preview", "./GetStar.ps1"]

#docker -t get-star -f Dockerfile .