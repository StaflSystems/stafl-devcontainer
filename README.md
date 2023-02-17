# Stafl DevContainer

## Getting Started

See [confluence page](https://staflsystems.atlassian.net/wiki/spaces/EM/pages/196673537/Stafl+DevContainer) for latest instructions.

## Publishing New Container Image for CI

1. If the token you created when you first pulled the dev-container has read AND write permissions for packages, skip to step 4.

2. [Create a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with read AND write permissions for packages.

3. Login using the token you've just created by running:  
`docker login ghcr.io -u <your_github_username> -p <your token>`

4. Navigate to the `stafl-devcontainer` folder in your host machine (do not do this within your container, it has to be through your host machine whether it's in Windows, WSL, or MacOS) and open a terminal inside the `.devcontainer` folder

5. From the `.devcontainer` folder, run:  
`docker build -t ghcr.io/staflsystems/stafl-devcontainer-ci .`  
(this will take 10+ minutes)

6. To publish the new image run:  
`docker push ghcr.io/staflsystems/stafl-devcontainer-ci:latest`  
(Use a wired ethernet connection for a faster upload)

## Updating Container Image from CI

1. Make sure your personal access token has package read access (if you followed the [setup steps](https://staflsystems.atlassian.net/wiki/spaces/EM/pages/196673537/Stafl+DevContainer), it should already have it).

2. Navigate to the `stafl-devcontainer` folder in your host machine (do not do this within your container, it has to be through your host machine whether it's in Windows, WSL, or MacOS) and open a terminal inside the `.devcontainer` folder

3. From the `.devcontainer` folder, run:  
`docker pull ghcr.io/staflsystems/stafl-devcontainer-ci:latest`  
(This may take a few minutes. Use a wired ethernet connection for a faster download)

