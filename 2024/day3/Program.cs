namespace day3;

class Program
{
    enum States
    {
        Enabled,
        Disabled,
        Meh,
    }
    static void Main(string[] args)
    {
        if (args.Length != 1)
        {
            Console.WriteLine("Include a single file as the input");
            return;
        }
        string memory = File.ReadAllText(args[0]);

        int total = 0;
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
                            state = dornt(memory[i..memory.Length], state);
                            break;
                        case 'm':
                            total += mult(memory[i..memory.Length]);
                            break;
                    }
                    break;
                case States.Disabled:
                    if (c == 'd')
                    {
                        state = dornt(memory[i..memory.Length], state);
                    }
                    break;
            }
            if (c == 'm')
            {
            }
        }
        Console.WriteLine(total);
    }
    static States dornt(string memory, States current)
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
                        // state = 0;
                        // int multed = num1 * num2;
                        // Console.WriteLine(string1);
                        // Console.WriteLine(string2);
                        // Console.WriteLine("Multed: ", multed);
                        // string1 = "";
                        // string2 = "";
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
