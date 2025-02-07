open Containers

let regexp =
  let open Re in
  seq
    [ start; group @@ rep1 (alt [ alnum; char '_' ]); char '='; group @@ rep1 any; stop ]
  |> compile
;;

let to_key_value_pairs line =
  Re.exec_opt regexp line
  |> Option.map (fun matches -> Re.Group.get matches 1, Re.Group.get matches 2)
;;

let add_env_variables list =
  let rec aux = function
    | [] -> ()
    | None :: rest -> aux rest
    | Some (key, value) :: rest ->
      (match Sys.getenv_opt key with
       | Some _ -> aux rest
       | None -> Unix.putenv key value);
      aux rest
  in
  aux list
;;

let load () =
  match Sys.file_exists ".env" with
  | true ->
    IO.with_in ".env" IO.read_lines_l |> List.map to_key_value_pairs |> add_env_variables
  | false -> print_endline "No .env file to parse"
;;
