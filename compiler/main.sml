(* Initialize *)
val males = ["Andy", "Bob", "Cecil", "Dennis", "Edward", "Felix", "Martin", "Oscar", "Quinn"];
val females = ["Gigi", "Helen", "Iris", "Jane", "Kate", "Liz", "Nancy", "Pattie", "Rebecca"];

val married = [("Bob", "Helen"), ("Helen", "Bob"),
               ("Dennis", "Pattie"), ("Pattie", "Dennis"),
               ("Gigi", "Martin"), ("Martin", "Gigi")];

val parent = [
  ("Andy", "Bob"), ("Bob", "Cecil"), ("Cecil", "Dennis"), ("Dennis", "Edward"),
  ("Edward", "Felix"), ("Gigi", "Helen"), ("Helen", "Iris"), ("Iris", "Jane"),
  ("Jane", "Kate"), ("Kate", "Liz"), ("Martin", "Nancy"), ("Nancy", "Oscar"),
  ("Oscar", "Pattie"), ("Pattie", "Quinn"), ("Quinn", "Rebecca")
];

(* Lookup parents of a child *)
fun parents_of child =
  let
    val direct = List.filter (fn (_, c) => c = child) parent
    val direct_parents = List.map #1 direct
    val spouse_parents =
      List.mapPartial
        (fn (p, _) =>
          case List.find (fn (a, _) => a = p) married of
              SOME (_, s) => SOME s
            | NONE => NONE
        ) direct
  in
    direct_parents @ spouse_parents
  end;

(* Gender check *)
fun is_male x = List.exists (fn y => y = x) males;
fun is_female x = List.exists (fn y => y = x) females;

(* Siblings *)
fun siblings x =
  let
    val px = parents_of x
    fun share_parent y =
      x <> y andalso List.exists (fn p => List.exists (fn q => p = q) (parents_of y)) px
  in
    List.filter share_parent (List.map #2 parent)
  end;

(* Brothers and Sisters *)
fun brothers x = List.filter is_male (siblings x);
fun sisters x = List.filter is_female (siblings x);

(* Cousins *)
fun cousins x =
  let
    val px = parents_of x
    val aunts_uncles = List.concat (List.map siblings px)
    val cousin_pairs = List.concat (List.map (fn au => List.filter (fn (p,c) => p = au) parent) aunts_uncles)
  in
    List.map #2 cousin_pairs
  end;

(* Relationship Boolean Check *)
fun has_relation "parent" a b =
      List.exists (fn p => p = a) (parents_of b)
  | has_relation "siblings" a b =
      List.exists (fn s => s = b) (siblings a)
  | has_relation "brothers" a b =
      List.exists (fn s => s = b) (brothers a)
  | has_relation "sisters" a b =
      List.exists (fn s => s = b) (sisters a)
  | has_relation "cousins" a b =
      List.exists (fn s => s = b) (cousins a)
  | has_relation _ _ _ = false;

fun boolToStr true = "true"
  | boolToStr false = "false";

(* test cases *)
val _ = print ("parent Helen Cecil: " ^ boolToStr (has_relation "parent" "Helen" "Cecil") ^ "\n");
val _ = print ("parent Cecil Felix: " ^ boolToStr (has_relation "parent" "Cecil" "Felix") ^ "\n");
val _ = print ("siblings Cecil Iris: " ^ boolToStr (has_relation "siblings" "Cecil" "Iris") ^ "\n");
val _ = print ("siblings Jane Pattie: " ^ boolToStr (has_relation "siblings" "Jane" "Pattie") ^ "\n");
val _ = print ("brothers Edward Quinn: " ^ boolToStr (has_relation "brothers" "Edward" "Quinn") ^ "\n");
val _ = print ("brothers Cecil Iris: " ^ boolToStr (has_relation "brothers" "Cecil" "Iris") ^ "\n");
val _ = print ("sisters Helen Nancy: " ^ boolToStr (has_relation "sisters" "Helen" "Nancy") ^ "\n");
val _ = print ("sisters Iris Pattie: " ^ boolToStr (has_relation "sisters" "Iris" "Pattie") ^ "\n");
val _ = print ("cousins Iris Oscar: " ^ boolToStr (has_relation "cousins" "Iris" "Oscar") ^ "\n");
val _ = print ("cousins Kate Quinn: " ^ boolToStr (has_relation "cousins" "Kate" "Quinn") ^ "\n");

