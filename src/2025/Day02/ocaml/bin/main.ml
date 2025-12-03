let read_input (file_name : string) : string list =
  In_channel.with_open_text file_name In_channel.input_all |> String.trim |> String.split_on_char ','

let (>>) f g x = g x |> f

let parse s =
	match String.split_on_char '-' s |> List.map int_of_string with
	| [a; b] -> List.init (b - a + 1) (fun i -> a + i) |> List.map string_of_int
	| _ -> failwith "heck"

let valid s =
	let len = (String.length s) / 2 in
	let end' = String.length s - len in
	String.sub s 0 len <> String.sub s len end'

let () =
	read_input "input"
	|> List.map parse
	|> List.map (List.filter (not >> valid))
	|> List.flatten
	|> List.map int_of_string
	|> List.fold_left (+) 0
	|> string_of_int
	|> print_endline
