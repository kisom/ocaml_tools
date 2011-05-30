(** file: cat.ml
  * author: kyle isom <coder@kyleisom.net>
  * license: ISC / public-domain dual-license
  *
  * implementation of UNIX cat utility
*)

let rd_sz = 16

let rec cat = fun fd_in fd_out ->
  let buf = String.create rd_sz in
  try 
    let rdn = Unix.read fd_in buf 0 rd_sz in
    let _ = Unix.single_write fd_out buf 0 rdn in
    if rdn = 0 then ()
    else cat fd_in fd_out 
  with 
    | End_of_file -> ()
;;


let main = fun () ->
  let len = Array.length Sys.argv in
  if len = 1 then
    cat Unix.stdin Unix.stdout
  else
      let rec loop = fun n ->
	if n >= Array.length Sys.argv then ()
	else
	  try 
	    let fd = Unix.openfile Sys.argv.(n) [ Unix.O_RDONLY; ] 0 in
	    let _ = cat fd Unix.stdout in 
	    let _ = Unix.close fd in
	    loop (n + 1)
          with
	    | Unix.Unix_error (Unix.ENOENT, "open", filename) ->
	      prerr_string (Filename.basename Sys.argv.(0) ^ ": " ^ filename ^ 
			    ": No such file or directory\n") ;
	      loop (n + 1);
      in loop 1
;;

main () 
