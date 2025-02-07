(lang dune 3.17)

(name simple_dotenv)

(version 1.0.0)

(generate_opam_files true)

(source
 (github Lomig/simple_dotenv))

(authors "Lomig <lomig@hey.com>")

(maintainers "Lomig <lomig@hey.com>")

(license GPL-3.0)

(package
 (name simple_dotenv)
 (synopsis "A port of dotenv to OCaml")
 (description "A port of dotenv to OCaml")
 (depends ocaml containers re ppx_inline_test extunix)
 (tags
  ("dotenv" "web development" "configuration" "environment variables")))
