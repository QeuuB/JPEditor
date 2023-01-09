--[[

    wm29 hash 465894841, weapon_pistolxm3
    stat? 14170 OR 14171 OR 36670
    search #15 #16 #17
    memory.read_int(memory.script_global(262145 + 36670))
    memory.script_global(262145)

    candycane hash 1703483498:
    return 14180 OR 14181 OR 36671
    
    weapon_railgunxm3 -22923932:
    return 14190 OR 14191 OR 36672

    unlock m16
    weapon_tacticalrifle
    hash 3520460075
    memory.write_int(memory.script_global(262145 + 32775), 1)

    mp_weapons.c
    	case 465894841:
    		stat = 14164;
    		stat2 = 14165;
    	break;
    -        

    silent_aimbot_root:action('Create', {''}, 'Temp.',
    function()
        local lPlayerPos = players.get_position(players.user())
        util.request_model(4180675781, 2000)
        local lVehicle = entities.create_vehicle(4180675781, lPlayerPos, math.random(0, 270))
        util.request_model(1382414087, 2000)
        PED.CREATE_PED_INSIDE_VEHICLE(lVehicle, PED_TYPE_CIVMALE, 1382414087, -1, true, true)
    end, nil, nil, COMMANDPERM_USERONLY)

    -- Event tags
    Modded Event (N6) - PTFX spam
    Crash Event (E0) - Caused by fatal error, ignore
    Crash Event (N1) - ?
    Crash Event (T6) - ?
    Crash Event (XC) - ?

--]]

--- Update script [[

    -- Variables
    local script_local_version = '90.12.300'
    local script_current_version

    -- Process
    -- Get up to date version number
    async_http.init('raw.githubusercontent.com', '/Oraite/JPEditor/main/JPEditor.lua', function (p_body, p_header_fields, p_status_code) 

        -- Get current version in github script
        local string_start_index = 0
        local string_end_index = 0

        local found_string_start_index = string.find(p_body, 'script_local_version = \'')
        local found_string_lenght = string.len('script_local_version = \'')
        local small_body = string.sub(p_body, 0, found_string_start_index + 200)

        string_start_index = found_string_start_index + found_string_lenght

        local while_counter = found_string_start_index + found_string_lenght
        while true do
            util.yield()

            if (string.sub(small_body, while_counter, while_counter) == '\'') then
                break
            end

            string_end_index = while_counter
            while_counter += 1
        end

        local script_current_version_string = string.sub(small_body, string_start_index, string_end_index)
        util.log('#649, script_current_version_string == ' .. tostring(script_current_version_string))
        script_current_version = tonumber(script_current_version_string)
        util.log('#650, script_current_version == ' .. tostring(script_current_version))

    end)

    async_http.dispatch()

    repeat 
        util.yield()
    until response

    -- Update if new version
    --if script_local_version ~= script_current_version then
    --    util.toast('New JPEditor version is available, update the lua to get the newest version.')

    --    menu.my_root():action('Update Lua', {''}, '', function (param_click_type, param_effective_issuer) 
    --        async_http.init('raw.githubusercontent.com','/Prisuhm/JinxScript/main/JinxScript.lua', function (p_body, p_header_fields, p_status_code) 
    --            local err <const> = select(2, load(p_body))

    --            if err then
    --                util.toast('Script failed to download. Please try again later. If this continues to happen then manually update via github.') 
    --                return
    --            end

    --            local file = io.open(filesystem.scripts_dir() .. SCRIPT_RELPATH, 'wb')

    --            file:write(p_body)
    --            file:close()

    --            util.toast('Successfully updated JPEditor. Restarting Script... :)')
    --            util.restart_script()
    --        end)

    --        async_http.dispatch()
    --    end)
    --end

--- ]]

--- Script helpers [[

    -- Required utils
    util.require_natives('1663599433')

    -- Script wide constants
    local max_int <const> = 2147483647
    local min_int <const> = -2147483647
    local debug_enabled <const> = true

    -- Script wide Variables
    --

    -- Script wide Tables
    --

    -- Script wide functions
    local functions = {

        ---@param p_message string Message to be sent in the console
        ---@param p_notification_method integer Notification via toast: 0, log: 1, both: 2 or both different: 3
        ---@param p_log_exclusive_message? string Message to log if p_notification_method equals 3
        ['notification'] = function (p_message, p_notification_method, p_log_exclusive_message)
            if (p_message == nil) then return end
            switch (p_notification_method) do
                case (0):
                    util.toast(p_message)
                break
                case (1):
                    util.log(p_message)
                break
                case (2):
                    util.toast(p_message)
                    util.log(p_message)
                break
                case (3):
                    if (p_log_exclusive_message == nil) then return end
                    util.toast(p_message)
                    util.log(p_log_exclusive_message)
                break
            end
        end,

        ---@param p_stat string
        ---@param p_int_value integer
        ['stat_set_int'] = function (p_stat, p_int_value)
            STATS.STAT_SET_INT(util.joaat(functions.add_mp_index_to_string(p_stat)), p_int_value, true)
        end,

        ---@param p_stat string
        ---@return integer
        ['stat_get_int'] = function (p_stat)
            local integer_pointer = memory.alloc_int()
            STATS.STAT_GET_INT(util.joaat(functions.add_mp_index_to_string(p_stat)), integer_pointer, -1)

            return memory.read_int(integer_pointer)
        end,

        ---@param p_stat string
        ['stat_has_mpply'] = function (p_stat)
            local stats = {
                'MP_PLAYING_TIME',
            }

            for i = 1, #stats do
                if p_stat == stats[i] then
                    return true
                end
            end

            if string.find(p_stat, 'MPPLY_') then
                return true
            else
                return false
            end
        end,
        
        ---@param p_stat string
        ['add_mp_index_to_string'] = function (p_stat)
            if not functions.stat_has_mpply(p_stat) then
                p_stat = 'MP' .. util.get_char_slot() .. '_' .. p_stat
            end

            return p_stat
        end

    }

--- ]]





