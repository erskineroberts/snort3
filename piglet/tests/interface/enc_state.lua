plugin =
{
    type = "piglet",
    name = "piglet::enc_state",
    test = function()
        -- Put the dofile here so that it doesn't get loaded twice
        dofile(SCRIPT_DIR .. "/common.lua")
        return run_all(tests)
    end
}

tests =
{
    initialize = function()
        local es = EncState.new()
        assert(es)
    end
}
