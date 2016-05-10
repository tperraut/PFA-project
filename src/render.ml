open Segment
open Point
open Player
open Trigo
open Graphics
open Bsp
open Fsegment

let calc_angle s =
  atan2 (s.yd -. s.yo) (s.xd -. s.xo)
        
let translation_rotation s p =
  let ns = rotation (translation s (new_point (-p.pos.x) (-p.pos.y))) (-p.pa) in
  {ns with angle = calc_angle ns}
                      
let translation_rotation_inverse s p =
  let ns = translation (rotation s p.pa) p.pos in
  {ns with angle = calc_angle ns}
                                                    
let clip l p =
  let rec rclip acc = function
    | [] -> acc
    | r::s ->
       let r = fsegment_of_seg r in
       let a = translation_rotation r p in
       if a.xo < 1. && a.xd < 1. then
         rclip acc s
       else if a.xo < 1. then
         let seg = {a with
                     xo = 1.;
                     yo = (a.yo +. (1. -. a.xo) *. (tan a.angle))} in
         let r = translation_rotation_inverse seg p in
         rclip (r::acc) s
       else if a.xd < 1. then
         let seg = {a with
                     xd = 1.;
                     yd = (a.yd +. (1. -. a.xd) *. (tan a.angle))} in
         let r = translation_rotation_inverse seg p in
         rclip (r::acc) s
       else rclip (r::acc) s
  in rclip [] l
           
let rec bsp_to_list = function
  | E -> []
  | N(r,ag,ad) ->
     List.rev_append [r] (List.rev_append (bsp_to_list ag) (bsp_to_list ad))

let segtoarray s =
  let xo, yo, xd, yd = (iof s.xo), (iof s.yo), (iof s.xd), (iof s.yd) in
  (*Format.eprintf "%d, %d, %d, %d@." xo yo xd yd;*)
  [|xo, yo, xd, yd|]
    
let rec draw sl =
  match sl with
  | [] -> ()
  | x::s -> draw_segments (segtoarray x); draw s
                                               
let display bsp player =
  let angle1 = [(player.pos.x, player.pos.y, player.pos.x + (iof (10. *. (dcos (player.pa-30)))), player.pos.y + (iof (20. *. (dsin (player.pa-30)))))] in
  let angle2 = [(player.pos.x, player.pos.y, player.pos.x + (iof (10. *. (dcos (player.pa+30)))), player.pos.y + (iof (20. *. (dsin (player.pa+30)))))] in
  draw_segments (Array.of_list angle1);
  draw_segments (Array.of_list angle2);
  let map = clip (bsp_to_list bsp) player in
  draw map
       
