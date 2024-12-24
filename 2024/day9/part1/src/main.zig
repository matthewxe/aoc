const std = @import("std");
const test_allocator = std.testing.allocator;
const gap = 48;

fn is_even(x: usize) bool {
    if ((x % 2) == 0) {
        return true;
    }
    return false;
}

pub fn main() !void {
    if (std.os.argv.len != 2) {
        return error.WrongArguments;
    }

    const file = try std.fs.cwd().openFile(std.mem.span(std.os.argv[1]), .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const allocator = std.heap.page_allocator;
    const input = try file.readToEndAlloc(allocator, file_size);
    defer allocator.free(input);

    // std.log.info("{s} start: {c} end: {c}", .{ input, input[0], input[file_size - 2] });

    var full: usize = 0;
    for (0..file_size - 1) |i| {
        if (is_even(i)) {
            full += input[i] - gap;
        }

        // if (((i + 1) % 2) == 0) {
        //     blank += input[i] - gap;
        // } else {
        //     full += input[i] - gap;
        // }
    }
    // std.log.info("full: {}", .{full});
    var block = try allocator.alloc(usize, full);
    defer allocator.free(block);

    // The position of the new block
    var pos: usize = 0;
    // The ones iterating over the input
    var i: usize = 0;
    var j: usize = file_size - 2;
    while (i <= j) {
        const i_length = input[i] - gap;
        const prev_pos = pos;

        if (is_even(i)) {
            // Part where its in a full
            while (pos < (prev_pos + i_length)) {
                block[pos] = i / 2;
                pos += 1;
            }
        } else {
            // Part where its in a blank
            while (pos < (prev_pos + i_length)) {
                if (is_even(j)) {
                    const j_length: isize = input[j] - gap;
                    if (j_length < 1) {
                        j -= 1;
                        continue;
                    }

                    block[pos] = j / 2;
                    pos += 1;
                    input[j] -= 1;
                } else {
                    j -= 1;
                }
            }
        }
        i += 1;
    }

    std.log.info("{}", .{checksum(block)});

    // go through the diskmap using 2 pointers
    // when the 2 pointers meet that means we no longer need to fill in any empty gaps

    // 1. Turn the diskmap into the representation
    // 2. Sort the representation
    // 3. Plug the representation into the checksum
}

pub fn checksum(block: []const usize) u64 {
    var total: u64 = 0;
    for (block, 0..) |id, pos| {
        if (id == -1) {
            continue;
        }
        total += id * pos;
    }
    return total;
}

test "checksum" {
    const example = [_]usize{ 0, 0, 9, 9, 8, 1, 1, 1, 8, 8, 8, 2, 7, 7, 7, 3, 3, 3, 6, 4, 4, 6, 5, 5, 5, 5, 6, 6 };
    try std.testing.expectEqual(1928, checksum(&example));
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

// test "simple test" {
//     var list = std.ArrayList(i32).init(std.testing.allocator);
//     defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
//     try list.append(42);
//     try std.testing.expectEqual(@as(i32, 42), list.pop());
// }
