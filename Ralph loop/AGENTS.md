## Purpose

This file is operational only. It tells the agent how to start the app, run checks, and open Chrome DevTools when browser validation is needed.

## Start The App

Set the correct command for this repo before running the Ralph loop.

- Install dependencies: `[install command]`
- Start the app: `[run command]`
- App URL: `[local app url]`

If the project uses Docker, use the Docker command here instead of a local dev server command.

## Browser Validation

When the current implementation plan section needs UI or browser validation, launch Chrome with remote debugging enabled:

- `./custom tools/launch-devtools.sh [local app url]`

Then use the DevTools endpoint:

- `http://127.0.0.1:9222/json/list`

This lets the agent attach to the running browser and inspect the app while building.

## Validation

Run the commands required by the current implementation plan section.

- Tests: `[test command]`
- Typecheck: `[typecheck command]`
- Lint: `[lint command]`

## Notes

Add short repo-specific build or runtime notes here only when they help the agent execute work correctly.
