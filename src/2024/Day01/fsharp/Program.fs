module Day01

open System
open System.IO

let handle lines =
    lines
    |> Seq.choose (fun (x: string) ->
        match Int32.TryParse(x) with
        | true, i -> Some i
        | _ -> None)

let p1 lines =
    lines |> Seq.map (fun (x: string) -> x.Split(" ") |> handle)

let input = File.ReadLines "input"

printfn $"{p1 input}"
