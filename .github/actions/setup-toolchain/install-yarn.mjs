// Installs the Yarn version pinned in package.json's "packageManager" field
// (e.g. "yarn@1.22.22+sha512.<hex>") into RUNNER_TEMP and adds it to PATH.
// Only uses Node.js and its bundled npm, so no curl/tar/sha512sum is needed.

import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { appendFileSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const fail = message => {
  console.log(`::error::${message}`);
  process.exit(1);
};

const { packageManager } = JSON.parse(readFileSync('package.json', 'utf8'));
const match = /^yarn@(\d+\.\d+\.\d+)\+sha512\.([0-9a-f]{128})$/.exec(packageManager ?? '');
if (!match) {
  fail(`Unexpected "packageManager" in package.json: ${packageManager}`);
}
const [, version, expectedSha512] = match;

const url = `https://registry.npmjs.org/yarn/-/yarn-${version}.tgz`;
const response = await fetch(url);
if (!response.ok) {
  fail(`Downloading ${url} failed: HTTP ${response.status}`);
}
const tarball = Buffer.from(await response.arrayBuffer());

const actualSha512 = createHash('sha512').update(tarball).digest('hex');
if (actualSha512 !== expectedSha512) {
  fail(`Checksum mismatch for yarn-${version}.tgz: expected ${expectedSha512}, got ${actualSha512}`);
}
console.log(`yarn-${version}.tgz: SHA-512 OK`);

const dir = join(process.env.RUNNER_TEMP, 'yarn');
mkdirSync(dir, { recursive: true });
const tarballPath = join(dir, `yarn-${version}.tgz`);
writeFileSync(tarballPath, tarball);

// Install the verified local tarball (no registry access, no install scripts).
execFileSync(
  'npm',
  ['install', '--prefix', dir, '--ignore-scripts', '--no-audit', '--no-fund', '--no-save', tarballPath],
  { stdio: 'inherit' },
);

appendFileSync(process.env.GITHUB_PATH, `${join(dir, 'node_modules', '.bin')}\n`);
