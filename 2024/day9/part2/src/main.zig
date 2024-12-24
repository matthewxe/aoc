const std = @import("std");
const test_allocator = std.testing.allocator;
const gap = 48;

pub fn main() !void {
    if (std.os.argv.len != 2) {
        return error.WrongArguments;
    }

    const file = try std.fs.cwd().openFile(std.mem.span(std.os.argv[1]), .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const allocator = std.heap.page_allocator;
    var input = try file.readToEndAlloc(allocator, file_size);
    input = input[0 .. input.len - 1];
    defer allocator.free(input);

    const block_length: usize = get_block_length(input);
    const block = try allocator.alloc(usize, block_length);
    defer allocator.free(block);

    make_block(block, input);

    // std.log.info("{any}", .{block});
    print_block(block);
    defragment(block, input);
    print_block(block);
    // std.log.info("{any}", .{block});

    std.log.info("{}", .{checksum(block)});
}

fn print_block(block: []usize) void {
    for (block) |char| {
        if (char == std.math.maxInt(usize)) {
            std.debug.print("{c}", .{'.'});
        } else {
            std.debug.print("{}", .{char});
        }
    }
    std.debug.print("\n", .{});
}

fn defragment(block: []usize, input: []u8) void {
    var i: usize = 1;
    var j: usize = input.len - 1;
    while (i < input.len - 1) : (i += 2) {
        while (j > 0) : (j -= 1) {
            if (!is_even(j)) {
                continue;
            }

            const i_size: u8 = input[i] - gap;
            const j_size: u8 = input[j] - gap;

            if (j_size == 0) {
                continue;
            }
            if (i_size >= j_size) {
                const ind_i = get_index(input, i);
                const ind_j = get_index(input, j);
                std.log.info("i: {} ind_i: {} i_size: {} j: {} ind_j: {} j_size: {}", .{ i, ind_i, i_size, j, ind_j, j_size });

                var k: u8 = 0;
                while (k < j_size) : (k += 1) {
                    block[ind_i + k] = block[ind_j + k];
                    block[ind_j + k] = std.math.maxInt(usize);
                }
                input[j] = gap;
                input[i] -= j_size;
                input[i - 1] += j_size;
                break;
            }
        }
    }

    return;
}

fn make_block(block: []usize, input: []u8) void {
    var pos: usize = 0;
    for (input, 0..) |char, i| {
        const i_length = char - gap;
        const prev_pos = pos;

        while (pos < (prev_pos + i_length)) : (pos += 1) {
            if (is_even(i)) {
                block[pos] = i / 2;
            } else {
                block[pos] = std.math.maxInt(usize);
            }
        }
    }
}
fn get_index(input: []u8, n: usize) usize {
    var index: usize = 0;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        index += input[i] - gap;
    }
    return index;
}

fn checksum(block: []const usize) u64 {
    var total: u64 = 0;
    for (block, 0..) |id, pos| {
        if (id == std.math.maxInt(usize)) {
            continue;
        }
        total += id * pos;
    }
    return total;
}

fn is_even(x: usize) bool {
    if ((x % 2) == 0) {
        return true;
    }
    return false;
}

fn get_block_length(input: []u8) usize {
    var block_length: usize = 0;
    for (input) |char| {
        // std.log.info("{} - {}", .{ char, gap });
        block_length += char - gap;
    }
    return block_length;
}

test "checksum" {
    const example = [_]usize{
        0, 0, 9, 9, 2, 1, 1, 1, 7, 7, 7, std.math.maxInt(usize), 4, 4, std.math.maxInt(usize), 3, 3, 3, std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), 5, 5, 5, 5, std.math.maxInt(usize), 6, 6, 6, 6, std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), 8, 8, 8, 8, std.math.maxInt(usize), std.math.maxInt(usize),
    };
    try std.testing.expectEqual(2858, checksum(&example));
}

test "odd" {
    const zero: usize = 0 / 2;
    const odd1: usize = 1 / 2;
    const even1: usize = 2 / 2;
    const odd2: usize = 3 / 2;
    const even2: usize = 4 / 2;

    try std.testing.expectEqual(0, zero);
    try std.testing.expectEqual(0, odd1);
    try std.testing.expectEqual(1, even1);
    try std.testing.expectEqual(1, odd2);
    try std.testing.expectEqual(2, even2);
}

test "get_index" {
    const input_length = 6;
    const input = try test_allocator.alloc(u8, input_length);
    defer test_allocator.free(input);
    input[0] = '1';
    input[1] = '2';
    input[2] = '3';
    input[3] = '4';
    input[4] = '5';
    input[5] = '6';

    const block = try test_allocator.alloc(usize, get_block_length(input));
    defer test_allocator.free(block);

    make_block(block, input);
    // print_block(block);
    try std.testing.expectEqual(0, get_index(input, 0));
    try std.testing.expectEqual(1, get_index(input, 1));
    try std.testing.expectEqual(3, get_index(input, 2));
    try std.testing.expectEqual(6, get_index(input, 3));
    try std.testing.expectEqual(10, get_index(input, 4));
    try std.testing.expectEqual(15, get_index(input, 5));
}

test "defragment" {
    const input = try test_allocator.alloc(u8, 4);
    defer test_allocator.free(input);
    input[0] = '1';
    input[1] = '2';
    input[2] = '3';
    input[3] = '4';

    var block_length: usize = 0;
    for (input) |char| {
        // std.log.info("{} - {}", .{ char, gap });
        block_length += char - gap;
    }
    const block = try test_allocator.alloc(usize, block_length);
    defer test_allocator.free(block);

    // print_block(block);
}
