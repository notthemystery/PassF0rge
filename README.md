<div align="center">
  <br>
  <img src="icon.png" alt="PassF0rge Logo" width="230">
  <br>
  <h1>PassF0rge</h1>
</div>

PassF0rge is a cross-platform password recovery and credential restoration utility designed for system administrators and developers working in controlled, authorized environments.
It provides a unified interface for running platform-specific recovery modules on Linux and Windows systems.
> ⚠️ Warning: This tool must only be used on systems you own or have explicit permission to access.
---
## 🚀 Features
- Cross-platform support (Linux & Windows)
- Environment-based credential passing
- Modular execution system
- Lightweight native C implementation
- Simple CLI-based workflow
- Designed for recovery and debugging environments
---
## 🧩 How It Works
1. User provides username and password
2. Tool sets environment variables:
   - `USERNAME`
   - `PASSWORD`
3. Platform-specific module is executed:
   - Linux: `./Exploits/Linux/CopyFail`
   - Windows: `Exploits\Windows\RedSun.exe`
4. Module performs recovery workflow using provided environment context
---

## 🛠️ Build Instructions
### Linux
```bash
gcc main.c -o PassF0rge

Windows (MSVC)

cl main.c /Fe:PassF0rge.exe

⸻

▶️ Usage

Linux

./PassF0rge username password

Windows

PassF0rge.exe username password

⸻

🔐 Notes

* Credentials are passed via environment variables only
* Modules are executed locally depending on OS
* Ensure required binaries exist in the Exploits/ directory
* Designed for controlled recovery workflows only

