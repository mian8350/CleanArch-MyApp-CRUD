# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and projects
COPY MyApp.Api.sln ./
COPY MyApp.Api/ MyApp.Api/
COPY MyApp.Application/ MyApp.Application/
COPY MyApp.Core/ MyApp.Core/
COPY MyApp.Infrastructure/ MyApp.Infrastructure/

# Restore and build
RUN dotnet restore MyApp.Api.sln
RUN dotnet publish MyApp.Api -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyApp.Api.dll"]
