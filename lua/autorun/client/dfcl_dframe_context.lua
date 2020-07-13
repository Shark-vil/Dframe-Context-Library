local PANEL = {};
local PanelManager;

function PANEL:Init()

    PanelManager = DFCL:New( self:GetName() );

    PanelManager:AddMouseClickListener();
    PanelManager:AddContextMenuListener();

    PanelManager:AddPanel( self, true );

    timer.Simple( 0.1, function()

        local panels = self:GetChildren();

        for _, panel in pairs( panels ) do
            PanelManager:AddPanel( panel );
        end;

    end );

end;

function PANEL:GetPanelManager()
    return PanelManager;
end;

function PANEL:Destruct()
    PanelManager:Destruct();
end;

function PANEL:OnClose()
    PanelManager:Destruct();
end;

function PANEL:OnRemove()
    PanelManager:Destruct();
end;

vgui.Register( "DFrameContext", PANEL, "DFrame" )