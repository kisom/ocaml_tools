(** file: xxtea.ml 
  * author: kyle isom <coder@kyleisom.net>
  * 
  * basic XXTEA implementation in OCaml
  * ॐ असतो मा सद्गमय
  * तमसो मा ज्योतिर्गमय
  * मृत्योर्मामृतं गमय
  *)

(* basic definitions required by XXTEA *)
let xxtea_key_size = 16
let xxtea_block_size = 4 (* XXTEA uses 32-bit blocks, which is 4 bytes *)
let xxtea_delta = 0x9e3779b9

(* type definitions *)
type xxtea_key_valid = InvalidKey | ValidKey
type xxtea_key = { valid: xxtea_key_valid;
		   key: string }

(** val valid_key : string -> xxtea_key 
  * this should be used to construct / validate new XXTEA keys,
  * should be called internally only. *)
let valid_key = fun key ->
  let len = String.length key in
  if len = 16 then
    { valid = ValidKey; key = key }
  else
    { valid = InvalidKey; key = "" }
;;

(** is_valid takes an xxtea_key and checks if it is valid.
  * this is designed to be an internal function only. *)
let is_valid = fun key ->
  match key.valid with
    | InvalidKey -> false ;
    | ValidKey   -> true ;
;;

(** public function to load a key from a filename *)
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

(** public function to write a key to a file *)
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

(** internal function to pad a data block *)
let rec pad = fun data ->
  let len = String.length data in 
  if len mod 4 = 0 then
    data
  else 
    pad (data ^ "\x00")
;;

(** internal function to address blocks the same way the C reference code
  * is written. *)
let get_block = fun message n ->
  let block_start = n * 4 in
  String.sub message block_start xxtea_block_size
;;

(** internal function to modify a block internally *)
let mod_block = fun message new_block n ->
  let block_start = n * 4 in
  let block_end = (n + 1) * 4 in 
  let len = String.length message in 
  let blksz = String.length new_block in
  let pre = String.sub message 0 block_start in
  let post = String.sub message block_end (len - (block_start + blksz)) in
  pre ^ new_block ^ post
;;

(** internal XXTEA function *)
 mod_block s newblk 2 ;;let mx = fun z y sum k e p ->
  let part1 = (z lsr 5) lxor (y lsl 2) in 
  let part2 = (y lsr 3) lxor (z lsl 4) in
  let part3 = sum lxor y in
  let part4 = (get_block k (p land 3)) lxor e in
  let part5 = part1 + part2 in 
  let part6 = part3 + part5 in
  part5 lxor part6
;;

(** public function to encrypt a string *)
let encrypt = fun ~key ~plaintext ->
  match key.valid with
    | InvalidKey -> 
      prerr_endline "invalid key specified, cannot encrypt!" ; 
      "" 
    | ValidKey   -> 
      (* the encryption component can now proceed *)
      let v = pad plaintext in
      let words = plaintext mod 4 in
      let rounds = 6 + (52 / words) in
      let sum = 0 in
      let z = get_block (rounds - 1) in
      let rec loop = fun rounds sum e p y z ->
	if rounds = 0 then v
	else begin
	  let sum += xxtea_delta in 
	  let rec crypto_loop = fun p ->
	    if p = (words - 1) then ()
	    else 
	      let y = get_block v (p + 1) in
	      let z = get_block v p +
	    
	  
	
