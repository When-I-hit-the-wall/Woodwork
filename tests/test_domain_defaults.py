"""What #domain is given holds for its lines, a line overrides it (founding spec REQ-005, REQ-008, ARCH-003, ARCH-007, D-11, D-12, D-14, D-15, D-16)."""

from conftest import compile_typ, panic_message, pdf_text, query

HEAD = '#import "/woodwork/woodwork.typ": *\n'


def text_of(source, lang=None):
    ok, _, err, pdf = compile_typ(HEAD + source, lang=lang)
    assert ok, err
    return pdf_text(pdf)


def test_the_engineers_example_compiles_with_label_left_and_norm_right():
    # T15, written as the engineer wrote it
    t = text_of("""#domain("traction-p12", norm: "SIA 265", label-position: "left", norm-position: "right")[
  #var("N_t_d", 180, "kN", label: "Effort de traction")
  #var("b", 140, "mm", label: "Largeur")
  #var("h", 200, "mm", label: "Hauteur")
  #var("f_t_0_d", 12.8, "N/mm²", label: "Résistance")
  #eq("A", `b * h`, label: "Section")
  #eq("sigma_t_0_d", `N_t_d / A`, label: "Contrainte de traction", norm-section: "4.2.1.1")
  #verify(`sigma_t_0_d <= f_t_0_d`, label: "Nachweis Zug", norm-section: "4.2.1.1 (6)")
]
""")
    lines = t.splitlines()
    assert lines[0].startswith("Effort de traction"), lines
    # the citation stands at the end of its own line, the norm the domain's (a fraction is extracted over three lines)
    assert any(l.startswith("Contrainte de traction") for l in lines), lines
    assert any(l.endswith("= 6.429 N/mm² SIA 265 4.2.1.1") for l in lines), lines
    assert any("Nachweis Zug" in l for l in lines) and "SIA 265 4.2.1.1 (6)" in t, lines


def test_a_line_without_a_clause_cites_nothing():
    t = text_of('#domain("t", norm: "SIA 265", norm-position: "right")[\n  #var("b", 140, "mm", label: "Largeur")\n]\n')
    assert "SIA" not in t, t


def test_a_line_overrides_what_the_domain_set():
    t = text_of("""#domain("t", norm: "SIA 265", label-position: "left", norm-position: "right")[
  #var("h", 200, "mm", label: "Hauteur", norm-section: "3.1")
  #var("b", 140, "mm", label: "Largeur", norm-section: "4.2.1.1", norm-position: "footnote")
  #var("c", 1, "mm", label: "Autre", norm: "SIA 260", norm-section: "4.4")
]
""")
    lines = t.splitlines()
    assert any(l.startswith("Hauteur") and l.endswith("SIA 265 3.1") for l in lines), lines
    # the footnote: a marker on the line, the citation at the foot of the page
    assert any(l.startswith("Largeur") and l.endswith("1") for l in lines), lines
    assert lines[-1] == "1SIA 265 4.2.1.1", lines
    # a norm written on the line wins over the domain's
    assert any(l.startswith("Autre") and l.endswith("SIA 260 4.4") for l in lines), lines


def test_the_default_rendering_needs_no_argument_and_no_level():
    # D-12: label left, formula, numbers, result -- with nothing but the label written
    t = text_of('#var("b", 140, "mm", label: "Largeur")\n#var("h", 200, "mm")\n#eq("A", `b * h`, label: "Section")\n')
    assert "Section 𝐴 = 𝑏 ⋅ ℎ = 140 mm ⋅ 200 mm = 28'000 mm²" in t, t
    assert t.splitlines()[0].startswith("Largeur"), t


def test_a_key_of_several_indices_prints_them_with_commas():
    # D-15
    t = text_of('#var("N_t_d", 180, "kN")\n#var("sigma_t_0_d", 6.4, "N/mm²")\n#var("k_dens", 1)\n')
    assert "𝑁t,d" in t and "𝜎t,0,d" in t and "𝑘dens" in t, t


def test_line_right_is_written_right_in_woodwork():
    ok, _, err, _ = compile_typ(HEAD + '#domain("t", norm-position: "line-right")[]\n')
    assert not ok
    assert panic_message(err) == 'domain: norm-position: "line-right" is written "right" in Woodwork', err
    ok, _, err, _ = compile_typ(HEAD + '#var("b", 1, "mm", norm-position: "line-right")\n')
    assert not ok and "is written \"right\"" in panic_message(err), err


def test_the_domain_prints_no_heading_and_takes_no_label():
    t = text_of('= Titre écrit à la main (SIA 265)\n#domain("t", norm: "SIA 265")[\n  #var("b", 140, "mm", label: "Largeur")\n]\n')
    assert t.splitlines()[0] == "Titre écrit à la main (SIA 265)", t
    ok, _, err, _ = compile_typ(HEAD + '#domain("t", label: "Titre")[]\n')
    assert not ok and "label" in err, err


def test_the_domain_keeps_its_variables_apart():
    got = query(HEAD + '#var("F", 1, "kN")\n#domain("a")[#var("F", 2, "kN")]\n#var("G", 3, "kN")\n#context [#metadata(var-registry-final()) <r>]\n'
                .replace("#context [#metadata(var-registry-final()) <r>]", '#import "/woodwork/lib/calc-engine.typ": var-registry\n#context [#metadata(var-registry.final().domains) <r>]'), "<r>")
    domains = got[0]["value"]
    assert domains[""]["F"]["value"] == 1 and domains["a"]["F"]["value"] == 2, domains


def test_thousands_are_set_apart_by_an_apostrophe():
    # the engineer, 05.11.2026: «28'000 mm²» -- from 1'000 to 99'999; past it a power of ten, as before
    t = text_of('#import "/woodwork/lib/number.typ": display-number\n'
                '#display-number(28000) #display-number(1234.5) #display-number(-12400) #display-number(999) #display-number(123456)\n')
    assert t.splitlines()[0] == "28'000 1'234.5 −12'400 999 1.235 · 10⁵", t
