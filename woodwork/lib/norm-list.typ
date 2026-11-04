// woodwork/lib/norm-list.typ -- #show-norm-list: the norms and documents a section names, listed in full. Taken from Woodcore's lib/document.typ on 4 November 2026, with the helper it calls; the documents are those of woodwork/data/norms.json.
#import "calc-engine.typ": print-level, report-lang
#import "bibliography.typ": bib-index, bib-line, bib-note, bib-read-file

#let doc-refuse(fn, message) = panic(fn + ": " + message)

/// **The norms and documents a section names, listed in full** -- designation, title, publisher and edition, as the bibliography sets them (docs/typst/citations.md §10): the selection the engineer makes in the section of the norms and the documents a convention d'utilisation and a base de projet rest on.
///
/// ```typ
/// #show-norm-list(keys: ("SIA 260", "SIA 261", "SIA 265"))
/// ```
///
/// ```typ
/// #show-norm-list(keys: ("VKF 14-15", "SIA 181:2020", [Lärmschutz-Verordnung (LSV)]))
/// ```
///
/// A key is a document of `woodwork/data/norms.json`, or of the project's own `references.bib` where `project:` names it, by its key or one of its aliases (`"SIA 260:2013"`), and it is registered for the bibliography as a citation is; one neither names is printed as it is written and never invented. Content is a line in the engineer's own words, printed as it is and registered nowhere. They are printed in the order given, once each.
///
/// - keys (array): the documents, in order: strings naming an entry, or content.
/// - project (none, str): the project's own `references.bib`, as a path from the project's folder -- `"references.bib"` -- or none.
/// - level (auto, int): 1 each document by its designation alone, «SIA 260:2013»; 2 in full, its title, publisher and edition as the bibliography sets them (what a document prints by default); 3 the same as 2, a list of norms being its own citation. auto follows the document.
/// -> content
#let show-norm-list(keys: (), project: none, level: auto) = {
  let fn = "show-norm-list"
  if type(keys) != array {
    doc-refuse(fn, "keys: is an array of the documents to list, (\"SIA 260\", \"SIA 261\") -- " + (if type(keys) == str { "write (" + repr(keys) + ",) for one" } else { "got " + repr(keys) }))
  }
  for k in keys {
    if not (type(k) in (str, content)) or (type(k) == str and k.trim() == "") {
      doc-refuse(fn, "keys: holds " + repr(k) + " -- a document is named by a non-empty string, \"SIA 260\", and a line of your own is [content]")
    }
  }
  if project != none and type(project) != str {
    doc-refuse(fn, "project: names the project's references.bib as a path from the project's folder, \"references.bib\" -- got " + repr(project))
  }
  // The entries the keys name, found once and outside the context: the catalogue and the project's file are read, not asked of a state. A key and an alias of one document -- «SIA 260» and «SIA 260:2013» -- are one document, listed once and registered under its own key, so that the bibliography, which dedups what it was handed, lists it once too.
  let index = bib-index(if project == none { () } else { bib-read-file(project) })
  let items = ()
  let seen = ()
  for k in keys {
    if type(k) == content {
      items.push(k)
    } else {
      let cited = k.trim()
      let entry = index.at(cited, default: none)
      let name = if entry == none { cited } else { entry.key }
      if not (name in seen) {
        seen.push(name)
        items.push((cited: name, entry: entry))
      }
    }
  }
  // registered before the context, never inside it (docs/typst/api-conventions.md §10bis)
  for name in seen { bib-note(name) }
  context {
    let lang = report-lang()
    for item in items {
      // the level (spec 2026-10-20-indices-et-niveaux, UI-003): the designation alone at 1, the whole entry from 2
      block(above: 0.5em, below: 0.5em, if type(item) == content { item } else if print-level("show-norm-list", level) < 2 { [#item.cited] } else { bib-line(item, lang) })
    }
  }
}
