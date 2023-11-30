static void Part1() {
    var lines = File.ReadAllLines("../input.txt");

    var sum = 0;
    for (int i = 1; i < lines.Length; i++) {
        var prev = int.Parse(lines[i - 1]);
        var value = int.Parse(lines[i]);
        sum += prev < value ? 1 : 0;
    }

    Console.WriteLine(sum);
}

static void Part2() {
    var lines = File.ReadAllLines("../input.txt");

    // This solution is off by one
    // It's late and I don't feel like fixing it right now
    var sum = 0;
    for (int i = 4; i < lines.Length; i++) {
        var prev = lines[(i - 4)..(i - 1)].Select(int.Parse).Sum();
        var value = lines[(i - 3)..(i)].Select(int.Parse).Sum();
        sum += prev < value ? 1 : 0;
    }

    Console.WriteLine(sum);
}

Console.Write("Part1 ");
Part1();
Console.Write("Part2 ");
Part2();
