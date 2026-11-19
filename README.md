# orbital-workshop-scad

A monorepo of my 3D modeling / 3D printing projects, written in [OpenSCAD](https://openscad.org).

Every model is **parametric** and fully metric (millimetres, SI units): open it, tweak the parameters (in the code or in the
OpenSCAD Customizer), and export an STL/3MF for your printer.

## License

[![CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

Everything in this repository is licensed under
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) — see [LICENSE](LICENSE).

- ✅ Free to use, print, modify and share — give credit, and share derivatives under the same license.
- ❌ **No commercial use** (selling prints, models or derivatives) without my prior written agreement. Contact me if you are interested.
- The author keeps all commercial rights.

Third-party libraries in [`libs/`](libs/) keep their own licenses.

## Repository layout

```
projects/<project-name>/   one directory per 3D project
  README.md                what we build and why, parameters, print settings
  <project-name>.scad      the parametric model
  exports/                 generated STL/3MF (git-ignored)
projects/_template/        starting point for a new project
libs/                      shared OpenSCAD libraries (git submodules, e.g. BOSL2)
scripts/                   helper scripts (setup, checks, export)
```

## Setup

1. Install OpenSCAD (a recent **snapshot** is recommended for the fast Manifold renderer):
   - macOS: `brew install --cask openscad@snapshot` (or `brew install --cask openscad`)
   - Linux: `sudo apt install openscad` or `flatpak install flathub org.openscad.OpenSCAD`
   - Windows: `winget install OpenSCAD.OpenSCAD` or https://openscad.org/downloads.html
2. Clone with libraries and verify the environment:
   ```sh
   git clone --recurse-submodules <repo-url>
   cd orbital-workshop-scad
   ./scripts/setup.sh          # inits submodules + runs the check
   ./scripts/check-openscad.sh # check only
   ```

### VSCode

Recommended extensions (VSCode will propose them from [.vscode/extensions.json](.vscode/extensions.json)):

- [OpenSCAD Preview](https://marketplace.visualstudio.com/items?itemName=thijsdaniels.vscode-openscad-preview) (`thijsdaniels.vscode-openscad-preview`) — live 3D preview of `.scad` files.
- [OpenSCAD](https://marketplace.visualstudio.com/items?itemName=Antyos.openscad) (`Antyos.openscad`) — syntax highlighting, snippets, open in OpenSCAD, export.

## Workflow

```sh
# start a new project
cp -R projects/_template projects/my-thing
mv projects/my-thing/main.scad projects/my-thing/my-thing.scad

# export (output goes to projects/my-thing/exports/)
./scripts/export.sh projects/my-thing/my-thing.scad
./scripts/export.sh projects/my-thing/my-thing.scad 3mf -D width=60 -D height=20
```

Libraries are included with a path relative to the project file, e.g.
`include <../../libs/BOSL2/std.scad>`, so models work identically in VSCode,
the OpenSCAD GUI and the command line.

## Projects

| Project | Description |
|---------|-------------|
| [bike-battery-wall-holder](projects/bike-battery-wall-holder/) | Wall-mounted drop-in cradle for an e-bike battery, with charging-port access |
