let read_input filename : string list =
  In_channel.with_open_text filename In_channel.input_lines

type node = { label : string; vertices : string list }

let parse (lines : string list) =
  lines
  |> List.map (fun line ->
         line |> String.split_on_char ':' |> function
         | [ a; b ] -> { label = a; vertices = String.split_on_char ' ' b }
         | _ -> failwith "heck")

let findYou = List.find (fun n -> n.label = "you")
let containsOut n = n.vertices |> List.exists (( = ) "out")

let nextNodes node =
  List.filter (fun n -> node.vertices |> List.exists (( = ) n.label))

let rec findPaths acc node graph =
  if containsOut node then 1 + acc
  else
    nextNodes node graph
    |> List.map (fun n -> findPaths acc n graph)
    |> List.fold_left ( + ) 0

let rec findPaths2 (acc, segments) node graph =
  if containsOut node then
    if List.exists (fun l -> l = "fft" || l = "dac") segments then 1 + acc
    else 0
  else
    nextNodes node graph
    |> List.map (fun n -> findPaths2 (acc, n.label :: segments) n graph)
    |> List.fold_left ( + ) 0

let p1 (graph : node list) =
  graph |> findYou |> fun you -> findPaths 0 you graph

let p2 (graph : node list) =
  graph |> findYou |> fun you -> findPaths2 (0, []) you graph

let () = read_input "input" |> parse |> p1 |> string_of_int |> print_endline
