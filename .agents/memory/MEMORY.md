# Memory Index

## Project
- [project] Always create a new dedicated branch for major code changes → project-conventions.md
- [project] AG Kit only supports Gemini CLI and Google Antigravity (not other AI coding tools) → project-conventions.md
- [project] Component metadata uses SemVer while toolkit releases use CalVer → tech-decisions.md
- [auth] Implemented global `fetch` interceptor in `application.js` to automatically catch 401 Unauthorized responses, hit `/refresh` with the `refresh_token`, and transparently retry the original request for Turbo and standard AJAX calls.
