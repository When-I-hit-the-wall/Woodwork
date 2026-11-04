"""#material (founding spec REQ-009): a class read from woodwork/data/, η_w · η_t · the table's design value, the office's materials, the engineer's values, two materials in one domain."""

import json

from conftest import compile_typ, panic_message, pdf_text, query

HEAD = '#import "/woodwork/woodwork.typ": *\n#import "/woodwork/lib/calc-engine.typ": var-registry\n'
READ = '\n#context [#metadata(var-registry.final().domains) <r>]\n'


def values(body, files=None):
    got = query(HEAD + '#domain("t", norm: "SIA 265")[\n' + body + '\n]' + READ, "<r>", files=files)
    return {k: (v["value"], v["unit"]) for k, v in got[0]["value"]["t"].items()}


def close(a, b):
    return abs(a - b) <= 1e-9 * max(1, abs(b))


def test_glulam_of_moisture_class_1_is_the_tables_value():
    v = values('#material("GL24h", moisture: 1)')
    assert close(v["f_t_0_d"][0], 12.8) and v["f_t_0_d"][1] == "N/mm²", v["f_t_0_d"]
    assert close(v["f_m_d"][0], 16.0) and close(v["f_c_0_d"][0], 16.0) and close(v["f_v_d"][0], 1.8), v
    assert close(v["E_0_mean"][0], 11500) and close(v["rho_k"][0], 385) and v["rho_k"][1] == "kg/m³", v


def test_moisture_class_2_multiplies_by_eta_w():
    v = values('#material("GL24h", moisture: 2)')
    assert close(v["eta_w"][0], 0.8), v["eta_w"]
    assert close(v["f_t_0_d"][0], 10.24), v["f_t_0_d"]
    # the moduli are the table's
    assert close(v["E_0_mean"][0], 11500), v["E_0_mean"]


def test_an_impact_multiplies_by_eta_t():
    v = values('#material("GL24h", impact: true)')
    assert close(v["eta_t"][0], 1.4) and close(v["f_t_0_d"][0], 12.8 * 1.4), v


def test_solid_timber_is_read_in_tabelle_8():
    v = values('#material("C24")')
    assert "f_t_0_d" in v and v["f_t_0_d"][0] > 0, v


def test_the_cases_of_f_c_90_d():
    assert close(values('#material("GL24h")')["f_c_90_d"][0], 1.9)
    assert close(values('#material("GL24h", case: "mit_vorholz")')["f_c_90_d"][0], 2.5)
    assert close(values('#material("GL24h", case: "mit_vorholz", larger: true)')["f_c_90_d"][0], 4.0)


def test_a_value_of_the_engineers_own_replaces_the_tables():
    v = values('#material("GL24h", moisture: 2, f_t_0_d: 11.0)')
    assert close(v["f_t_0_d"][0], 11.0), v["f_t_0_d"]
    assert close(v["f_c_0_d"][0], 16.0 * 0.8), v["f_c_0_d"]


def test_two_materials_stand_in_one_domain_with_a_suffix():
    v = values('#material("GL24h", suffix: "1")\n#material("C24", moisture: 2, suffix: "2")')
    assert close(v["f_c_90_d_1"][0], 1.9) and "f_c_90_d_2" in v and close(v["eta_w_2"][0], 0.8), sorted(v)
    assert "f_c_90_d" not in v


def test_the_offices_own_material():
    own = {"materials": [{"id": "Test-LVL", "_source": "a test", "norm": "ETA-00/0000", "norm_ref": "Tab. 1", "f_t_0_d": 20.0, "E_0_mean": 14000}]}
    v = values('#material("Test-LVL", moisture: 2)', files={"woodwork/data/my-materials/materials.json": json.dumps(own)})
    assert close(v["f_t_0_d"][0], 16.0) and close(v["E_0_mean"][0], 14000), v
    assert "f_m_d" not in v


def test_an_unknown_class_is_refused_naming_where_it_was_looked_for():
    ok, _, err, _ = compile_typ(HEAD + '#material("GL99")\n')
    assert not ok
    msg = panic_message(err)
    assert msg.startswith('material: no class "GL99" in SIA 265 Tabelle 8 or 9') and "my-materials/materials.json" in msg and "GL24h" in msg, msg


def test_wrong_arguments_are_refused():
    for call, said in (('#material("GL24h", moisture: 4)', "moisture: 4 is not a moisture class"),
                       ('#material("GL24h", f_x_d: 1)', '"f_x_d" is not a value of a class'),
                       ('#material("GL24h", case: "x")', 'case: "x" is not a case'),
                       ('#material("GL24h", print: "f_t_0_d")', "print: is a list of keys")):
        ok, _, err, _ = compile_typ(HEAD + call + "\n")
        assert not ok and said in panic_message(err), (call, err)


def test_it_prints_nothing_unless_asked():
    ok, _, err, pdf = compile_typ(HEAD + '#domain("t")[#material("GL24h")]\nfin\n')
    assert ok, err
    assert pdf_text(pdf).strip() == "fin", pdf_text(pdf)
    ok, _, err, pdf = compile_typ(HEAD + '#domain("t", norm: "SIA 265")[#material("GL24h", moisture: 2, print: ("f_t_0_d",))]\n', lang="fr")
    assert ok, err
    t = pdf_text(pdf)
    assert "Classe d’humidité 2" in t and "SIA 265 Tab. 4" in t and "SIA 265 Tab. 9" in t and "10.24 N/mm²" in t, t


def test_an_engineers_value_is_printed_as_his():
    ok, _, err, pdf = compile_typ(HEAD + '#domain("t", norm: "SIA 265")[#material("GL24h", f_t_0_d: 11.0, print: ("f_t_0_d",))]\n', lang="fr")
    assert ok, err
    t = pdf_text(pdf)
    assert "valeur de l’ingénieur" in t and "11 N/mm²" in t, t
