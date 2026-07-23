"use strict";
const test = require("node:test");
const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");

const packageJson = require("../package.json");
const sourceRoot = path.resolve(__dirname, "..");

test("distribution builds explicitly disable publishing", () => {
  const tokens = packageJson.scripts.dist.trim().split(/\s+/);
  const publishIndex = tokens.indexOf("--publish");
  assert.notEqual(publishIndex, -1);
  assert.equal(tokens[publishIndex + 1], "never");
});

test("CI uses the guarded build path and current action runtimes", () => {
  const buildScript = fs.readFileSync(path.join(sourceRoot, "build.sh"), "utf8");
  const workflow = fs.readFileSync(path.join(sourceRoot, ".github", "workflows", "ci.yml"), "utf8");
  assert.match(buildScript, /\bnpm run dist\b/);
  assert.match(workflow, /actions\/checkout@v7/);
  assert.match(workflow, /actions\/setup-node@v7/);
  assert.match(workflow, /^\s*- run: \.\/build\.sh$/m);
});
