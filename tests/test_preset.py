"""`preset:` on a domain reads a named set of defaults in woodwork/data/presets.json; the domain overrides it (founding spec REQ-007)."""

import json

from conftest import ENGINE, compile_typ, panic_message, pdf_text

HEAD = '#import "/woodwork/woodwork.typ": *\n'
LINES = """  #var("b", 140, "mm", label: "Largeur", norm-section: "3.1")
  #var("h", 200, "mm", label: "Hauteur")
  #eq("A", `b * h`, label: "Section", norm-section: "4.2.1.1")
"""


def render(domain_args):
    ok, _, err, pdf = compile_typ(HEAD + '#domain("t", %s)[\n%s]\n' % (domain_args, LINES))
    assert ok, err
    return pdf_text(pdf)


def test_a_preset_prints_as_its_settings_written():
    report = json.loads((ENGINE / "data" / "presets.json").read_text(encoding="utf-8"))["presets"]["report"]
    written = ", ".join('%s: "%s"' % (k, v) for k, v in report.items())
    assert render('preset: "report", norm: "SIA 265"') == render(written + ', norm: "SIA 265"')


def test_the_domain_overrides_its_preset():
    t = render('preset: "report", norm: "SIA 265", norm-position: "footnote"')
    # every citation goes to a footnote: the preset's "right" is overridden
    assert t.splitlines()[-2:] == ["1SIA 265 3.1", "2SIA 265 4.2.1.1"], t


def test_an_unknown_preset_is_refused_with_the_list():
    ok, _, err, _ = compile_typ(HEAD + '#domain("t", preset: "rapport")[]\n')
    assert not ok
    assert panic_message(err) == 'domain: no preset "rapport" in woodwork/data/presets.json -- the presets are "report"', err


def test_a_preset_may_set_units_and_norm():
    ok, _, err, pdf = compile_typ(HEAD + '#domain("t", preset: "office")[\n  #var("M_d", 12.4, "kNm", norm-section: "4.2.3")\n]\n',
                                  files={"woodwork/data/presets.json": json.dumps({"presets": {"office": {"units": ["Nm"], "norm": "SIA 265", "norm-position": "right"}}})})
    assert ok, err
    assert pdf_text(pdf).strip().endswith("12400 Nm SIA 265 4.2.3"), pdf_text(pdf)
