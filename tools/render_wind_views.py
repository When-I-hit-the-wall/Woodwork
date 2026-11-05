"""The axonometric views of the buildings of SIA 261 Anhang C that vent.xlsx shows on each table's sheet: drawn once from Woodcore's 3D model of the wind's buildings, every zone in its own colour and named, and kept as PNG in source/actions/wind-views/.

    python tools/render_wind_views.py <path of Woodcore>

Reads Woodcore's calc/domains/wind_geometry.py (the faces of each table's building, in its table's proportions) and calc/domains/model3d.py (the projection), writes the SVG of each view and turns it into PNG with Playwright's Chromium, driven from Node (`node` and its `playwright` module on the PATH), and reduces it to 256 colours with Pillow. A maintainer's tool: tools/build_actions.py reads the PNG, never Woodcore.
"""

import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "source" / "actions" / "wind-views"

# The views each table's sheet shows: (name, yaw, pitch), seen from the corner of walls A and D, from the opposite corner, and from above.
VIEWS = (("1", -131.0, 28.0), ("2", 49.0, 28.0), ("3", -131.0, 68.0))
WIDTH, HEIGHT = 520, 400

# One colour per zone, in the order of the zones' names; light enough that the zone's name reads over it.
ZONE_COLOURS = ("#9ecae1", "#fdae6b", "#a1d99b", "#fc9272", "#bcbddc", "#fdd0a2", "#c7e9c0", "#fbb4c3", "#c6dbef", "#d9d9a0", "#e5c494", "#b3e2cd", "#f4cae4", "#e6f5c9", "#fff2ae", "#cbd5e8")


def zone_colours(keys):
    return {k: ZONE_COLOURS[i % len(ZONE_COLOURS)] for i, k in enumerate(sorted(keys))}


def svg(number, view, g, m3):
    sc = g.scene(number, phi=None, show_forces=False, show_phi=False, show_dims=True)
    items = m3.render(sc, view)
    colours = zone_colours(g.surfaces(number))
    base = m3.palette("light")
    for it in items:
        if it["kind"] == "polygon" and it.get("key") in colours:
            it["role"] = "zone:" + it["key"]
            it["hatch"] = False
            base["zone:" + it["key"]] = colours[it["key"]]
    return m3.to_svg(items, view, base)


def main():
    woodcore = Path(sys.argv[1]).resolve()
    sys.path.insert(0, str(woodcore / "calc"))
    from domains import model3d as m3, wind_geometry as g
    from norms import sia261_wind
    OUT.mkdir(parents=True, exist_ok=True)
    tmp = Path(tempfile.mkdtemp(prefix="woodwork-views-"))
    jobs = []
    for number in sia261_wind.NUMBERS:
        for name, yaw, pitch in VIEWS:
            view = m3.View(yaw=yaw, pitch=pitch, width=WIDTH, height=HEIGHT)
            src = tmp / ("T%s-%s.svg" % (number, name))
            src.write_text(svg(number, view, g, m3), encoding="utf-8")
            jobs.append([str(src), str(OUT / ("T%s-%s.png" % (number, name)))])
    count = len(jobs)
    (tmp / "jobs.json").write_text(json.dumps(jobs), encoding="utf-8")
    script = """
const {chromium} = require('playwright'); const fs = require('fs');
(async () => {
  const jobs = JSON.parse(fs.readFileSync(process.argv[1], 'utf8'));
  const browser = await chromium.launch();
  const page = await browser.newPage({viewport: {width: %d, height: %d}, deviceScaleFactor: 2});
  for (const [src, png] of jobs) {
    await page.setContent('<html><body style="margin:0;background:#fff">' + fs.readFileSync(src, 'utf8') + '</body></html>');
    await page.locator('svg').screenshot({path: png});
  }
  await browser.close();
})();
""" % (WIDTH, HEIGHT)
    subprocess.run(["node", "-e", script, str(tmp / "jobs.json")], check=True, env=dict(__import__("os").environ, NODE_PATH=subprocess.run(["npm", "root", "-g"], capture_output=True, text=True).stdout.strip()))
    # a drawing of flat colours: 256 colours lose nothing that shows, and make the file a third as large
    from PIL import Image
    for _src, png in jobs:
        Image.open(png).convert("RGB").quantize(256, dither=Image.Dither.NONE).save(png, optimize=True)
    print("%d views of %d tables" % (count, len(sia261_wind.NUMBERS)))


if __name__ == "__main__":
    main()
