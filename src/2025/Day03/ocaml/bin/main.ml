let ( >> ) = Fun.compose
let to_string = String.of_seq >> List.to_seq

let p1 bank =
  let () = Printf.printf "bank: %s\n" (String.of_seq bank) in
  bank
  |> Seq.mapi (fun i a ->
      bank
      |> Seq.drop (i + 1)
      |> Seq.map (fun b ->
          (* let () =
            Printf.printf "%s; " ([ a; b ] |> List.to_seq |> String.of_seq)
          in *)
          [ a; b ] |> to_string |> int_of_string))
  |> Seq.flat_map Fun.id |> Seq.fold_left Int.max 0

let p2 bank =
  let () = Printf.printf "bank: %s\n" (String.of_seq bank) in
  bank
  |> Seq.mapi (fun i a ->
      bank
      |> Seq.drop (i + 1)
      |> Seq.map (fun b ->
          (* let () =
            Printf.printf "%s; " ([ a; b ] |> List.to_seq |> String.of_seq)
          in *)
          [ a; b ] |> to_string |> int_of_string))
  |> Seq.flat_map Fun.id |> Seq.fold_left Int.max 0

let p best input =
  input |> List.map String.to_seq |> List.map best |> fun x ->
  let () = x |> List.iter (Printf.printf "%d\n") in
  x |> List.fold_left ( + ) 0 |> string_of_int |> print_endline

let read_input name = In_channel.with_open_text name In_channel.input_lines
let () = read_input "sample" |> fun i -> (p p1 i, p p2 i) |> ignore
