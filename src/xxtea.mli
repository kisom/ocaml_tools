type xxtea_key
val load_key : string -> xxtea_key
val dump_key : key:xxtea_key -> filename:string -> unit
(*
 * val decrypt : key:xxtea_key -> ciphertext:string -> string
 * val encrypt : key:xxtea_key -> plaintext:string -> string
 * val self_test : unit -> int 
 * val encrypt_file : key:xxtea_key -> filename:string -> int
 * val decrypt_file : key:xxtea_key -> filename:string -> int
 *)
