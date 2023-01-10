--[[

    I made this little script just to try to mess with stats and globals, 
    but now I'm also using it to test features for my other script in the future

    Not distributing.

--]]

--- Script helpers [[

    --- Required utils
    util.require_natives('1663599433')

    --- Script wide constants
    local max_int <const> = 2147483647
    local min_int <const> = -2147483647
    local debug_enabled <const> = true

    --- Script wide Variables
    local script_local_version = '0.1.180'
    local script_current_version = nil
    local finished_asynchronous_init = false

    --- Script wide Tables
    --

    --- Script wide functions [[

        ---@param p_message string Message to be sent in the console
        ---@param p_notification_method integer Notification via toast: 0, log: 1, both: 2 or both different: 3
        ---@param p_log_exclusive_message? string Message to log if p_notification_method equals 3
        local function notification (p_message:string, p_notification_method:number, p_log_exclusive_message:string) 
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
        end

        ---@param p_stat string
        ---@param p_int_value integer
        local function stat_set_int (p_stat:string, p_int_value:number) 
            STATS.STAT_SET_INT(util.joaat(add_mp_index_to_string(p_stat)), p_int_value, true)
        end

        ---@param p_stat string
        ---@return integer
        local function stat_get_int (p_stat:string) 
            local integer_pointer = memory.alloc_int()
            STATS.STAT_GET_INT(util.joaat(add_mp_index_to_string(p_stat)), integer_pointer, -1)

            return memory.read_int(integer_pointer)
        end

        ---@param p_stat string
        local function stat_has_mpply (p_stat:string) 
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
        end

        ---@param p_stat string
        local function add_mp_index_to_string (p_stat:string) 
            if not stat_has_mpply(p_stat) then
                p_stat = 'MP' .. util.get_char_slot() .. '_' .. p_stat
            end

            return p_stat
        end

        local function update_script () 
            -- Http request
            async_http.init('raw.githubusercontent.com','/Oraite/JPEditor/main/JPEditor.lua', function (p_body, p_header_fields, p_status_code) 
                if select(2, load(p_body)) then
                    notification('[ JPEDITOR ]\nScript download has failed.\nPlease try again later.\nIf this continues to happen then manually update via github.', 3, '[ JPEDITOR ] Script download has failed. Please try again later. If this continues to happen then manually update via github.') 
                    return
                end
    
                local file = io.open(filesystem.scripts_dir() .. SCRIPT_RELPATH, 'wb')
                file:write(p_body)
                file:close()
    
                notification('[ JPEDITOR ]\nSuccessfully updated.\nRestarting script...', 3, '[ JPEDITOR ] Successfully updated.') 
                util.restart_script()
            end)
    
            -- Http dispatch
            async_http.dispatch()
        end

    --- ]]

    --- Script updater [[ 

        -- Check for new version
        async_http.init('raw.githubusercontent.com', '/Oraite/JPEditor/main/JPEditor.lua', function (p_body, p_header_fields, p_status_code)         
            -- Get github's version
            local found_string_start_index = string.find(p_body, 'script_local_version = \'') ?? -1
            local found_string_lenght = string.len('script_local_version = \'') ?? -1
            local string_start_index = found_string_start_index + found_string_lenght
            local string_end_index = 0
            local while_counter = string_start_index

            -- Critical error that happens when i'm dumb and change the variable name
            if (found_string_start_index == -1 or found_string_lenght == -1) then
                notification('[ JPEDITOR ]\nCritical error with the auto updater.\nPlease update manually.', 3, '[ JPEDITOR ] Critical error with the auto updater. Please update manually.')
                -- TODO: add update option instead of this bullshit ^^^
                return
            end

            while (true) do
                util.yield()
                if (string.sub(p_body, while_counter, while_counter) == '\'') then
                    break
                end
                string_end_index = while_counter
                while_counter += 1
            end

            script_current_version = string.sub(p_body, string_start_index, string_end_index)

            -- There's not a new verion
            if (script_local_version == script_current_version) then
                notification('[ JPEDITOR ]\nWelcome, your script up to date.', 0)
                finished_asynchronous_init = true
                return
            end

            -- There's a new version
            -- Create update option / action
            menu.my_root():action('Update Script', {''}, 'Update your script\nActual version: ' .. script_local_version .. '\nNew version: ' .. script_current_version, |p_click_type, p_effective_issuer| -> update_script(), nil, nil, COMMANDPERM_USERONLY)
            notification('[ JPEDITOR ]\nThere\'s a new version available.\nUpdate the script to get the newest version.', 3, '[ JPEDITOR ] There\'s a new version available. Update the script to get the newest version.')
            finished_asynchronous_init = true

            return
        end)
    
        -- Http dispatch
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

    menu.my_root():divider('JPEditor ' .. script_local_version)

    local edit_stat_root <const> = menu.my_root():list('Edit Stat', {''}, '', nil, nil, nil)
    local edit_global_root <const> = menu.my_root():list('Edit Global', {''}, '', nil, nil, nil)

    menu.my_root():action('Joaat', {'joaat'}, '\'JOAAT\' stands for \'Jenkins One At A Time\', which is the name of the hashing algorithm used pretty much everywhere in GTA.',
    function (param_click_type, param_effective_issuer)
        menu.show_command_box('joaat ')
    end,
    function (param_provided_args, param_click_type, param_effective_issuer)
        local joaat_int = util.joaat(param_provided_args)

        if (joaat_int == nil or joaat_int == 0) then
            notification('[JPEditor] Failed', 3, '[JPEditor] Successfuly failed getting \'' .. param_provided_args .. '\' hash :(')
            return
        end

        notification('[JPEditor] Success', 3, '[JPEditor] Success getting \'' .. param_provided_args .. '\' hash: ' .. joaat_int)
    end, nil, COMMANDPERM_USERONLY)

    menu.my_root():action('Reverse Joaat', {'reversejoaat'}, 'Returns an empty string if the given hash is not found in Stand\'s dictionaries.',
    function (param_click_type, param_effective_issuer)
        menu.show_command_box('reversejoaat ')
    end,
    function (param_provided_args, param_click_type, param_effective_issuer)
        local joaat_string = util.reverse_joaat(param_provided_args)

        if (joaat_string == nil or joaat_string == '') then
            notification('[JPEditor] Failed', 3, '[JPEditor] Successfuly failed getting \'' .. param_provided_args .. '\' name :(')
            return
        end

        notification('[JPEditor] Success', 3, '[JPEditor] Success getting \'' .. param_provided_args .. '\' name: ' .. joaat_string)
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
            stat_set_int(stat_set_int_name, stat_set_int_value)
            notification('Success', 3, '#4241 Set int to stat successfully')
        end, nil, nil, COMMANDPERM_USERONLY)

        edit_stat_root:divider('Stat Get Int')

        local stat_get_int_name = ''

        edit_stat_root:text_input('Stat Name', {'statgetintname'}, '',
        function (param_string, param_click_type)
            stat_get_int_name = param_string
        end, '')

        edit_stat_root:action('Execute', {''}, '',
        function (param_click_type, param_effective_issuer)
            local stat_get_int_value = stat_get_int(stat_get_int_name)
            notification('Success', 3, '#4041, Success, stat_get_int_value == ' .. stat_get_int_value)
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