let read_input (file_name : string) : string list =
  In_channel.with_open_text file_name In_channel.input_all
  |> String.trim |> String.split_on_char ','

let ( >> ) = Fun.compose

let parse s =
  match String.split_on_char '-' s |> List.map int_of_string with
  | [ a; b ] -> List.init (b - a + 1) (fun i -> a + i) |> List.map string_of_int
  | _ -> failwith "heck"

let p1 s =
  let len = String.length s / 2 in
  let end' = String.length s - len in
  String.sub s 0 len <> String.sub s len end'

let invalid s n =
  let len = String.length s / n in
  let () = Printf.printf "len %d\n" len in
  List.init (len - 1) (fun x ->
      let start = x * n in
      let end' = start + n in
      let () = Printf.printf "%d %d %s\n" start end' s in
      String.sub s start end')
  |> function
  | seg :: rest -> List.for_all (( = ) seg) rest
  | _ -> failwith "heck"

let p2 s =
  let len = String.length s / 2 in
  let () = Printf.printf "%d\n" len in
  List.init len (Fun.id >> ( + ) 1) |> List.exists (fun i -> invalid s i)

let p valid input =
  input
  |> List.map (List.filter (not >> valid))
  |> List.flatten |> List.map int_of_string |> List.fold_left ( + ) 0
  |> string_of_int |> print_endline

let () =
  read_input "sample" |> List.map parse |> (fun i -> (p p1 i, p p2 i)) |> ignore
