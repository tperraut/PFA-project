open Bsp
open Segment
open Point

let between x lb ub =
  x >= lb && x <= ub

let lstocl s1 s2 =
  let bo = get_position s2.porig s1 in
  let bd = get_position s2.pdest s1 in
  let xo1, yo1 = s1.porig.x, s1.porig.y
  and xd1, yd1 = s1.pdest.x, s1.pdest.y
  and xo2, yo2 = s2.porig.x, s2.porig.y
  and xd2, yd2 = s2.pdest.x, s2.pdest.y
  in
  match bo, bd with
  | C, _ when between xo2 xo1 xd1 && between yo2 yo1 yd1 -> true
  | _, C when between xd2 xo1 xd1 && between yd2 yo1 yd1 -> true
  | R, L -> true
  | L, R -> true
  | _ -> false

let intersect s1 s2 = lstocl s1 s2 && lstocl s2 s1

let detect_collision s bsp =
  let rec rdc bsp =
    match bsp with
    | E -> false
    | N(r,ag, ad) ->
       let xo = get_position s.porig r in
       let xd = get_position s.pdest r in
       let c  = intersect s r in
       if c then true
       else
         match xo, xd with
         | L, L | L, C | C, L -> rdc ag (* o---d|| ou o---|d| ou d---|o| *)
         | R, R | R, C | C, R -> rdc ad (* ||o---d ou |d|---o ou |o|---d *)
         | _ -> rdc ag && rdc ad
  in rdc bsp
