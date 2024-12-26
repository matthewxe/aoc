let rec print_list l =
  match l with
  | [] -> print_char '\n'
  | v :: t ->
      print_endline v;
      print_list t

let rec print_int_pair_list l =
  match l with
  | [] -> print_char '\n'
  | (a, b) :: c ->
      Printf.printf "(%i, %i)" a b;
      print_int_pair_list c

(* let rec remove_duplicates_int_pair_list l = *)
(*   match l with [] -> l | (a, b) :: c -> remove_duplicates_int_pair_list c *)

let list_count_unique l =
  let rec go n li =
    match li with
    (*balls*)
    | [] -> n
    | _ :: b -> go (n + 1) b
  in
  go 0 l

let () =
  if Array.length Sys.argv <> 2 then print_endline "part1 [filename]"
  else
    let ic = open_in Sys.argv.(1) in
    try
      let map = In_channel.input_lines ic in
      print_list map;
      (* 10 is the invalid number *)
      let max_x = String.length (List.hd map) - 1 in
      let max_y = List.length map - 1 in
      let get_pos x y =
        if
          x < 0 || y < 0 || y > max_y || x > max_x
          || String.get (List.nth map y) x = '.'
        then 10
        else int_of_char (String.get (List.nth map y) x) - 48
      in

      (* N is the previous height and x/y is the current square thats being checked *)
      let rec check n x y =
        let cur = get_pos x y in
        if n = cur - 1 then
          if cur = 9 then (
            Printf.printf "FOUND AT X: %i Y: %i\n" x y;
            [ (x, y) ])
          else
            List.flatten
              [
                check cur (x + 1) y;
                check cur (x - 1) y;
                check cur x (y + 1);
                check cur x (y - 1);
              ]
        else []
      in

      let scan =
        let t = ref [] in
        for y = 0 to max_y do
          for x = 0 to max_x do
            if get_pos x y = 0 then t := check (-1) x y @ !t
              (* Printf.printf "caught! %i %i got: %i\n" x y (check 10 x y)) *)
          done
        done;
        !t
      in

      print_int_pair_list scan;
      print_int (list_count_unique scan);

      (* print_int_pair_list (list_count_unique scan); *)
      (* print_int (List.length (list_count_unique scan)); *)

      (* print_list scan; *)
      print_char '\n';
      close_in ic
    with e ->
      close_in_noerr ic;
      raise e
