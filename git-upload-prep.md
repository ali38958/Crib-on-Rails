# Git Upload Preparation Plan

## Overview
The goal is to prepare the repository for a clean Git upload. We will ensure that sensitive data like API keys, environment variables, and AI skills (contained within the `.agents` folder) are strictly excluded from version control. We will also ensure the repository is free of unnecessary clutter.

## Project Type
**WEB** (Ruby on Rails Application)

## Success Criteria
- `.agents` directory is fully ignored by Git.
- `.env` files are ignored by Git, and any previously tracked `.env` files are untracked.
- No sensitive keys or AI agent instructions are leaked.
- The repository is clean and ready for a safe `git push`.

## Tech Stack
- Git
- Ruby on Rails

## File Structure
- `.gitignore` (Target for modifications)
- `.agents/` (To be ignored)
- `.env` (To be ignored)

## Task Breakdown

### Task 1: Update .gitignore for Security
- **Agent**: `security-auditor`
- **Skill**: `clean-code`
- **Priority**: P0
- **Dependencies**: None
- **INPUT**: Current `.gitignore`
- **OUTPUT**: Updated `.gitignore` with `/.agents/` and `/.env*` explicitly ignored (uncommenting `/.env*` if it was commented out).
- **VERIFY**: Confirm `/.agents/` and `/.env*` are present and uncommented in `.gitignore`.

### Task 2: Untrack Sensitive Files (if already tracked)
- **Agent**: `devops-engineer`
- **Skill**: `powershell-windows`
- **Priority**: P0
- **Dependencies**: Task 1
- **INPUT**: Git index
- **OUTPUT**: Sensitive files removed from Git cache (e.g., `git rm -r --cached .agents .env`).
- **VERIFY**: Run `git status` to ensure `.agents` and `.env` are not listed as tracked or staged changes.

### Task 3: Clean up Temporary/Messy Files
- **Agent**: `devops-engineer`
- **Skill**: `clean-code`
- **Priority**: P1
- **Dependencies**: None
- **INPUT**: Project root directory
- **OUTPUT**: Identify any unnecessary scratch files (`prompt.txt`, `error.txt`, `compact001.md`, etc.) and optionally remove them or ignore them based on user preference.
- **VERIFY**: Directory listing is clean and concise.

## Phase X: Verification
- [x] Run `git status` to verify the working tree is clean or only has intended changes.
- [x] Run `git check-ignore -v .agents/agent/project-planner.md` to confirm the AI skills folder is properly ignored.
- [x] Run `git check-ignore -v .env` to confirm environment variables are properly ignored.
- [x] Review `git diff --cached` to ensure no sensitive data is staged.

## ✅ PHASE X COMPLETE
- Security: ✅ AI agents/skills and environment variables are strictly ignored from version control.
- Workspace: ✅ Temporary files and scratch data have been deleted.
- Git Index: ✅ All sensitive files have been untracked and removed from the cache.
- Ready for upload.