---- Script options and actions:

--- My root [[

    menu.my_root():action('Restart Script', {''}, '',
    function (param_click_type, param_effective_issuer)
        util.restart_script()
    end, nil, nil, COMMANDPERM_USERONLY)

    menu.my_root():divider('JPEditor')

    local edit_stat_root <const> = menu.my_root():list('Edit Stat', {''}, '', nil, nil, nil)
    local edit_global_root <const> = menu.my_root():list('Edit Global', {''}, '', nil, nil, nil)

    menu.my_root():action('Joaat', {'joaat'}, '\'JOAAT\' stands for \'Jenkins One At A Time\', which is the name of the hashing algorithm used pretty much everywhere in GTA.',
    function (param_click_type, param_effective_issuer)
        menu.show_command_box('joaat ')
    end,
    function (param_provided_args, param_click_type, param_effective_issuer)
        local joaat_int = util.joaat(param_provided_args)

        if (joaat_int == nil or joaat_int == 0) then
            functions.notification('[JPEditor] Failed', 3, '[JPEditor] Successfuly failed getting \'' .. param_provided_args .. '\' hash :(')
            return
        end

        functions.notification('[JPEditor] Success', 3, '[JPEditor] Success getting \'' .. param_provided_args .. '\' hash: ' .. joaat_int)
    end, nil, COMMANDPERM_USERONLY)

    menu.my_root():action('Reverse Joaat', {'reversejoaat'}, 'Returns an empty string if the given hash is not found in Stand\'s dictionaries.',
    function (param_click_type, param_effective_issuer)
        menu.show_command_box('reversejoaat ')
    end,
    function (param_provided_args, param_click_type, param_effective_issuer)
        local joaat_string = util.reverse_joaat(param_provided_args)

        if (joaat_string == nil or joaat_string == '') then
            functions.notification('[JPEditor] Failed', 3, '[JPEditor] Successfuly failed getting \'' .. param_provided_args .. '\' name :(')
            return
        end

        functions.notification('[JPEditor] Success', 3, '[JPEditor] Success getting \'' .. param_provided_args .. '\' name: ' .. joaat_string)
    end, nil, COMMANDPERM_USERONLY)

    menu.my_root():divider('Settings')

    local settings_root <const> = menu.my_root():list('Script Settings', {''}, '', nil, nil, nil)

    --- Edit stat root [[

        edit_stat_root:divider('Stat Set Int')

        local stat_set_int_name = ''
        local stat_set_int_value = 0

        edit_stat_root:text_input('Stat Name', {'statsetintname'}, '',
        function (param_string, param_click_type)
            stat_set_int_name = param_string
        end, '')

        edit_stat_root:slider('Integer Value', {'statsetintinteger'}, '', min_int, max_int, 0, 1,
        function (param_value, param_previous_value, param_click_type)
            stat_set_int_value = param_value
        end)

        edit_stat_root:action('Execute', {''}, '',
        function (param_click_type, param_effective_issuer)
            functions.stat_set_int(stat_set_int_name, stat_set_int_value)
            functions.notification('Success', 3, '#4241 Set int to stat successfully')
        end, nil, nil, COMMANDPERM_USERONLY)

        edit_stat_root:divider('Stat Get Int')

        local stat_get_int_name = ''

        edit_stat_root:text_input('Stat Name', {'statgetintname'}, '',
        function (param_string, param_click_type)
            stat_get_int_name = param_string
        end, '')

        edit_stat_root:action('Execute', {''}, '',
        function (param_click_type, param_effective_issuer)
            local stat_get_int_value = functions.stat_get_int(stat_get_int_name)
            functions.notification('Success', 3, '#4041, Success, stat_get_int_value == ' .. stat_get_int_value)
        end, nil, nil, COMMANDPERM_USERONLY)

    --- ]]

    --- Edit global root [[

        edit_global_root:divider('Global Set Int')

        edit_global_root:action('Not Implemented', {''}, '',
        function (param_click_type, param_effective_issuer)
        end, nil, nil, COMMANDPERM_USERONLY)

        edit_global_root:divider('Global Get Int')

        edit_global_root:action('Not Implemented', {''}, '',
        function (param_click_type, param_effective_issuer)
        end, nil, nil, COMMANDPERM_USERONLY)

    --- ]]

--- ]]





---- Bottom script helpers:

--- Script helpers [[

    ---- Required utils
    util.on_stop(function () 
    end)

--- ]]

--[[

    That's it

--]]