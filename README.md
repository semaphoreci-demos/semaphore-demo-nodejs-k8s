# Semaphore demo CI/CD pipeline using Node.js

Example application and CI/CD pipeline showing how to run a JavaScript project
on Semaphore 2.0. Project consists of a Node.js server based on Nest.js. 
The code is written in TypeScript.

## CI/CD on Semaphore

Fork this repository and use it to 
[create a project](https://docs.semaphoreci.com/article/63-your-first-project).

The CI pipeline will look like this:

![CI pipeline on Semaphore](.semaphore/pipeline.png)

The example pipeline contains 2 blocks:

- Build
 - Install Dependencies: installs and caches all npm dependencies
- Test
 - Lint: Runs tslint to check project files codestyle
 - Unit tests: Runs Unit Tests
 - E2E tests: Runs E2E tests through jest on server.

Then, if all checks are ok, we move to build pipeline. It consists of one block

 - Build: build container and push it into google repository

Then, after we've built our apps we move to deploy pipeline.
It  also consists of one block for client and of two for server.
As you can see deploy pipelines of client and server depend only on their own build step
and therefore could be run in parallel.

 - Deploy
    - Deploy server to k8s, pdate k8s deployment using deployment config
    - Tag container if all went well

## Local project setup

This project requires a PostgreSQL database. If you don't have one you can
launch a Docker container to have one.

### Configuration

Copy sample files:

```bash
$ cp .sample.env .env
```

Launch db:

```bash
$ docker-compose up
```

### Configure and launch app

Install dependencies:

```bash
$ npm install
```

Copy app and db config:

```bash
$ cp sample.env .env
$ cp ormconfig.sample.json ormconfig.json
```

Run migrations:

```bash
# apply migrations forward
$ npm run migrate:up

# to revert last migration
$ npm run migrate:revert
```

Running the app:

```bash
# development mode
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

Run static code analysis:

```bash
$ npm run lint
```

Run unit and end-to-end tests:

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Deploy configuration

Check out `.semaphore/` folder - steps described there have helpful comments to help you figure out what commands are doing.
Also check out `.semaphore/secrets` folder. To configure deploy you need to create and populate all those secrets.
Copy each secret file into file without `.sample` in filename and populate it. All of them have useful description comments to help you out.

## License

Copyright (c) 2019 Rendered Text

Distributed under the MIT License. See the file [LICENSE.md](./LICENSE.md).
