(lang dune 3.14)

(using menhir 3.0)

(name bdfparser)

(generate_opam_files true)

(source
 (github mdales/bdfparser))

(authors "Michael Dales <michael@digitalflapjack.com>")

(maintainers "Michael Dales <michael@digitalflapjack.com>")

(license ICS)

(documentation https://url/to/documentation)

(package
 (name bdfparser)
 (synopsis "Library to parse BDF font files.")
 (description "A longer description")
 (depends ocaml dune)
 (tags
  (font rendering bitmap)))
