const std = @import("std");
const disk_map = struct { pos: usize, size: usize };
const printf = std.log.info;
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
    input = input[0 .. input.len - 1]; // Remove the null bit
    defer allocator.free(input);

    const block = try allocator.alloc(usize, get_block_length(input));
    defer allocator.free(block);
    make_block(block, input);

    printf("{s}", .{input});
    print_block(block);

    const full = try make_disk_map(allocator, input, 0);
    const blank = try make_disk_map(allocator, input, 1);
    defer allocator.free(full);
    defer allocator.free(blank);
    // defragment(block, full, blank);

    printf("full {any}", .{full});
    printf("blank {any}", .{blank});
    print_block(block);

    printf("{}", .{checksum(block)});
}

fn defragment(block: []usize, full: []disk_map, blank: []disk_map) void {
    _ = block;
    _ = full;
    _ = blank;
    return;
}

fn make_disk_map(allocator: std.mem.Allocator, input: []u8, offset: usize) ![]disk_map {
    const block = try allocator.alloc(disk_map, (input.len + 1) / 2);

    var shit: usize = offset;
    var i: usize = offset;
    while (i < input.len) : (i += 2) {
        shit += input[i] - gap;
        const pos = ((i + 1) / 2);
        block[pos].pos = shit;
        block[pos].size = input[i] - gap;
    }
    return block;
}

fn get_block_length(input: []u8) usize {
    var block_length: usize = 0;
    for (input) |char| {
        block_length += char - gap;
    }
    return block_length;
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

test "checksum" {
    const example = [_]usize{
        0, 0, 9, 9, 2, 1, 1, 1, 7, 7, 7, std.math.maxInt(usize), 4, 4, std.math.maxInt(usize), 3, 3, 3, std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), 5, 5, 5, 5, std.math.maxInt(usize), 6, 6, 6, 6, std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), std.math.maxInt(usize), 8, 8, 8, 8, std.math.maxInt(usize), std.math.maxInt(usize),
    };
    try std.testing.expectEqual(2858, checksum(&example));
}

test "odd" {
    try std.testing.expectEqual(0, 0 / 2);
    try std.testing.expectEqual(0, 1 / 2);
    try std.testing.expectEqual(1, 2 / 2);
    try std.testing.expectEqual(1, 3 / 2);
    try std.testing.expectEqual(2, 4 / 2);
}

test "ceil" {
    try std.testing.expectEqual(0, (0 + 1) / 2);
    try std.testing.expectEqual(1, (1 + 1) / 2);
    try std.testing.expectEqual(1, (2 + 1) / 2);
    try std.testing.expectEqual(2, (3 + 1) / 2);
    try std.testing.expectEqual(2, (4 + 1) / 2);
}
