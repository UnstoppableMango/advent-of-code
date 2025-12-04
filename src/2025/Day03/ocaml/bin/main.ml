let batteries s = String.to_seq s

let best bank =
  let () = Printf.printf "bank: %s\n" (String.of_seq bank) in
  bank
  |> Seq.mapi (fun i a ->
      bank
      |> Seq.drop (i + 1)
      |> Seq.map (fun b ->
          (* let () =
            Printf.printf "%s; " ([ a; b ] |> List.to_seq |> String.of_seq)
          in *)
          [ a; b ] |> List.to_seq |> String.of_seq |> int_of_string))
  |> Seq.flat_map Fun.id |> Seq.fold_left Int.max 0

let read_input name =
  In_channel.with_open_text name In_channel.input_lines
  |> List.map batteries |> List.map best
  |> fun x ->
  let () = x |> List.iter (Printf.printf "%d\n") in
  x |> List.fold_left ( + ) 0

let () = read_input "input" |> string_of_int |> print_endline
