# Stafl DevContainer

See https://staflsystems.atlassian.net/wiki/spaces/EM/pages/196673537/Stafl+DevContainer for usage.

## Publishing Image for CI

- Create personal access token with permission to edit packages.
- Create `.env` file with contents `export CR_PATH=<your_token_here>`
- Run `source .env`
- Run `docker build -t ghcr.io/staflsystems/stafl-devcontainer-ci .`
- Run `docker push ghcr.io/staflsystems/stafl-devcontainer-ci:latest`

