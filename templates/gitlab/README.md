# GitLab CI Templates for Mender

`mendersoftware/mender-ci-tools` image is used for the jobs. It's based on `alpine` with pre-installed `mender-cli` and `mender-artifact` tools.

Pipelines examples can be found in the related [folder](../../examples/gitlab/).

## Setup
The templates, which interact with a Mender server, requires the following environment variables are set in th GitLab CI/CD Settings:
- `MENDER_SERVER_URL` (optional): Mender server's URL including protocol (default: https://hosted.mender.io)
- `MENDER_SERVER_ACCESS_TOKEN`: Mender Personal Access Token (read the [documentation](https://docs.mender.io/server-integration/using-the-apis#personal-access-tokens) for more information)

## Templates
The templates are designed in a way that defined jobs can extend them, which gives flexibility in using them in custom stages and allows to build pipelines to work across different environments.

`MENDER_ARTIFACTS_FOLDER` environment variable is pre-defined and shared across all templates. It's used for storing built Mender artifacts and transferring
them across all jobs in the CI/CD pipeline.

### Build Artifact
[.build:mender:artifact](mender-artifact-build.gitlab-ci.yml) template can be used to build a Mender artifact in the `script` section. `before_script` is used for creating the `MENDER_ARTIFACTS_FOLDER` folder. If it's overwritten, then make sure your script contains this step.

Mender artifacts in the `MENDER_ARTIFACTS_FOLDER` folder will be uploaded as GitLab CI artifacts and shared across jobs in a pipeline.

### Upload Artifact
[.upload:mender:artifact](mender-artifact-upload.gitlab-ci.yml) template requires `MENDER_SERVER_URL` and `MENDER_SERVER_ACCESS_TOKEN` variables to work and can be used to upload a Mender artifacts from `MENDER_ARTIFACTS_FOLDER` folder to a Mender server.

### Create Deployment
[.create:mender:deployment](mender-deployment-create.gitlab-ci.yml) template requires `MENDER_SERVER_URL` and `MENDER_SERVER_ACCESS_TOKEN` variables to work and can be used to create a deployment on a Mender server.

It's possible to set custom values by setting the following environment variables:
- `MENDER_DEPLOYMENT_GROUP`: The name of Mender devices group a deployment will be triggered to. One of `MENDER_DEPLOYMENT_GROUP` or `MENDER_DEVICES_LIST` is required.
- `MENDER_DEVICES_LIST`: The list of Mender devices a deployment will be triggered to.
- `MENDER_DEPLOYMENT_NAME` (optional): The name of Mender deployment (default: `${RELEASE_NAME}_${CI_COMMIT_SHORT_SHA}`).

Deployment group/name and devices list can be set by placing its values into GitLab CI artifacts folder into files with related environment variables as suffix (ex. `MENDER_ARTIFACTS_FOLDER/${ARTIFACT_NAME}MENDER_DEPLOYMENT_GROUP`).
