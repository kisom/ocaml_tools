(** 
 * file: common.mli
 * author: kyle isom <coder@kyleisom.net>
 * license: ISC / public-domain dual licensed
 *
 * implementation for my common library functions
*)

(** have_args checks Sys.argv to ensure the requisite number of commandline
  * arguments have been passed in. it returns true if at least the required
  * number of arguments have been passed in, and false otherwise.
  *)
val have_args : int -> bool 

(** from the book "UNIX System Programming in Objective CAML", attempts to
  * execute a function and handle any UNIX exceptions thrown.
  *)
val handle_unix_error : ('a -> 'b) -> 'a -> 'b

(** a try...finally construct *)
val try_finalize : ('a -> 'b) -> 'a -> ('c -> 'd) -> 'c -> 'b

(** restart function when EINTR received *)
val restart_on_EINTR : ('a -> 'b) -> 'a -> 'b 
