# ----------------------
# 1️⃣ Build Stage
# ----------------------
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# Copy csproj first to leverage Docker cache
COPY MyWebApp/*.csproj ./MyWebApp/
WORKDIR /source/MyWebApp
RUN dotnet restore

# Copy all source files
COPY MyWebApp/. .
RUN dotnet publish -c Release -o /app

# ----------------------
# 2️⃣ Runtime Stage
# ----------------------
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

COPY --from=build /app .

EXPOSE 5000
ENV DOTNET_RUNNING_IN_CONTAINER=true \
    ASPNETCORE_URLS=http://0.0.0.0:5000

ENTRYPOINT ["dotnet", "MyWebApp.dll"]
