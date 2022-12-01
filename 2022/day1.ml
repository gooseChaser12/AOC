(* Why not OCaml ? *)

(* Puzzle Input : the number of calories each elf is carrying *)
(*  Each elf lists number of calories for each item they carry per line *)
(*  Each elf separates their invenveotry with a new line *)

(* 
1000
2000
3000

4000

First elf -- total of 6000 cals
Second elf  -- total of 4000 cals
*)

(* GOAL : Find elf carrying the most calories *)

let file = "day1.txt"

(* Calculate most cals from elf *)
let max_calories (calories_list : int list) =
    let rec aux cal_list (max : int) (cur_elf : int) : int = 
        begin match cal_list with
            | [] -> if cur_elf > max then cur_elf else max
            | (x::xs) -> 
                    if x = (-1) then 
                        if cur_elf > max then
                            aux xs cur_elf 0
                        else
                            aux xs max 0
                    else
                        aux xs max (cur_elf + x)
        end
    in
    aux calories_list 0 0


(* Would make more sense as a tree but whatever *)
type top_cals = int * int list

(* Calculating sum with continuations *) 
let rec sum_top (top : top_cals) return =
    begin match top with
        | (m, []) -> return 0
        | (m, x::xs) -> sum_top (m, xs) (fun y -> return (y + x))
    end

(* WHY AM I DOING IT LIKE THIS *)
let replace_min (top : top_cals) (v : int) = 
    let (m, t3) = top in
    let rec insert (l : int list) (inserted : bool) =
        if inserted = true then l else
        begin match l with
        | [] -> []
        | (x::xs) -> 
                if x = m then 
                    v :: (insert xs true) 
                else 
                    x :: (insert xs false)
        end
    in
    (* replacing minimum if needed *)
    let update_t3 = if v > m then (insert t3 false) else t3 in
    let folding acc x = 
        if x < acc then x else acc
    in
    (* finding new minimum if needed *)
    let update_min = if v > m then List.fold_left folding v update_t3 else m in
    (update_min, update_t3)

let top_three (calories_list : int list) =
    let rec aux cal_list (top : top_cals) (cur_elf : int) : int = 
        begin match (cal_list, top) with
            | ([], (m, t3)) -> sum_top top (fun x -> x)
            | (x::xs, (m, t3)) -> 
                    if x = (-1) then 
                        let top_update = replace_min top cur_elf in
                        aux xs top_update 0
                    else
                        aux xs top (cur_elf + x)
        end
    in
    let init_top = (0, [0; 0; 0]) in
    aux calories_list init_top 0

exception EOF of int list

(* Read file : ic -- input channel *)
let read_file filename = 
    let ic = open_in filename in
    let read_line (acc : int list) =
        try
            let line = input_line ic in
            (* Inserting -1 for line breaks *)
            if line = String.empty then 
                (-1)::acc 
            else 
                (* Casting to integers *)
                (int_of_string line)::acc
        with e -> 
        (* close input channel, ignore errors *)
            close_in_noerr ic; raise (EOF acc)
    in
    let rec next_line (acc : int list) =
        try 
            next_line (read_line acc)
        with
            | EOF acc -> acc
    in
    let lines_list = next_line [] in
    Printf.printf "Answer 1 : %d\nAnswer 2 : %d\n" 
    (max_calories lines_list)
    (top_three lines_list)

(* Call answer *) 
let _ = read_file file
