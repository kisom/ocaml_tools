open Http_client.Convenience
open Unix

let download = fun ~url ~filename ->
  let page = http_get url in
  let fd = openfile filename [ O_RDWR; O_TRUNC; O_CREAT ] 0o644 in
  let written = single_write fd page 0 (String.length page) in
  Printf.printf "url %s written to %s (%d bytes)\n" url filename written ;
  close fd ;;

download ~url:Sys.argv.(1) ~filename:Sys.argv.(2)
