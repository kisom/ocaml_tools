(** file: xxtea.ml 
  * author: kyle isom <coder@kyleisom.net>
  * 
  * basic XXTEA implementation in OCaml
  * ॐ असतो मा सद्गमय
  * तमसो मा ज्योतिर्गमय
  * मृत्योर्मामृतं गमय
  *)

let xxtea_key_size = 16
type xxtea_key_valid = InvalidKey | ValidKey
type xxtea_key = { valid: xxtea_key_valid;
		   key: string }

(* val valid_key : string -> xxtea_key 
 * this should be used to construct / validate new XXTEA keys
 *)
let valid_key = fun key ->
  let len = String.length key in
  if len = 16 then
    { valid = ValidKey; key = key }
  else
    { valid = InvalidKey; key = "" }
;;

let is_valid = fun key ->
  match key.valid with
    | InvalidKey -> false ;
    | ValidKey   -> true ;
;;

let load_key = fun filename ->
  let fd = Unix.openfile filename [ Unix.O_RDONLY; ] 0 in
  let key = String.create 18 in
  let read_sz = Unix.read fd key 0 (xxtea_key_size + 1) in
  let _ = Unix.close fd in
  if read_sz = 16 then 
    valid_key (String.sub key 0 xxtea_key_size)
  else
    { valid = InvalidKey ; key = "" }
  ;;

let dump_key = fun ~key ~filename ->
  match key.valid with 
    | InvalidKey -> prerr_endline "invalid key, refusing to dump!" 
    | ValidKey   -> 
      let fd = Unix.openfile filename [ Unix.O_WRONLY; Unix.O_TRUNC; Unix.O_CREAT; ]
	0o600 in
      let wrsz = Unix.single_write fd key.key 0 xxtea_key_size in
      let _ = Unix.close fd in
      if wrsz = xxtea_key_size then
	print_endline ("succesfully dumped key to " ^ filename)
      else
	prerr_endline ("error dumping key to " ^ filename)
;;

let rec pad = fun data ->
  let len = String.length data in 
  if len mod 4 = 0 then
    data
  else 
    pad (data ^ "\x00")
;;

let encrypt = fun ~key ~plaintext ->
  match key.valid with
    | InvalidKey -> 
      prerr_endline "invalid key specified, cannot encrypt!" ; 
      "" 
    | ValidKey   ->
      let pt = pad plaintext in
