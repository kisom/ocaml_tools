  val have_args : int -> bool 
  val handle_unix_error : ('a -> 'b) -> 'a -> 'b
  val try_finalize : ('a -> 'b) -> 'a -> ('c -> 'd) -> 'c -> 'b
  val restart_on_EINTR : ('a -> 'b) -> 'a -> 'b 
