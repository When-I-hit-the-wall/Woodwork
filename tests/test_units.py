"""`units:` on a domain: every value and result of a dimension in that unit; `unit:` on a line for itself; one unit per dimension (founding spec REQ-006, D-7)."""

from conftest import compile_typ, panic_message, pdf_text

HEAD = '#import "/woodwork/woodwork.typ": *\n'


def test_units_of_a_domain_hold_for_values_and_results():
    ok, _, err, pdf = compile_typ(HEAD + """#domain("m", units: ("Nm",))[
  #var("M_d", 12.4, "kNm", label: "Moment")
  #var("a", 2, "m")
  #eq("M_2", `M_d * a / a`, label: "Moment 2")
  #eq("M_3", `M_d * a / a`, label: "Moment 3", unit: "kNm")
]
#var("M_e", 12.4, "kNm", label: "Dehors")
""")
    assert ok, err
    t = pdf_text(pdf)
    assert "Moment 𝑀d = 12'400 Nm" in t, t
    assert t.splitlines()[-1] == "Dehors 𝑀e = 12.4 kNm", t
    assert "2 m = 12'400 Nm" in t and "2 m = 12.4 kNm" in t, t


def test_two_units_of_one_dimension_are_refused_naming_both():
    ok, _, err, _ = compile_typ(HEAD + '#domain("m", units: ("Nm", "kNm"))[]\n')
    assert not ok
    assert panic_message(err) == 'domain: units: "Nm" and "kNm" are units of one dimension -- give one unit per dimension', err


def test_units_is_a_list():
    ok, _, err, _ = compile_typ(HEAD + '#domain("m", units: "Nm")[]\n')
    assert not ok and 'units: ("Nm",)' in panic_message(err), err
    ok, _, err, _ = compile_typ(HEAD + '#domain("m", units: ("Nmx",))[]\n')
    assert not ok and "is not a unit" in panic_message(err), err
