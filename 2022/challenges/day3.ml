(*

To help prioritize item rearrangement, every item type can be converted to 
a priority:
    - a ... z : 1 ... 26
    - A ... Z : 27 ... 52

MATT COMMENT: 
    Could have done this in quicker way but wanted to try to functionalize
    some things for fun.

*)

let file = "../input/day3.txt"


exception EOF of string list
exception NotImplemented


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


(* Converts char list to a string *)
let charl_to_string (c : char list) : string = 
    List.fold_left (fun acc elt -> acc ^ (Char.escaped elt)) String.empty c
    (* To print a every elemtn of a list *)
    (* List.iter (fun elt -> Printf.printf "%s" (stringify elt)) list *)


(* Converts list of polymorphic type to a string *)
let poly_to_string (l : 'a list ) (stringify : 'a -> string) : string = 
    List.fold_left (fun acc elt -> (stringify elt) ^ acc) String.empty l 

 
(* Assuming group to have three elements *)
type group = char list list


let group_to_string (g : group) : string = 
    List.fold_left (fun acc elt -> acc ^ (charl_to_string elt) ^ "\n") String.empty g


(* -------------------------------- P1 --------------------------------------- *)


(* Splits the sack into tuple of two compartments *)
let compartmentalize (items : string) : char list * char list = 
    let char_list = string_explode items in
    let len = List.length char_list in
    let rec aux (items_list : char list) (indx : int) = 
        begin match items_list with
            | [] -> ([], [])
            | (x::xs) -> 
                    if indx < (len / 2) then 
                        let (c1, c2) = aux xs (indx+1) in
                        (x::c1, c2)
                    else
                        let (c1, c2) = aux xs (indx+1) in
                        (c1, x::c2)
        end
    in
    aux char_list 0


(* Determines duplicates from two lists *)
let find_duplicates (c : char list * char list) : char list =
    (* Doesn't matter if output list is reversed for our purposes *)
    let rec aux (c1 : char list) (c2 : char list) (acc : char list) = 
        begin match c1 with
            | [] -> acc
            | (x::xs) -> if (List.mem x c2) && not (List.mem x acc) then 
                    aux xs c2 (x::acc) 
                else
                    aux xs c2 acc
        end
    in
    let (c1, c2) = c in
    aux c1 c2 []


let get_priority (c : char) : int = 
    (* Assuming the input is a valid letter *)
    let ascii = Char.code c in
    if ascii < 96 then
        (* If upper case *)
        ((ascii - 13) mod 26) + 27
    else 
        (* If lower case *)
        ((ascii - 19) mod 26) + 1


(* Give list of priorities, sums them all up *)
let sum_priorities (priorities : char list) : int = 
    List.fold_left (fun acc elt -> (get_priority elt) + acc) 0 priorities


let find_sum_priorites (lines : string list) : int =
    (* comp  : ( char list * char list ) *)
    let comp = List.map compartmentalize lines in
    (* dup : char list list *)
    let dup = List.map find_duplicates comp in
    (* sum_p : int list *)
    let sum_p = (fun acc elt -> (sum_priorities elt) + acc) in
    List.fold_left sum_p 0 dup


(* -------------------------------- P2 --------------------------------------- *)


(* spliting rugsacks into a list of groups *)
let get_groups (rugsacks : string list) : group list =
    let rec aux (rugs : string list) (acc : group list) (indx : int) = 
        begin match rugs with
            | [] -> acc
            | (r::rs) -> 
                    let cl = string_explode r in
                    let i = (indx mod 3) in
                    begin match acc with
                        | [] -> aux rs [[cl]] (i+1)
                        | (a::ac) -> 
                                if i = 0 then 
                                    aux rs ([cl]::(a::ac)) (i+1)
                                else
                                    aux rs ((cl::a)::ac) (i+1)
                    end
        end
    in
    aux rugsacks [] 0


let get_badge (g : group) : char = 
    let dup = List.fold_left (fun acc elt -> find_duplicates (acc, elt)) (List.hd g) g in
    (* Assuming there exists a common badge in a group of three *)
    List.hd dup


let find_sum_group_priorities (lines : string list) : int =
    (* We know the puzzle input has 300 lines which is divisble by 3, so
       the groups are well defined. We could code for it otherwise but I don't
       feel like it rn.
       *)
    (* log : char list list list *)
    let list_of_groups = get_groups (lines) in
    (* lob : char list *)
    let list_of_badges = List.map (fun g -> get_badge g) list_of_groups in
    sum_priorities list_of_badges


(* ----------------------------- CALL --------------------------------------- *)


(* Read file : ic -- input channel *)
let read_file filename = 
    let ic = open_in filename in
    let read_line (acc : string list) =
        try
            let line = input_line ic in
            line::acc
        with e -> 
        (* close input channel, ignore errors *)
            close_in_noerr ic; raise (EOF acc)
    in
    let rec next_line (acc : string list) =
        try 
            next_line (read_line acc)
        with
            | EOF acc -> acc
    in
    let lines_list = next_line [] in
    Printf.printf "Answer 1 : %d\nAnswer 2 : %d"
    (find_sum_priorites lines_list)
    (find_sum_group_priorities lines_list)


(* Call answer *) 
let _ = read_file file
