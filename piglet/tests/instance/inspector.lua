plugin =
{
    type = "piglet",
    name = "inspector::telnet",
    test = function()
        dofile(SCRIPT_DIR .. "/common.lua")
        return run_all(tests)
    end
}

HEADER = [[
45  | 00  | 00  46 | 00 00 | 00 00 | 01 | 06
00 00 | 00 00 00 01 | 00 00 00 02

00 00 | 00 00 | 00 00 00 00 | 00 00 00 00 | 06 02
00 00 ff ff | 00 00 | 00 00 | 00 00
]]

DATA = "abcdefghijklmnopqrstuvwxyz"

get_packet = function()
    return get_ipv4_packet(HEADER:as_content_hex(), DATA)
end

tests =
{
    initialize = function()
        assert(Inspector)
    end,

    eval = function()
        local p, rb = get_packet()
        Inspector.eval(p)
    end,

    clear = function()
        local p, rb = get_packet()
        Inspector.clear(p)
    end,

    get_buf_from_type = function()
        local p, rb = get_packet()
        local ib = RawBuffer.new()

        -- InspectionBuffer::Type::IB_ALT == 4
        local rv = Inspector.get_buf_from_type(4, p, ib)
        assert(not rv)
    end,

    get_buf_from_key = function()
        local p, rb = get_packet()
        local ib = RawBuffer.new()

        local rv = Inspector.get_buf_from_key("foo", p, ib)
        assert(not rv)
    end,

    get_buf_from_id = function()
        local p, rb = get_packet()
        local ib = RawBuffer.new()

        local rv = Inspector.get_buf_from_key(0, p, ib)
        assert(not rv)
    end,

    get_splitter = function()
        local spl = Inspector.get_splitter(false)
        assert(type(spl) == "userdata")

        spl = Inspector.get_splitter(true)
        assert(type(spl) == "userdata")
    end
}
