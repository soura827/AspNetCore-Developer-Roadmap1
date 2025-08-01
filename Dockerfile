# ----------------------
# 1️⃣ Build Stage
# ----------------------
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# Copy only the .csproj file (ensure folder exists first)
COPY MyWebApp/*.csproj MyWebApp/

# Restore dependencies
WORKDIR /source/MyWebApp
RUN dotnet restore

# Copy the full source code into the container
COPY . .

# Publish the application (Release mode)
RUN dotnet publish -c Release -o /app

# ----------------------
# 2️⃣ Runtime Stage
# ----------------------
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Copy published files from host to container
COPY out/ .

EXPOSE 5000
ENV DOTNET_RUNNING_IN_CONTAINER=true \
    ASPNETCORE_URLS=http://0.0.0.0:5000

ENTRYPOINT ["dotnet", "MyWebApp.dll"]
