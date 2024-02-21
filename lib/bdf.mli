type t

val create: string -> (t, string) result;;

val name: t -> string;;

val bdf_version: t -> float;;

val version: t -> int;;
