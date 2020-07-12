DFCL = {};

--[[
    Description:
    Creates a class object.
--]]
function DFCL:New( ui_name )

    -- Private fields
    local private = {};
    
    private.mainPanel = {};     -- Main panel
    private.panels = {};        -- All registered panels                                   
    private.ignorePanels = {};  -- Ignored panels when setting states
    private.eventName = ui_name .. "_" .. tostring( SysTime() );    -- Unique name for hooks
    private.contextMenuState = false; -- Context menu status

    -- Public fields
    local public = {};

    --[[
        Description:
        Returns the main panel.
        --------------
        @return (Panel) - Main Panel
    --]]
    function public:GetMainPanel()
        return private.mainPanel;
    end;

    --[[
        Description:
        Focuses the main panel and all the dependencies.
    --]]
    function public:MakePopup()
        private.mainPanel:MakePopup();
    end;

    --[[
        Description:
        Registers the panel in the system.
        --------------
        @param (Panel) panel - Panel for registration in the system
        @param (Boolean : false) isMainPanel - Is this the main panel or not
    --]]
    function public:AddPanel( panel, isMainPanel )
        if ( isMainPanel ~= nil and isMainPanel ) then
            private.mainPanel = panel;
        end;

        table.insert( private.panels, panel );
    end;

    --[[
        Description:
        Removes a panel from the system.
        --------------
        @param (Panel) panel - Panel object to delete
    --]]
    function public:RemovePanel( panel )
        for i = 1, table.Count( private.panels ) do
            if ( private.panels[ i ] == panel ) then
                table.remove( private.panels, i );
                break;
            end;
        end;
    end;

    --[[
        Description:
        Adds a panel to the ignore list.
        --------------
        @param (Panel) panel - A panel object
    --]]
    function public:AddIgnorePanel( panel )
        table.insert( private.ignorePanels, panel );
    end;

    --[[
        Description:
        Check that the panel is in the ignored list.
        --------------
        @return (Boolean) - Return true if the panel is listed
    --]]
    function public:IsIgnorePanel( panel )
        if ( table.HasValue( private.ignorePanels, panel ) ) then
            return true;
        end;
        return false;
    end;

    --[[
        Description:
        Removes a panel from the ignored list.
        --------------
        @param (Panel) panel - A panel object
    --]]
    function public:RemoveIgnorePanel( panel )
        for i = 1, table.Count( private.panels ) do
            if ( private.panels[ i ] == panel ) then
                table.remove( private.panels, i );
                break;
            end;
        end;
    end;

    --[[
        Description:
        Returns the name for the hooks.
        --------------
        @return (String) - Name of hooks
    --]]
    function public:GetEventName()
        return private.eventName;
    end;

    --[[
        Description:
        Returns a list of registered panels.
        --------------
        @return (Panel[]) - List of panel objects
    --]]
    function public:GetPanels()
        return private.panels;
    end;

    --[[
        Description:
        Sets the state of the panel.
        --------------
        @param (Panel) panel - A panel object
        @param (Boolean) keyboard_state - Keyboard activity status
        @param (Boolean) mouse_state - Mouse activity status
    --]]
    function public:PanelState( panel, keyboard_state, mouse_state )
        if ( not table.HasValue( private.panels, panel ) ) then
            return;
        end;

        if ( self:IsIgnorePanel( panel ) ) then
            return;
        end;

        panel:SetKeyboardInputEnabled( keyboard_state );
        panel:SetMouseInputEnabled( mouse_state );
    end;

    --[[
        Description:
        Sets the state for the selected panel list.
        --------------
        @param (Panel[]) panels - List of panel objects
        @param (Boolean) keyboard_state - Keyboard activity status
        @param (Boolean) mouse_state - Mouse activity status
    --]]
    function public:PanelsState( panels, keyboard_state, mouse_state )
        for _, panel in pairs( panels ) do
            if ( not table.HasValue( private.panels, panel ) ) then
                continue;
            end;

            if ( self:IsIgnorePanel( panel ) ) then
                continue;
            end;

            panel:SetKeyboardInputEnabled( keyboard_state );
            panel:SetMouseInputEnabled( mouse_state );
        end;
    end;


    --[[
        Description:
        Sets the state for all panels.
        --------------
        @param (Boolean) keyboard_state - Keyboard activity status
        @param (Boolean) mouse_state - Mouse activity status
    --]]
    function public:PanelAllState( keyboard_state, mouse_state, ignorePanels )
        for _, panel in pairs( private.panels ) do

            if ( self:IsIgnorePanel( panel ) ) then
                continue;
            end;

            if ( ignorePanels ~= nil ) then
                if ( ispanel( ignorePanels ) ) then
                    
                    if ( ignorePanels == panel ) then
                        continue;
                    end;

                elseif ( istable( ignorePanels ) ) then

                    if ( table.HasValue( ignorePanels, panel ) ) then
                        continue;
                    end;

                end;
            end;

            panel:SetKeyboardInputEnabled( keyboard_state );
            panel:SetMouseInputEnabled( mouse_state );
        end;
    end;

    --[[
        Description:
        Returns the status of the context menu.
        --------------
        @return (Boolean) - Will return true if the context menu is open
    --]]
    function public:ContextMenuIsOpen()
        return private.contextMenuState;
    end;

    --[[
        Description:
        Destroys an object of a class and its dependencies.
    --]]
    function public:Destruct()
        self:RemoveMouseClickListener();
        self:RemoveContextMenuListener();

        self = nil;
    end;

    --[[
        Description:
        Adds a mouse click listener to control the state of panels.
    --]]
    function public:AddMouseClickListener()
        hook.Add( "GUIMouseReleased", private.eventName, function( mouseCode, aimVector )
            private.mainPanel:MakePopup();
            public:PanelAllState( false, true );
        end );
    end;


    --[[
        Description:
        Removes a mouse click listener.
    --]]
    function public:RemoveMouseClickListener()
        hook.Remove( "GUIMouseReleased", private.eventName );
    end;

    --[[
        Description:
        Adds a context menu listener to control the state of panels.
    --]]
    function public:AddContextMenuListener()
        hook.Add( "OnContextMenuOpen", private.eventName, function()
            public:PanelAllState( false, true );
            private.contextMenuState = true;
        end );
    
        hook.Add( "OnContextMenuClose", private.eventName, function()
            public:PanelAllState( false, false );
            private.contextMenuState = false;
        end );
    end;

    --[[
        Description:
        Deletes the context menu listener.
    --]]
    function public:RemoveContextMenuListener()
        hook.Remove( "OnContextMenuOpen", private.eventName );
        hook.Remove( "OnContextMenuClose", private.eventName );
    end;

    setmetatable( public, self );
    self.__index = self;
    
    return public;
end;