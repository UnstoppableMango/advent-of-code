let read_lines (file_name : string) : string list =
  In_channel.with_open_text file_name In_channel.input_lines

let split s =
  (String.sub s 0 1, String.sub s 1 (String.length s - 1) |> int_of_string)

let conv (d, n) = match d with "R" -> n | "L" -> -n | _ -> failwith "heck"

let rec calc acc x =
  match acc + x with
  | n when n < 0 -> calc acc (100 + x)
  | n when n > 99 -> calc acc (x - 100)
  | n -> n

let p1 () =
  read_lines "input.txt" |> List.map split |> List.map conv |> List.to_seq
  |> Seq.scan calc 50
  |> Seq.filter (fun x -> x = 0)
  |> Seq.length |> string_of_int |> print_endline

let c1 = function
  | n when n mod 100 = 0 -> 1
  | n ->
      let () = Printf.printf "%d / 100 = %d\n" n (n / 100) in
      n / 100

let p2 () =
  read_lines "input.txt" |> List.map split |> List.map conv |> List.to_seq
  |> Seq.scan ( + ) 50 |> Seq.map c1 |> Seq.fold_left ( + ) 0 |> string_of_int
  |> print_endline

let () =
  let () = p1 () in
  let () = p2 () in
  ()
