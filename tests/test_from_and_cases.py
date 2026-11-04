"""`#var(…, from:, path:)` reads a constant of a clause or a table in woodwork/data/ (founding spec Q-011); `#eq(…, cases:)` computes a formula by cases (Q-012)."""

from conftest import compile_typ, panic_message, pdf_text, query

HEAD = '#import "/woodwork/woodwork.typ": *\n#import "/woodwork/lib/calc-engine.typ": var-registry\n'
READ = '\n#context [#metadata(var-registry.final().domains) <r>]\n'


def values(body):
    got = query(HEAD + '#domain("t")[\n' + body + '\n]' + READ, "<r>")
    return got[0]["value"]["t"]


def test_a_constant_is_read_with_its_unit_and_its_citation():
    v = values('#var("beta_c", from: "sia265/4.2.8-knicken", path: "clause.beta_c.Brettschichtholz")\n'
               '#var("E_0_05", from: "sia265/tab48-druckfestigkeit-e005-brettschichtholz", path: "table_48.grades.GL24h.E_0_05")\n'
               '#var("h_ref", from: "sia265/3.4.2.3-k-h", path: "clause.reference_height", unit: "mm")')
    assert v["beta_c"]["value"] == 0.1 and v["beta_c"]["unit"] == "" and v["beta_c"]["norm"] == "SIA 265" and v["beta_c"]["norm_ref"] == "4.2.8", v["beta_c"]
    assert v["E_0_05"]["value"] == 9600 and v["E_0_05"]["unit"] == "N/mm²" and v["E_0_05"]["norm_ref"] == "Anhang B", v["E_0_05"]
    assert v["h_ref"]["value"] == 600 and v["h_ref"]["unit"] == "mm", v["h_ref"]


def test_the_citation_is_printed_and_a_line_may_name_its_own():
    ok, _, err, pdf = compile_typ(HEAD + '#var("k_a", from: "sia265/4.2.6-abscheren", path: "clause.factor.Vollholz", label: "Facteur")\n'
                                  '#var("k_t", from: "sia265/4.2.7-schub-querdruck", path: "clause.k_t_90.querzug", norm-section: "4.2.7.1 (28)")\n')
    assert ok, err
    t = pdf_text(pdf)
    assert "SIA 265 4.2.6" in t and "SIA 265 4.2.7.1 (28)" in t, t


def test_a_wrong_path_lists_what_is_there():
    for call, said in (('#var("x", from: "sia265/4.2.8-knicken", path: "clause.beta")', 'has no "beta" under clause -- it has'),
                       ('#var("x", from: "sia265/tab48-druckfestigkeit-e005-brettschichtholz", path: "table_48.grades.GL99.E_0_05")', 'has no element "GL99"'),
                       ('#var("x", from: "sia265/4.2.8-knicken", path: "clause.label")', "is not a number"),
                       ('#var("x", from: "sia265/4.2.8-knicken")', "from: and path: go together"),
                       ('#var("x", 3, from: "sia265/4.2.8-knicken", path: "clause.k_factor")', "write no value beside from:")):
        ok, _, err, _ = compile_typ(HEAD + call + "\n")
        assert not ok and said in (panic_message(err) or err), (call, err)


KM = '#eq("k_m_%s", cases: ((`lambda_%s <= 0.75`, `1`), (`lambda_%s <= 1.4`, `1.56 - 0.75 * lambda_%s`), (auto, `1 / lambda_%s^2`)))'


def test_the_first_case_that_holds_is_computed():
    body = "\n".join('#var("lambda_%s", %s)' % (n, l) for n, l in (("a", 0.5), ("b", 0.75), ("c", 1.0), ("d", 2.0)))
    body += "\n" + "\n".join(KM % ((n,) * 5) for n in "abcd")
    v = values(body)
    assert v["k_m_a"]["value"] == 1 and v["k_m_b"]["value"] == 1, (v["k_m_a"], v["k_m_b"])
    assert abs(v["k_m_c"]["value"] - 0.81) < 1e-12 and abs(v["k_m_d"]["value"] - 0.25) < 1e-12, (v["k_m_c"], v["k_m_d"])


def test_the_case_printed_is_the_one_that_held():
    ok, _, err, pdf = compile_typ(HEAD + '#var("lambda_c", 1.0)\n' + KM % (("c",) * 5) + "\n")
    assert ok, err
    t = pdf_text(pdf)
    assert "1.56 − 0.75 ⋅ 𝜆c = 1.56 − 0.75 ⋅ 1 = 0.81" in t.replace("=", " = ").replace("  ", " ") or "0.81" in t, t
    assert "𝜆2" not in t, t


def test_cases_are_refused_when_malformed():
    for call, said in (('#eq("k", cases: ((`a <= 1`, `1`),))', "the last case is (auto"),
                       ('#eq("k", cases: ((auto, `1`), (`a <= 1`, `2`)))', "auto, the case that always holds, stands last"),
                       ('#eq("k", `2`, cases: ((auto, `1`),))', "given cases: and a formula"),
                       ('#eq("k", cases: ((`a`, `1`), (auto, `2`)))', "is no relation")):
        ok, _, err, _ = compile_typ(HEAD + '#var("a", 1)\n' + call + "\n")
        assert not ok and said in (panic_message(err) or err), (call, err)
