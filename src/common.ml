(* file: common.ml
 * author: kyle isom <coder@kyleisom.net>
 * license: ISC / public domain dual license
 *
 * commonly-used functions
 *)
open Unix

(* val have_args: int -> bool 
 * verifies the program has at least n arguments passed in via the command line
 *)
  let have_args = fun n ->
    let len = Array.length Sys.argv in
    if len < n then
      false
    else 
      true
  ;;

(* val handle_unix_error : ('a -> 'b) -> 'a -> 'b
 * from the book "UNIX System Programming in Objective CAML"
 *)
  let handle_unix_error f arg = 
    try f arg
    with Unix_error(err, fun_name, arg) ->
      prerr_string Sys.argv.(0);
      prerr_string ": \"";
      prerr_string fun_name;
      prerr_string "\" failed";
      
      if String.length arg > 0 then begin
	prerr_string " on \"";
	prerr_string arg;
	prerr_string "\"";
      end;

      prerr_string ": ";
      prerr_endline (error_message err);
      exit 2
  ;;

(* val try_finalize : ('a -> 'b) -> 'a -> ('c -> 'd) -> 'c -> 'b
 * also taken from the book "UNIX System Programming with Objective CAML"
 *)
  let try_finalize f x finally y = 
    let res = 
      try f x 
      with exn -> finally y; 
	raise exn in 
    finally y; 
    res
  ;;

(* val restart_on_EINTR : ('a -> 'b) -> 'a -> 'b 
 * also taken from the book "UNIX System Programming with Objective CAML"
 *)
  let rec restart_on_EINTR f x =
    try f x
    with Unix_error (EINTR, _, _) -> restart_on_EINTR f x
  ;;
