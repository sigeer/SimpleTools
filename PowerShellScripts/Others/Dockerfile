from mcr.microsoft.com/powershell:preview

COPY . .
RUN chmod 777 "./GetStar.ps1"
ENTRYPOINT "./GetStar.ps1"

#docker -t get-star -f Dockerfile .