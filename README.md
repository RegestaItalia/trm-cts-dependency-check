# TRM CTS Dependency Check

This is a lightweight ABAP check developed for **ABAP TRM (Transport and Repository Management)** workflows. It ensures that, **before releasing a transport**, all declared TRM dependencies have already been released—preventing broken imports and inconsistent states in target systems.

> 💡 Note: For systems on S/4HANA or SAP_BASIS >= 7.55, use the `CTS_REQUEST_CHECK` BAdI to plug in this validation logic.

## 💡 Purpose

When using TRM, ABAP packages often declare dependencies on other packages. If a package is released and imported **before** its dependencies, this can cause runtime or activation errors.

**This check prevents such scenarios by enforcing dependency order at release time.**

## ⚙️ How It Works

- Hooks into the **CTS (Change and Transport System)** during the release process.
- Scans the transport object list for packages with TRM dependencies.
- For each dependency, verifies whether it has already been released.
- If unresolved dependencies are found:
  - The release is aborted.
  - A clear error message is shown with the list of pending releases.

## 📦 Use Case

- Used in ABAP systems adopting **TRM** for modular package development.
- Especially useful for packages that use **shared utility libraries**.

## 🚀 Installation

Install with TRM command `trm install trm-cts-dep-check`.

## 👥 Authors

Developed by [Regesta](https://www.regestaitalia.eu/).

## 📝 License

[MIT License](LICENSE)
