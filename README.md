# simple_dotenv

`simeple_dotenv` is a lightweight and straightforward OCaml library for loading environment variables from a `.env` file into your application's environment. This is particularly useful for managing configuration settings in a development environment without hardcoding sensitive data.

## Features

- Parses a `.env` file and sets its key-value pairs as environment variables.
- Skips lines that are empty or start with a `#` (comments).
- Minimalistic and easy to use.
- Suitable for local development.

## Installation

For now, just pin it manually to your Dune project:
```
opam pin simple_dotenv.1.0.0 git+https://github.com/Lomig/simple_dotenv.git#main
```

## Usage

Here is an example of how to use `simple_dotenv` in your OCaml project:

* Make sure to place your `.env` file at the root of your project
* Add `simple_dotenv` as a library in your `dune` file

```lisp
(executable
 (public_name my_program)
 (name main)
 (libraries simple_dotenv))

```

* Just execute the `Dotenv.load` function
* If you don't have a `.env` file available to use, it will print a debug line

```ocaml
let () =
  (* Load environment variables from the default .env file *)
  Dotenv.load ();

  (* Retrieve an environment variable *)
  match Sys.getenv_opt "MY_ENV_VAR" with
  | Some value -> print_endline ("MY_ENV_VAR: " ^ value)
  | None -> print_endline "MY_ENV_VAR is not set."
```

### `.env` File Format

The `.env` file should contain key-value pairs in the following format:

```
# This is a comment
MY_ENV_VAR=value
ANOTHER_VAR=another_value
```

- Each line represents a key-value pair separated by `=`.
- Lines beginning with `#` are treated as comments and ignored.
- Empty lines are ignored.

## API Reference

### `Simple_dotenv.load`

```ocaml
val load : unit -> unit
```

## Why Use simple_dotenv?

- Keep sensitive data like API keys, database credentials, and configuration settings out of your source code.
- Improve code portability by separating configuration from code.
- Simplify local development by emulating production-like environments.

## License

`simeple_dotenv` is open-source software licensed under the GPL v3.

