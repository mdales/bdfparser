type t

type glyph

val create: string -> (t, string) result

val name: t -> string

val bdf_version: t -> float

val version: t -> int

val glyph_count: t -> int
(** [glyph_count font] Returns a count of how many glyphs are in the font. *)

val glyph_of_char: t -> Uchar.t -> glyph option
(** [glyph_of_char font char] Gets the glyph that maps to a given character in the font,
    or None if that character doesn't have an entry. *)

val glyph_name: glyph -> string
(** [glyph_name glyph] Returns the name in the font file of the specified glyph. *)

val glyph_bbox: glyph -> (int * int * int * int)
(** [glyph_bbox glyph] The underlying font bbox parameter. *)

val glyph_dwidth: glyph -> (int * int)
(** [glyph_dwidth glyph] The underlying font dwidth parameter. *)

val glyph_dimensions: glyph -> (int * int * int * int)
(** [glyph_dimensions glyph] Returns the width and height of the specified glyph, along with the x and y offsets from the drawing location to allow for descenders etc. *)

val glyph_bitmap: glyph -> bytes
(** [glyph_bitmap glyph] Renders a glyph to a series of bytes. The data is 1 bit per pixel,
    as a series of bytes per row, padded to the appropriate next byte boundary. *)
