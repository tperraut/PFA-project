open Point
open Segment

type t = E | N of Segment.t * t * t

let parse f bsp p =
  let rec rparse bsp =
    match bsp with
    | E -> ()
    | N(r,sl,sr) ->
       let pos = get_position p r in
       match pos with
       | L -> rparse sl; f r; rparse sr
       | R | C -> rparse sr; f r; rparse sl
  in rparse bsp

let rev_parse f bsp p =
  let rec rrevparse bsp =
    match bsp with
    | E -> ()
    | N(r,sl,sr) ->
       let pos = get_position p r in
       
       match pos with
       | L -> rrevparse sr; f r; rrevparse sl
       | R | C -> rrevparse sl; f r; rrevparse sr
  in rrevparse bsp
               
let iter f bsp =
  let rec riter bsp =
    match bsp with
    | E -> ()
    | N(r,sl,sr) -> f r; riter sl; riter sr
  in riter bsp

let build_bsp sl =
  let rec rbuild = function
    | [] -> E
    | x::s -> let (sll, slr) = split x s in
              N(x, rbuild sll, rbuild slr)
  in rbuild sl

let rec string_of_bsp = function
  | E -> "E"
  | N(r, ag, ad) -> "G"^(string_of_bsp ag)
                    ^"\nN"^(string_of_segment r)
                    ^"\nD"^(string_of_bsp ad)

