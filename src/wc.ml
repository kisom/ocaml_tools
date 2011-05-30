(** file: wc.ml
  * author: kyle isom <coder@kyleisom.net>
  * license: ISC / public domain dual-licensed
  * 
  * UNIX wordcount utility
  *)

type result = { mutable characters:int; mutable words:int; mutable lines:int }

let max_read = 16

let display_result = fun res filename ->
  Printf.printf "%d\t%d\t%d %s\n" res.characters res.words res.lines filename

let add_result = fun r1 r2 ->
  { characters = (r1.characters + r2.characters);
    words = (r1.words + r2.words); 
    lines = (r1.lines + r2.lines) }

let scan = fun line ->
  let len = String.length line in 
  let r = { characters = 0; words = 0; lines = 0 } in
  let rec loop = fun n ->
    if n = len then r
    else begin
	let c = line.[n] in 
	r.characters <- r.characters + 1 ;
	if c = '\n' then ( r.lines <- r.lines + 1; r.words <- r.words + 1 );
	if c = '\t' then r.words <- r.words + 1;
	if c = ' '  then r.words <- r.words + 1;
	loop (n + 1);
    end in loop 0
;;

let scanfd = fun ?(filename = "") fd ->
  let buf = String.make max_read ' ' in 
  let res = { characters = 0; words = 0; lines = 0 } in
  let rec loop = fun () ->
  try
    let readsz = Unix.read fd buf 0 max_read in
    if readsz > 0 then begin
      display_result (add_result res (scan buf)) "scanfd" ;
      res = (add_result res (scan buf));
      loop ();
    end
    else display_result res filename
  with 
    | _ -> ()
  in loop ()
;;


let main = fun () ->
  let len = Array.length Sys.argv in
  if len = 1 then
    scanfd Unix.stdin
;;

main ()
