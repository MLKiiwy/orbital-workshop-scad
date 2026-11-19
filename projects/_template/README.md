# <Project name>

> One-line summary of the object.

## What

What we are building: the object, its main features, how it is used.

## Why

The problem it solves / the motivation. Constraints that drove the design
(must fit X, needs to hold Y kg, mounts on Z…).

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `width` | 40 | Outer width (mm) |
| `depth` | 30 | Outer depth (mm) |
| `height` | 20 | Outer height (mm) |
| `wall` | 2 | Wall thickness (mm) |

## Printing

Printer and filament defaults: see [docs/print-setup.md](../../docs/print-setup.md).

- Slicer profile: 0.20mm Balanced Strength @BBL H2D
- Material:
- Layer height / nozzle:
- Infill / walls:
- Supports: none
- Orientation:

## Hardware (BOM)

| Qty | Item | Notes |
|-----|------|-------|
| | | |

## Export

```sh
./scripts/export.sh projects/<project-name>/<project-name>.scad
```

## Status

- [ ] Design
- [ ] Test print
- [ ] Final
