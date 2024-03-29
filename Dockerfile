FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY *.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet build "dockerDotnet.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dockerDotnet.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dockerDotnet.dll"]