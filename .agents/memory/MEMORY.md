# Memory Index

## Project
- [project] Always create a new dedicated branch for major code changes → project-conventions.md
- [project] AG Kit only supports Gemini CLI and Google Antigravity (not other AI coding tools) → project-conventions.md
- [project] Component metadata uses SemVer while toolkit releases use CalVer → tech-decisions.md
- [auth] Implemented server-side JWT auto-refresh in `ApplicationController#current_user` to transparently issue a new `auth_token` if it expires but a valid `refresh_token` exists. Removed redundant `authenticate_request` overrides in role BaseControllers. This handles both full page navigations and Turbo fetch requests seamlessly.
