// ===== {title-edit-here} =====
// {title-edit-help}

// {title-document-help}
#let document = "{document-statical-report}"
#let project = "{placeholder-project-name}"
#let number = "{placeholder-project-number}"

// {title-rows-help}
#let rows = (
  ("{label-author}", ("{placeholder-person}",)),
  ("{label-checker}", ("{placeholder-person}",)),
  ("{label-client}", ("{placeholder-client}",)),
  ("{label-address}", ("{placeholder-address}",)),
)

// {title-date-help}
#let date = auto

// ===== {title-layout} =====

#let months = "{month-names}".split(",")
#let long-date(d) = {long-date-pattern}
#let day = if date == auto { long-date(datetime.today()) } else if type(date) == datetime { long-date(date) } else { date }
