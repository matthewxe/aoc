(** function print_string_list prints every line of a string list *)
let rec print_string_list l =
  match l with
  | [] -> print_char '\n'
  | v :: t ->
      print_endline v;
      print_string_list t

let () =
  if Array.length Sys.argv <> 2 then print_endline "part1 [filename]"
  else
    let ic = open_in Sys.argv.(1) in
    try
      let map = In_channel.input_lines ic in
      print_string_list map;
      let max_x = String.length (List.hd map) - 1 in
      let max_y = List.length map - 1 in

      (* function get_height takes an x and y value and gives you an int
          for the height of that coordinate going from l-r t-b, 0 indexed
          10 means it's an error and you shouldnt count it *)
      let get_height x y =
        if x < 0 || y < 0 || y > max_y || x > max_x
        (* this is for test cases using '.' for blank values *)
        (* || String.get (List.nth map y) x = '.' *)
        then 10
        else int_of_char (String.get (List.nth map y) x) - 48
      in

      (* Recursively check a path for its score *)
      (* N is the previous height and x/y is the current square thats being checked *)
      let rec check n x y =
        let cur = get_height x y in
        if n = cur - 1 then
          if cur = 9 then 1
          else
            check cur (x + 1) y
            + check cur (x - 1) y
            + check cur x (y + 1)
            + check cur x (y - 1)
        else 0
      in

      (* Run check on every single coordinate and ad em up *)
      let scan =
        let t = ref 0 in
        for y = 0 to max_y do
          for x = 0 to max_x do
            if get_height x y = 0 then t := !t + check (-1) x y
              (* Printf.printf "caught! %i %i got: %i\n" x y (check (-1) x y)) *)
          done
        done;
        !t
      in

      print_int scan;

      print_char '\n';
      close_in ic
    with e ->
      close_in_noerr ic;
      raise e
