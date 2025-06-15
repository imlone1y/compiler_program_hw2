import java.util.*;

public class App {
    static Set<String> males = Set.of("Andy", "Bob", "Cecil", "Dennis", "Edward", "Felix", "Martin", "Oscar", "Quinn");
    static Set<String> females = Set.of("Gigi", "Helen", "Iris", "Jane", "Kate", "Liz", "Nancy", "Pattie", "Rebecca");

    static Map<String, String> spouses = new HashMap<>();
    static Map<String, Set<String>> childrenMap = new HashMap<>();

    public static void main(String[] args) {
        initData();

        Scanner scanner = new Scanner(System.in);
        System.out.println("relation/name/name：");
        String relation = scanner.next();
        String name1 = scanner.next();
        String name2 = scanner.next();

        System.out.println(checkRelation(relation, name1, name2));
    }

    static void initData() {
        // Spouses
        spouses.put("Bob", "Helen");
        spouses.put("Helen", "Bob");

        spouses.put("Dennis", "Pattie");
        spouses.put("Pattie", "Dennis");

        spouses.put("Gigi", "Martin");
        spouses.put("Martin", "Gigi");

        // Parent-child
        addChild("Andy", "Bob");
        addChild("Bob", "Cecil");
        addChild("Cecil", "Dennis");
        addChild("Dennis", "Edward");
        addChild("Edward", "Felix");

        addChild("Gigi", "Helen");
        addChild("Helen", "Iris");
        addChild("Iris", "Jane");
        addChild("Jane", "Kate");
        addChild("Kate", "Liz");

        addChild("Martin", "Nancy");
        addChild("Nancy", "Oscar");
        addChild("Oscar", "Pattie");
        addChild("Pattie", "Quinn");
        addChild("Quinn", "Rebecca");
    }

    static void addChild(String parent, String child) {
        childrenMap.computeIfAbsent(parent, k -> new HashSet<>()).add(child);
        String spouse = spouses.get(parent);
        if (spouse != null) {
            childrenMap.computeIfAbsent(spouse, k -> new HashSet<>()).add(child);
        }
    }

    static Set<String> getParents(String person) {
        Set<String> parents = new HashSet<>();
        for (var entry : childrenMap.entrySet()) {
            if (entry.getValue().contains(person)) {
                parents.add(entry.getKey());
            }
        }
        return parents;
    }

    static boolean isParent(String parent, String child) {
        return getParents(child).contains(parent);
    }

    static boolean areSiblings(String a, String b) {
        return !a.equals(b) && !Collections.disjoint(getParents(a), getParents(b));
    }

    static boolean isBrother(String a, String b) {
        return areSiblings(a, b) && males.contains(a) && males.contains(b);
    }

    static boolean isSister(String a, String b) {
        return areSiblings(a, b) && females.contains(a) && females.contains(b);
    }

    static boolean areCousins(String a, String b) {
        Set<String> aParents = getParents(a);
        Set<String> bParents = getParents(b);
        for (String p1 : aParents) {
            for (String p2 : bParents) {
                if (areSiblings(p1, p2)) {
                    return true;
                }
            }
        }
        return false;
    }

    static boolean checkRelation(String relation, String name1, String name2) {
        return switch (relation.toLowerCase()) {
            case "parent" -> isParent(name1, name2);
            case "sibling" -> areSiblings(name1, name2);
            case "brother" -> isBrother(name1, name2);
            case "sister" -> isSister(name1, name2);
            case "cousin" -> areCousins(name1, name2);
            default -> {
                System.out.println("invalid input" + relation);
                yield false;
            }
        };
    }
}


// Dennis and Jane are cousins
// Cecil and Oscar are cousins
// Iris and Oscar are cousins
// Flex and Rebecca are cousins
// Helen and Nancy are sisters
// Cecil and Iris are siblings
// Edward and Quinn are brothers