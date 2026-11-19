# Libraries

Shared OpenSCAD libraries, added as **git submodules** so versions are pinned.

| Library | Path | License | Purpose |
|---------|------|---------|---------|
| [BOSL2](https://github.com/BelfrySCAD/BOSL2) | `libs/BOSL2` | BSD-2-Clause | Shapes, attachments, rounding/chamfers, threads, screws, gears, hinges, paths… ([docs](https://github.com/BelfrySCAD/BOSL2/wiki)) |

## Using a library in a project

Include it with a path relative to the project's `.scad` file:

```openscad
include <../../libs/BOSL2/std.scad>
include <../../libs/BOSL2/threading.scad>   // optional extras
```

## Commands

```sh
# fetch libraries after cloning
git submodule update --init --recursive

# update a library to its latest version (then commit the new pointer)
git submodule update --remote libs/BOSL2

# add a new library
git submodule add <git-url> libs/<Name>
```

When adding a library, add it to the table above and verify its license allows use in a CC BY-NC-SA project.
