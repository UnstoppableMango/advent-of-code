module Day01

open System
open System.IO

let numbers lines =
    lines
    |> Seq.choose (fun (x: string) ->
        match Int32.TryParse(x) with
        | true, i -> Some i
        | _ -> None)
    |> Seq.toList

let p1 lines =
    lines
    |> Seq.map (fun (x: string) -> x.Split(" ") |> numbers)
    |> List.transpose
    |> List.map List.sort
    |> List.transpose
    |> List.map (function
        | [ a; b ] -> a - b
        | _ -> failwith "input")
    |> List.map Math.Abs
    |> List.fold (+) 0

let p2 lines =
    lines
    |> Seq.map (fun (x: string) -> x.Split(" ") |> numbers)
    |> List.transpose
    |> List.map (
        List.sort
        >> List.fold
            (fun s x ->
                s
                |> Map.change x (Option.defaultValue 0 |> Option.map (+ 1))
            Map.empty
    )

let input = File.ReadLines "input"

printfn $"{p1 input}"
printfn $"{p2 input}"
