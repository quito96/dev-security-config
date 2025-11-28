# 🛡️ NPM Supply Chain Defense Kit

**Automated protection against malicious npm packages and supply chain attacks (e.g., Shai-Hulud / Sha1-Hulud).**

This repository provides a standardized, hardened configuration for Node.js developers. It enforces strict security policies globally to prevent the automatic execution of malicious scripts during package installation.

## 🚨 Why this exists
Recent supply chain attacks (like the "Shai-Hulud" worm in late 2025) utilize `preinstall` and `postinstall` scripts to execute malware immediately upon `npm install`. Traditional scanning often catches these too late.

**The most effective prevention is to disable installation scripts by default.**

## 📂 What's inside?

*   **`.npmrc`**: A hardened configuration file that disables scripts (`ignore-scripts=true`) and enforces strict versioning.
```bash
audit=true        # enable automatic npm security audits (additional safety layer)
package-lock=true # ensure the lockfile is consistently used for installs
fund=false        # disable funding messages (DX only, no security impact)
```

*   **`.cursorrules`**: Security instructions for AI Coding Assistants (Cursor, Windsurf, Copilot) to prevent them from accidentally suggesting insecure commands.
*   **`setup.sh`**: A script that injects these configurations into your project.

## 🚀 Quick Start (Project Injection)

This workflow is designed to "inject" security configurations into an existing project and then remove the installer.

1.  **Navigate to your project root**:
    ```bash
    cd ~/my-projects/my-node-app
    ```

2.  **Clone this repository**:
    ```bash
    git clone https://github.com/quito96/dev-security-config.git
    ```

3.  **Run the injection script**:
    ```bash
    cd dev-security-config
    chmod +x setup.sh
    ./setup.sh
    ```

4.  **Follow the prompts**:
    *   The script will copy `.npmrc`, `.cursorrules`, and the `Security-Advisory` folder to your project root (`..`).
    *   It will generate a `SECURITY_SETUP_REPORT.md` in your project.
    *   **Cleanup**: It will ask if you want to delete the `dev-security-config` folder. Say **Yes** (y) to keep your project clean.

## ✅ Verification

After running the script, your project should contain:
*   `.npmrc` (with `ignore-scripts=true`)
*   `.cursorrules`
*   `Security-Advisory/` folder
*   `SECURITY_SETUP_REPORT.md`

Check the report for a summary of changes.

## 🤖 AI Assistant Configuration (Cursor / Windsurf)

AI assistants often hallucinate commands like `npm install` without safety flags. This repo includes a `.cursorrules` file.

Your AI assistant will now adhere to the following protocols:
*   Never run `npm install` without flags.
*   Always prefer `npm ci` in CI/CD pipelines.
*   Alert on suspicious files (e.g., `setup_bun.js`, `bun_environment.js`).

## 🛠 Handling Legitimate Scripts

Since `ignore-scripts=true` blocks all scripts, some valid packages (like `esbuild`, `puppeteer`, or `husky`) might break.

**Recommended Workflow:**
Do not turn off the global protection. Instead, use `allow-scripts` to whitelist only the packages you trust.

1.  Install `allow-scripts` in your project:
    ```bash
    npm install --save-dev allow-scripts
    ```
2.  Add approved packages to your `package.json`:
    ```json
    "allowScripts": {
      "esbuild": "true"
    }
    ```
3.  Run them explicitly:
    ```bash
    npx allow-scripts
    ```

## 📜 Disclaimer
This configuration is provided as-is. While it significantly reduces the attack surface for supply chain attacks, no security measure is 100% foolproof. Always audit your dependencies.

## 📄 License
MIT
