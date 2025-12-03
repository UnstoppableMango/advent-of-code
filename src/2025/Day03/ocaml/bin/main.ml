let batteries s =
  String.to_seq s |> Seq.map int_of_char

let best bank =
  List.sort compare bank |> function | a :: b :: _ -> a + b | _ -> failwith "heck"

let read_input name =
  In_channel.with_open_text name In_channel.input_lines
  |> List.map batteries
  |> List.map best
  |> List.fold_left (+) 0
  |> string_of_int
  |> print_endline

let () = read_input "sample"
