let file = "../input/day6.txt"

(* (f : int -> 'b) (n : int) *)
let rec tabulate f n =
    let rec tab n acc =
        if n < 0 then acc
        else tab (n - 1) ((f n) :: acc)
    in
    tab (n - 1) []


(* Casts string into lists of characters *)
let string_explode (s : string) : char list =
    (* fun : Takes index, returns char at *)
    tabulate (fun n -> String.get s n) (String.length s)


let exists_duplicates (l : 'a list) : bool = 
    let f = (fun acc elt -> 
        let (b, acc_l) = acc in
        if b = true then acc else 
            if (List.mem elt acc_l) then
                (true, l)
            else
                (false, elt::acc_l)
    ) in
    let (b, _) = List.fold_left f (false, []) l in
    b


let dequeue (l : 'a list) : 'a list = 
    begin match l with
        | [] -> []
        | (x::xs) -> xs
    end


let find_marker (s : string) (sz : int) : int = 
    let rec aux (s : char list) (q : char list) (indx : int) : int = 
        begin match s with
            | [] -> (indx + 1) (* Could fail in some other way *)
            | (c::cs) -> 
                    if (List.length q) < sz then
                        aux cs (q @ [c]) (indx + 1)
                    else
                        (* Shadowing queue *)
                        let q = dequeue (q @ [c]) in
                        (* If there are no duplicates in current packet, return index *)
                        if not (exists_duplicates q) then
                            indx
                        else
                            aux cs q (indx + 1)
        end
    in
    let cl = string_explode s in
    aux cl [] 1


(* Read file : ic -- input channel *)
let read_file filename = 
    let ic = open_in filename in
    let line = input_line ic in
    Printf.printf "ANSWER 1 : %d\nANSWER 2 : %d\n"
    (find_marker line 4)
    (find_marker line 14)


(* Call answer *) 
let _ = read_file file
