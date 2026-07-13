# Package publishing

`@wireapp/protocol-messaging` is published to the GitHub Packages npm registry at `https://npm.pkg.github.com`.

## Release lifecycle

The `master` workflow installs dependencies from npmjs.com, builds the package, and runs its tests. On a successful push to `master`, the existing Yarn lifecycle continues to:

1. Run `yarn version --minor`.
2. Push the version commit and tag to `master`.
3. Publish the package through the `postversion` script.

The package manifest targets GitHub Packages through `publishConfig`. Workflow permissions default to `contents: read`: the build-and-test and Swift jobs use read-only repository access. Only the release job runs for a push to `master` and receives `contents: write` to push the version commit and tags and `packages: write` to publish the package. It authenticates publication with the repository-provided `GITHUB_TOKEN`.

Before creating the next minor version, the migration workflow reads the package name and current version from `package.json` and checks whether that exact version exists in GitHub Packages. It publishes the current version only when it is missing. This backfills `1.56.0` for `wireapp/wire-webapp`, which depends on that exact version. Future releases skip the backfill when the current version already exists, while still allowing a retry when a previous release committed a version but did not publish it.

Pull requests only build and test, with read-only permissions. They cannot publish packages, push commits, or create tags. The Swift package tests also use read-only repository access.

The npmjs.com Trusted Publisher configuration and OIDC publication are no longer used. Remove the obsolete npmjs.com configuration after the GitHub Packages migration has been confirmed.

## Local installation

To install the package locally, authenticate to GitHub Packages with a GitHub personal access token (classic) that has `read:packages`:

```bash
npm login \
  --scope=@wireapp \
  --auth-type=legacy \
  --registry=https://npm.pkg.github.com
```

Current npm versions otherwise use a browser-oriented login flow. GitHub Packages requires entering your GitHub username and a personal access token (classic) with `read:packages` as the password. Alternatively, configure an environment-backed token in your user-level npm configuration:

```ini
@wireapp:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${GITHUB_PACKAGES_TOKEN}
```

Do not put tokens or other credentials in version control.

## Required GitHub configuration after the first publication

After the first GitHub Packages publication:

1. Confirm that the package is associated with `wireapp/generic-message-proto`.
2. Set or verify the intended package visibility.
3. In the package’s Actions access settings, explicitly grant `wireapp/wire-webapp` read access when required.
4. Verify that the `wireapp/wire-webapp` workflow can read the exact version `@wireapp/protocol-messaging@1.56.0`.

The cross-repository migration is not complete until this access is configured and the exact version is verified from the `wireapp/wire-webapp` workflow.
