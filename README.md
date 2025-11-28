# 🛡️ NPM Supply Chain Defense Kit

**Automated protection against malicious npm packages and supply chain attacks (e.g., Shai-Hulud / Sha1-Hulud).**

This repository provides a standardized, hardened configuration for Node.js developers. It enforces strict security policies globally to prevent the automatic execution of malicious scripts during package installation.

## 🚨 Why this exists
Recent supply chain attacks (like the "Shai-Hulud" worm in late 2025) utilize `preinstall` and `postinstall` scripts to execute malware immediately upon `npm install`. Traditional scanning often catches these too late.

**The most effective prevention is to disable installation scripts by default.**

## 📂 What's inside?

*   **`.npmrc`**: A hardened configuration file that disables scripts (`ignore-scripts=true`) and enforces strict versioning.
*   **`.cursorrules`**: Security instructions for AI Coding Assistants (Cursor, Windsurf, Copilot) to prevent them from accidentally suggesting insecure commands.
*   **`setup.sh`**: A safe setup script to apply these settings to your local machine or project.

## 🚀 Quick Start

To secure your environment, clone this repo and run the setup script.

```bash
git clone https://github.com/quito96/dev-security-config.git ~/npm-supply-chain-defense
cd ~/npm-supply-chain-defense
chmod +x setup.sh
./setup.sh
```

### Installation Options

The script offers two modes:

1.  **Global Install**: Symlinks the secure `.npmrc` to your user home directory (`~/.npmrc`). This protects ALL your projects by default.
2.  **Local Install**: Copies `.npmrc` and `.cursorrules` to your current directory. Useful for securing specific projects.

**Safety Note:** The script checks for existing files and will NOT overwrite them without asking or skipping entirely. It does not modify your `.git` configuration.

## ✅ Verification

After running the script (Global mode), check your active configuration:

```bash
npm config list
```

You should see `ignore-scripts = true`.

## 🤖 AI Assistant Configuration (Cursor / Windsurf)

AI assistants often hallucinate commands like `npm install` without safety flags. This repo includes a `.cursorrules` file.

If you choose **Local Install**, this file is copied to your project root.
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
