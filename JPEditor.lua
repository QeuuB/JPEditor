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

--- Script helpers [[

    --- Required utils
    util.require_natives('1663599433')

    --- Script wide constants
    local max_int <const> = 2147483647
    local min_int <const> = -2147483647
    local debug_enabled <const> = true

    --- Script wide Variables
    local script_local_version = '0.1.125'
    local finished_asynchronous_init = false

    --- Script wide Tables
    --

    --- Script wide functions
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

    --- Script updater [[ 

        -- Process
        -- Get up to date version number
        async_http.init('raw.githubusercontent.com', '/Oraite/JPEditor/main/JPEditor.lua', function (p_body, p_header_fields, p_status_code) 
            if (p_body:contains(script_local_version)) then
                finished_asynchronous_init = true
                return 
            end
        
            -- Here there's a new version
            -- Create update option / action
            menu.my_root():action('Update Script', {''}, '', function (p_click_type, p_effective_issuer) 
                async_http.init('raw.githubusercontent.com','/Oraite/JPEditor/main/JPEditor.lua', function (p_body, p_header_fields, p_status_code) 
                    if select(2, load(p_body)) then
                        functions.notification('[ JPEDITOR ]\nScript download has failed.\nPlease try again later.\nIf this continues to happen then manually update via github.', 3, '[ JPEDITOR ] Script download has failed. Please try again later. If this continues to happen then manually update via github.') 
                        return
                    end
        
                    local file = io.open(filesystem.scripts_dir() .. SCRIPT_RELPATH, 'wb')
                    file:write(p_body)
                    file:close()
        
                    functions.notification('[ JPEDITOR ]\nSuccessfully updated.\nRestarting script...', 3, '[ JPEDITOR ] Successfully updated.') 
                    util.restart_script()
                end)
        
                -- Dispatch
                async_http.dispatch()
            end, nil, nil, COMMANDPERM_USERONLY)

            functions.notification('[ JPEDITOR ]\nThere\'s a new version available.\nUpdate the script to get the newest version.', 3, '[ JPEDITOR ] There\'s a new version available. Update the script to get the newest version.')
            
            finished_asynchronous_init = true
            return
        end)
    
        -- Dispatch
        async_http.dispatch()
    
        -- Loop here while asynchronous http init
        repeat 
            util.yield()
        until finished_asynchronous_init

    --- ]]

--- ]]





---- Script options and actions:

--- My root [[

    menu.my_root():action('Restart Script', {''}, '', 
    function (param_click_type, param_effective_issuer) 
        util.restart_script()
    end, nil, nil, COMMANDPERM_USERONLY)

    if (script_has_new_verion) then 
        menu.my_root():action('Update Script', {''}, '', 
        function (param_click_type, param_effective_issuer) 
            async_http.init('raw.githubusercontent.com','/Oraite/JPEditor/main/JPEditor.lua', function (p_body, p_header_fields, p_status_code) 
                if select(2, load(p_body)) then
                    functions.notification('[ JPEDITOR ]\nScript download has failed.\nPlease try again later.\nIf this continues to happen then manually update via github.', 3, '[ JPEDITOR ] Script download has failed. Please try again later. If this continues to happen then manually update via github.') 
                    return
                end

                local file = io.open(filesystem.scripts_dir() .. SCRIPT_RELPATH, 'wb')
                file:write(p_body)
                file:close()

                functions.notification('[ JPEDITOR ]\nSuccessfully updated.\nRestarting script...', 3, '[ JPEDITOR ] Successfully updated.') 
                util.restart_script()
            end)

            -- Dispatch
            async_http.dispatch()
        end)
    end

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