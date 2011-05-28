(* file: wget.ml
 * author: kyle isom <coder@kyleisom.net>
 *
 * very crude implementation of the wget utility
 * historical note: my first real program in ocaml
 *)
open Http_client.Convenience
open Unix

(* TODO:
   * support chunked downloading
   * some kind of progress meter would be nice
   * exception handling?
 *)

let bad_url ~msg ~url = 
  print_endline (msg ^ ": " ^ url) ;
  exit 1
;;

let download = fun ~url ~filename ->
  let page = try http_get url with Failure str  -> bad_url ~msg:str ~url:url in
  let downsz = String.length page in 
  let fd = openfile filename [ O_RDWR; O_TRUNC; O_CREAT ] 0o644 in
  let written = write fd page 0 downsz in
  Printf.printf "url %s written to %s (%d / %d bytes)\n" url filename written downsz ;
  close fd ;;

download ~url:Sys.argv.(1) ~filename:Sys.argv.(2)
