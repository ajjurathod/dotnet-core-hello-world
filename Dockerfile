FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /app

# Copy project files and build
COPY . ./
RUN dotnet publish -c Release -o out

# Set working directory and run the app
WORKDIR /app/out
ENV ASPNETCORE_URLS=http://0.0.0.0:5000
ENTRYPOINT ["dotnet", "dotnet-core-hello-world.dll"]
