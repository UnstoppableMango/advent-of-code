let ( >> ) = Fun.compose
let read_input name = In_channel.with_open_text name In_channel.input_lines

type cell = { x : int; y : int }

module Cell = struct
  type t = cell

  let compare { x = ax; y = ay } { x = bx; y = by } =
    let cmp_a = Int.compare ax bx in
    if cmp_a <> 0 then cmp_a else Int.compare ay by
end

module CellMap = Map.Make (Cell)

let is_roll = function '@' -> true | '.' -> false | _ -> failwith "heck"
let add_cell x y c = is_roll c |> CellMap.add { x; y }
let to_cells x line m = line |> String.mapi (fun y c -> add_cell x y c m)

let () =
  read_input "sample"
  |> List.mapi (fun i line -> to_cells i line)
  |> String.concat "\n" |> String.cat "\n" |> print_endline
