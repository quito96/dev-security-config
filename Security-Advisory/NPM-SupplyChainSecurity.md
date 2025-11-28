# NPM Supply Chain Security Protocols
# Auto-generated Security Context for AI Assistants
# Mitigation: Shai-Hulud / Supply Chain Attacks

**Priority:** Critical
**Context:** Node.js / NPM Environment

## Core Directives for AI Assistant
You must adhere to the following security constraints when generating code or terminal commands.

### 1. Installation & Scripts (Highest Priority)
The primary attack vector involves `preinstall` lifecycle scripts.
- **Rule:** Do NOT run or suggest `npm install` without safety flags unless explicitly confirmed by the user.
- **Preferred Command:** Always use `npm install --ignore-scripts` for local development.
- **CI/CD:** In CI environments (GitHub Actions, GitLab CI), ALWAYS use `npm ci` (Clean Install) instead of `npm install`.
- **Config Enforcement:** Suggest adding `ignore-scripts=true` to the project's `.npmrc`.

### 2. Dependency Management
- **Lockfiles:** Treat `package-lock.json` as the immutable source of truth.
- **Versioning:** Prefer pinned versions (e.g., `"1.2.3"`) over ranges (e.g., `"^1.2.3"`) to prevent auto-installation of compromised patch updates.
- **Typosquatting:** Before adding a new package, double-check spelling. Warn if a package name looks suspicious or mimics a popular library (e.g., `react-dom-binding` vs `react-dom-bindings`).

### 3. Threat Detection (Indicators of Compromise)
Alert the user immediately if you scan or generate files matching these patterns:
- **Suspicious Files:** `setup_bun.js`, `bun_environment.js`, or unexplained obfuscated JS files.
- **Suspicious Origins:** Scripts referencing `webhook.site`, `pastebin`, or raw IP addresses.
- **Unexpected Runtime:** The sudden appearance of "bun" related configurations in a Node.js project (Shai-Hulud often installs Bun to bypass Node monitors).

### 4. Remediation Protocol
If a vulnerability is suspected:
1. **HALT:** Stop all execution.
2. **AUDIT:** Check `package.json` for unauthorized script modifications.
3. **CHECK GITHUB:** User should check their GitHub profile for unauthorized public repositories (a known behavior of the Shai-Hulud worm).
4. **ROTATE SECRETS:** Advise rotation of NPM Tokens and `.env` credentials immediately.

---

## Snippets for Immediate Implementation

### Safe `.npmrc` Configuration
(Save this in project root)
```ini
engine-strict=true
ignore-scripts=true
save-exact=true
