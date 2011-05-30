(** file: cat.ml
  * author: kyle isom <coder@kyleisom.net>
  * license: ISC / public-domain dual-license
  *
  * implementation of UNIX cat utility
*)

let rd_sz = 16

let cat = fun fd_in fd_out ->
  buf = String.create rd_sz in 
  try
    let _ = Unix.read fd_in 0 rd_sz in
    let _ = Unix.single_write fd_out 0 rd_sz
  with End_of_file -> ()
;;

let main = fun () ->
  let len = Array.length Sys.argv in
  if len = 1 then
    cat Unix.stdin Unix.stdout
  else
    ()
;;

main () 
