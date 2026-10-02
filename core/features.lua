local list = {}

return {
    Register = function(feature)
        list[#list + 1] = feature
    end,
    All = function()
        return list
    end,
}
