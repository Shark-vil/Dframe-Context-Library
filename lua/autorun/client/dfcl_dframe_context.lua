local PANEL = {
    PanelManager = nil
};

function PANEL:Init()

    self.PanelManager = DFCL:New( self:GetName() );

    self.PanelManager:AddMouseClickListener();
    self.PanelManager:AddContextMenuListener();

    self.PanelManager:AddPanel( self, true );

    timer.Simple( 0.3, function()

        local panels = self:GetChildren();

        for _, panel in pairs( panels ) do
            self.PanelManager:AddPanel( panel );
        end;

    end );

end;

function PANEL:ChildSync( sync_time )

    sync_time = sync_time or 1;
    
    local SyncEventName = self.PanelManager:GetEventName() .. "_ChildrenSync";

    timer.Create( SyncEventName, sync_time, 0, function()

        if ( not IsValid( self ) ) then return; end;

        local panels = self:GetChildren();
        local panelsExists = self.PanelManager:GetPanels();
        
        for _, panel in pairs( panels ) do
            if ( not table.HasValue( panelsExists, panel ) ) then
                self.PanelManager:AddPanel( panel );
            end;
        end;

    end );

    hook.Add( "DFCL_Destruct", SyncEventName, function( eventName )

        if ( timer.Exists( SyncEventName ) ) then
            timer.Remove( SyncEventName );
        end;

        hook.Remove( "DFCL_Destruct", SyncEventName );

    end );

end;

function PANEL:GetPanelManager()
    return self.PanelManager;
end;

function PANEL:Destruct()
    self.PanelManager:Destruct();
end;

function PANEL:OnClose()
    self.PanelManager:Destruct();
end;

function PANEL:OnRemove()
    self.PanelManager:Destruct();
end;

vgui.Register( "DFrameContext", PANEL, "DFrame" )