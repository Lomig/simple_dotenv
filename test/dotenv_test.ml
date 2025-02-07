open! Containers
open! Dotenv

let%test_module "to_key_value_pairs" =
  (module struct
    let%expect_test "it parses simple key-values" =
      let _ =
        match to_key_value_pairs "SIMPLE=value" with
        | None -> print_endline "No match"
        | Some (key, value) -> print_endline (key ^ " - " ^ value)
      in
      [%expect {| SIMPLE - value |}]
    ;;

    let%expect_test "it parses values with spaces" =
      let _ =
        match to_key_value_pairs "SIMPLE=value or something" with
        | None -> print_endline "No match"
        | Some (key, value) -> print_endline (key ^ " - " ^ value)
      in
      [%expect {| SIMPLE - value or something |}]
    ;;

    let%expect_test "it parses values with symbols and =" =
      let _ =
        match to_key_value_pairs "SIMPLE=value=something!" with
        | None -> print_endline "No match"
        | Some (key, value) -> print_endline (key ^ " - " ^ value)
      in
      [%expect {| SIMPLE - value=something! |}]
    ;;

    let%expect_test "it parses keys with _" =
      let _ =
        match to_key_value_pairs "SIMPLE_KEY=value" with
        | None -> print_endline "No match"
        | Some (key, value) -> print_endline (key ^ " - " ^ value)
      in
      [%expect {| SIMPLE_KEY - value |}]
    ;;

    let%expect_test "it does not parse keys starting with #" =
      let _ =
        match to_key_value_pairs "#SIMPLE=value" with
        | None -> print_endline "No match"
        | Some (key, value) -> print_endline (key ^ " - " ^ value)
      in
      [%expect {| No match |}]
    ;;

    let%expect_test "it does not parse empty lines" =
      let _ =
        match to_key_value_pairs "" with
        | None -> print_endline "No match"
        | Some (key, value) -> print_endline (key ^ " - " ^ value)
      in
      [%expect {| No match |}]
    ;;
  end)
;;

let%test_module "add_env_variables" =
  (module struct
    let%expect_test "it adds variables to the environment" =
      let list = [ Some ("SIMPLE", "value"); None; Some ("SIMPLE2", "value2") ] in
      add_env_variables list;
      print_endline (Sys.getenv "SIMPLE");
      print_endline (Sys.getenv "SIMPLE2");
      ExtUnix.All.unsetenv "SIMPLE";
      ExtUnix.All.unsetenv "SIMPLE2";
      [%expect
        {|
        value
        value2 |}]
    ;;

    let%expect_test "it does not overwrite existing variables" =
      Unix.putenv "SIMPLE" "value";
      let list = [ Some ("SIMPLE", "value2") ] in
      add_env_variables list;
      print_endline (Sys.getenv "SIMPLE");
      ExtUnix.All.unsetenv "SIMPLE";
      [%expect {| value |}]
    ;;
  end)
;;

let%test_module "load" =
  (module struct
    let%expect_test "it reads the .env file and adds the variables" =
      ExtUnix.All.unsetenv "A_SIMPLE_VARIABLE";
      assert (Option.is_none (Sys.getenv_opt "A_SIMPLE_VARIABLE"));
      IO.with_out ".env" (fun oc -> IO.write_line oc "A_SIMPLE_VARIABLE=a_special_value");
      load ();
      let _ =
        match Sys.getenv_opt "A_SIMPLE_VARIABLE" with
        | None -> print_endline "Environment variable not found"
        | Some value -> print_endline value
      in
      ExtUnix.All.unsetenv "A_SIMPLE_VARIABLE";
      Sys.remove ".env";
      [%expect {| a_special_value |}]
    ;;

    let%expect_test "it does nothing if the .env file does not exist" =
      load ();
      [%expect {| No .env file to parse |}]
    ;;
  end)
;;
