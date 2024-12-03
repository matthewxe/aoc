namespace day3;

class Program
{
    enum States
    {
        Enabled,
        Disabled,
    }
    static void Main(string[] args)
    {
        if (args.Length != 1)
        {
            Console.WriteLine("Include a single file as the input");
            return;
        }
        string memory = File.ReadAllText(args[0]);

        // Part 1
        int part1Total = 0;
        for (int i = 0; i < memory.Length; i++)
        {
            char c = memory[i];
            if (memory[i] == 'm')
                part1Total += mult(memory[i..memory.Length]);
        }

        // Part 2
        int part2Total = 0;
        States state = States.Enabled;
        for (int i = 0; i < memory.Length; i++)
        {
            char c = memory[i];
            switch (state)
            {
                case States.Enabled:
                    switch (c)
                    {
                        case 'd':
                            state = doCheck(memory[i..memory.Length], state);
                            break;
                        case 'm':
                            part2Total += mult(memory[i..memory.Length]);
                            break;
                    }
                    break;
                case States.Disabled:
                    if (c == 'd')
                    {
                        state = doCheck(memory[i..memory.Length], state);
                    }
                    break;
            }
        }
        Console.WriteLine($"Part 1: {part1Total}\nPart 2: {part2Total}");
    }
    static States doCheck(string memory, States current)
    {
        string symbolDo = "do()";
        string symbolDont = "don't()";

        if (symbolDo.Equals(memory[..(symbolDo.Length)]) == true)
        {
            return States.Enabled;
        }
        else if (symbolDont.Equals(memory[..(symbolDont.Length)]) == true)
        {
            return States.Disabled;
        }
        else
        {
            return current;
        }
    }
    static int mult(string memory)
    {
        int state = 0;
        string string1 = "";
        string string2 = "";
        int num1 = 0;
        int num2 = 0;

        foreach (char c in memory)
        {
            switch (state)
            {
                case 0:
                    if (c != 'm')
                        return 0;
                    state++;
                    break;
                case 1:
                    if (c != 'u')
                        return 0;
                    state++;
                    break;
                case 2:
                    if (c != 'l')
                        return 0;
                    state++;
                    break;
                case 3:
                    if (c != '(')
                        return 0;
                    state++;
                    break;
                case 4:
                    if (c == ',')
                    {
                        state++;
                        break;
                    }
                    string1 += c;
                    if (int.TryParse(string1, out num1) == false)
                        return 0;
                    break;
                case 5:
                    if (c == ')')
                    {
                        return num1 * num2;
                    }
                    string2 += c;
                    if (int.TryParse(string2, out num2) == false)
                        return 0;
                    break;
            }
        }

        return 0;
    }
}
