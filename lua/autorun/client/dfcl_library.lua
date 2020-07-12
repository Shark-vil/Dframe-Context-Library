DFCL = {};

function DFCL:Create()
    local Class = {};
    setmetatable( Class, { __index = self } );
    return Class:Construct();
end;

function DFCL:New( ui_name )

    local private = {};
    private.mainPanel = {};
    private.panels = {};
    private.ignorePanels = {};
    private.eventName = ui_name .. "_" .. tostring( SysTime() );
    private.contextMenuState = false;

    local public = {};

    function public:GetMainPanel()
        return private.mainPanel;
    end;

    function public:MakePopup()
        private.mainPanel:MakePopup();
    end;

    function public:AddPanel( panel, isMainPanel )
        if ( isMainPanel ~= nil and isMainPanel ) then
            private.mainPanel = panel;
        end;

        table.insert( private.panels, panel );
    end;

    function public:RemovePanel( panel )
        for i = 1, table.Count( private.panels ) do
            if ( private.panels[ i ] == panel ) then
                table.remove( private.panels, i );
                break;
            end;
        end;
    end;

    function public:AddIgnorePanel( panel )
        table.insert( private.ignorePanels, panel );
    end;

    function public:IsIgnorePanel( panel )
        if ( table.HasValue( private.ignorePanels, panel ) ) then
            return true;
        end;
        return false;
    end;

    function public:RemoveIgnorePanel( panel )
        for i = 1, table.Count( private.panels ) do
            if ( private.panels[ i ] == panel ) then
                table.remove( private.panels, i );
                break;
            end;
        end;
    end;

    function public:GetEventName()
        return private.eventName;
    end;

    function public:GetPanels()
        return private.panels;
    end;

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

    function public:ContextMenuIsOpen()
        return private.contextMenuState;
    end;

    function public:Destruct()
        self:RemoveMouseClickListener();
        self:RemoveContextMenuListener();

        self = nil;
    end;

    function public:AddMouseClickListener()
        hook.Add( "GUIMouseReleased", private.eventName, function( mouseCode, aimVector )
            private.mainPanel:MakePopup();
            public:PanelAllState( false, true );
        end );
    end;

    function public:RemoveMouseClickListener()
        hook.Remove( "GUIMouseReleased", private.eventName );
    end;

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

    function public:RemoveContextMenuListener()
        hook.Remove( "OnContextMenuOpen", private.eventName );
        hook.Remove( "OnContextMenuClose", private.eventName );
    end;

    setmetatable( public, self );
    self.__index = self;
    
    return public;
end;