(* https://gist.github.com/Chubek/524bcc10abc593710f7de9ccca8377e4?permalink_comment_id=5073295#gistcomment-5073295 *)
let explode s = List.of_seq (String.to_seq s)
let implode l = String.of_seq (List.to_seq l)

let read_lines (file_name : string) : string list =
  In_channel.with_open_text file_name In_channel.input_lines

let conv s =
  match explode s with
  | 'R' :: t -> int_of_string (implode t)
  | 'L' :: t -> -int_of_string (implode t)
  | _ -> failwith "heck"

let rec calc acc x =
  match acc + x with
  | n when n < 0 -> calc acc (100 + x)
  | n when n > 99 -> calc acc (x - 100)
  | n -> n

let p1 () =
  read_lines "input.txt" |> List.map conv |> List.to_seq |> Seq.scan calc 50
  |> Seq.filter (fun x -> x = 0)
  |> Seq.length |> string_of_int |> print_endline

(* let rec count dial c =
  let () = Printf.printf "              %4d %2d\n" dial c in
  if dial < 0 then count (dial + 100) (c + 1)
  else if dial = 100 then (0, c)
  else if dial > 99 then count (dial - 100) (c + 1)
  else (dial, c)

let calc2 (dial, c) turns =
  let () = Printf.printf "%4d + %4d = %4d\n" dial turns (dial + turns) in
  match count (dial + turns) c with
  | (0, c) -> 0, c + 1
  | x -> x *)

let calc3 (dial, c) turns =
 let () = Printf.printf "%4d + %4d = %4d (%d)\n" dial turns (dial + turns mod 100) c in
 match (dial + turns mod 100) with
 | dial' when dial' < 0 -> dial' + 100, 1 + c + (turns / 100)
 | 100 -> 0, c
 | dial' when dial' > 99 -> dial' - 100, c + (turns / 100)
 | 0 -> 0, c + 1
 | x -> x, c

let p2 () =
  read_lines "input.txt" |> List.map conv |> List.to_seq
  |> Seq.fold_left calc3 (50, 0)
  |> snd |> string_of_int |> print_endline

let () =
  let () = p1 () in
  let () = p2 () in
  ()
