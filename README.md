# Building Docker using AWS creds 

This is an example gleaned from this discussion on [Stack Overflow]


> Using docker buildkit, so requires at least docker 18.09 or newer.

Allow the injection of secrets as a volume mount for a single RUN line. That mount does not get written to the image layers, so you can access the secret during build without worrying it will be pushed to a public registry server.

Example dockerfile

```
FROM python:3
RUN pip install awscli
RUN --mount=type=secret,id=aws,target=/root/.aws/credentials aws s3 ls
```

And you build it as follows:

```
DOCKER_BUILDKIT=1 docker build -t your_image --secret id=aws,src=$HOME/.aws/credentials .
```

## Example

```
DOCKER_BUILDKIT=1 docker build -t test --secret id=aws,src=$HOME/.aws/credentials .

[+] Building 0.6s (7/7) FINISHED
 => [internal] load build definition from Dockerfile 
 => => transferring dockerfile: 43B
 => [internal] load .dockerignore
 => => transferring context:
 => [internal] load metadata for docker.io/library/python:3
 => [1/3] FROM docker.io/library/python:3@sha256:39c16d1a064c0239939d4ed52923b736c25b389e6ea439d5652b8fc9564ede76
 => CACHED [2/3] RUN pip install awscli
 => CACHED [3/3] RUN --mount=type=secret,id=awscreds,target=/root/.aws/credentials aws s3 ls
 => exporting to image
 => => exporting layers
 => => writing image sha256:17cafd1cdd3e6d14035ebaeae25bceb54f8cdc985a5917e9bf31502fc070a80f
 => => naming to docker.io/library/test
 ```


 [Stack Overflow]: https://stackoverflow.com/questions/36354423/which-is-the-best-way-to-pass-aws-credentials-to-docker-container/36357388#56077990
