local function clone<T>(x: T): T
    if type(x) == "table" then
        local t = table.clone(x)
        
        for k, v in t do
            if typeof(k) == "table" or typeof(v) == "table" then
                t[clone(k)] = clone(v)
            end
        end

        return t
    else
        return x
    end    
end

local function deep_freeze<T>(x: T)
    if type(x) == "table" then
        if not table.isfrozen(x) then table.freeze(x) end
        for i, v in x do
            deep_freeze(i)
            deep_freeze(v)
        end
    end

    return x
end

type JSONErrorKind =
    | "non_real_number"
    | "bad_type"
    | "only_use_string_key_dict"
    | "recursive_table"
    | "invalid_utf8"
    | "saving_nil"
export type JSONError = {
    why: JSONErrorKind,
    where: { string | number }
}

local function path(where: { string | number })
    local t = {}
    for i = #where, 1, -1 do
        table.insert(t, where[i])
    end
    return table.concat(t, ".")
end

local function tostring_err(self: JSONError)
    return if self.why == "bad_type" then `value at {path(self.where)} isn't JSON-encodeable`
        elseif self.why == "non_real_number" then `value at {path(self.where)} is not a real number`
        elseif self.why == "only_use_string_key_dict" then `value at {path(self.where)} is a dictionary, but not all keys are strings`
        elseif self.why == "recursive_table" then `value at {path(self.where)} is recursive.`
        elseif self.why == "invalid_utf8" then `value at {path(self.where)} contains invalid utf-8 characters.`
        elseif self.why == "saving_nil" then `attempt to save nil at {path(self.where)} - use false instead`
        else `unknown error at {path(self.where)}`
end

local function throw(why: JSONErrorKind, ...: string | number): never
    error(setmetatable({ why = why, where = { ... } }, { __tostring = tostring_err }))
end

local function check_table_type(x: { [string | number]: any }): "dict" | "array" | "bad" | "none"
    for k in x do
        if typeof(k) == "number" and k == 1 then
            return "array"
        elseif typeof(k) == "string" then
            return "dict"
        else
            return "bad"
        end
    end
    return "none"
end

local references = setmetatable({}, {__mode = "ks"})
local function check_json(x: {}, ...: string | number): boolean
    if typeof(x) == "string" then
        local result = utf8.len(x)
        if result == nil then throw("invalid_utf8", ...) end
        return true
    elseif typeof(x) == "number" then
        return if x ~= x then throw("non_real_number", ...)
            elseif math.abs(x) == math.huge then throw("non_real_number", ...)
            else true
    elseif typeof(x) == "buffer" then
        return true
    elseif typeof(x) == "boolean" then
        return true
    elseif typeof(x) == "table" then
        if references[x] then throw("recursive_table", ...) end
        references[x] = true
        local kind: "array" | "bad" | "dict" | "none" = check_table_type(x)

        if kind == "array" then
            for key, value in x do
                check_json(value, key, ...)
            end
        elseif kind == "dict" then
            for key, value in x do
                if typeof(key) ~= "string" then throw("only_use_string_key_dict", ...) end
                check_json(value, key, ...)
            end
        elseif kind == "bad" then
            throw("only_use_string_key_dict", ...)
        end

        return true
    elseif typeof(x) == "nil" then
        return throw("saving_nil")
    else
        return throw("bad_type", ...)
    end
end

local function check_json_valid(x: {})
    table.clear(references)
    return check_json(x, "root")
end

local function delta_eq<T>(a: T, b: T, ...: string): (boolean, string)
    if typeof(a) ~= typeof(b) then
        return false, table.concat({ ... }, ".")
    elseif typeof(a) == "buffer" and typeof(b) == "buffer" then
        return buffer.tostring(a) == buffer.tostring(b)
    elseif typeof(a) == "table" and typeof(b) == "table" then
        if #a ~= #b then return false, table.concat({ ... }, ".") end

        for key, value in a do
            local ok, path = delta_eq(value, b[key], key, ...)
            if not ok then return ok, path end
        end

        for key, value in b do
            if a[key] ~= nil then continue end
            local ok, path = delta_eq(value, a[key], key, ...)
            if not ok then return ok, path end
        end
        
        return true
    else
        return a == b
    end
end

return {
    clone = clone,
    deep_freeze = deep_freeze,
    check_json_valid = check_json_valid,
    delta_eq = delta_eq
}