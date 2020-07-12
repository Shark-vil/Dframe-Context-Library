concommand.Add("golosovaniye", function()
    local PanelManager = DFCL:New( "InfoPanelTest" );
    PanelManager:AddMouseClickListener();
    PanelManager:AddContextMenuListener();

    local InfoPanel = vgui.Create( "DFrame" )
    InfoPanel:MakePopup()
    InfoPanel:SetSize( 160, 250 )
    InfoPanel:SetPos( ScrW()/2 - 400, ScrH()/2 - 150 )
    InfoPanel:SetTitle( "ГОЛОСОВАНИЕ" )
    InfoPanel:SetSizable( false )
    InfoPanel:SetDraggable( true )
    InfoPanel:ShowCloseButton( true )
    InfoPanel:SetKeyboardInputEnabled( false )
    InfoPanel:SetMouseInputEnabled( false )
    InfoPanel:SetVisible( true )
    InfoPanel.Paint = function( self, width, height )
        draw.RoundedBox( 0, 0, 0, width, height, Color(33,29,46,255) )
        surface.SetFont( "Default" )
        surface.SetTextColor( 255, 255, 255, 255 )
        surface.SetTextPos( 5, 25 )
        surface.DrawText( "Вас приглашают" )
        surface.SetTextPos( 5, 40 )
        surface.DrawText( "Вступить в: " )
        surface.SetTextColor( 46, 163, 23, 255 )
        surface.SetTextPos( 5, 55 )
        surface.DrawText( "GAY CLUB" )
    end
    InfoPanel.OnClose = function()
        PanelManager:Destruct();
    end
    PanelManager:AddPanel( InfoPanel, true );

    local InfoTextPrint = vgui.Create( "DTextEntry" )
    InfoTextPrint:SetParent( InfoPanel )
    InfoTextPrint:SetPos( 15, 90 )
    InfoTextPrint:SetSize( 130, 25 )
    InfoTextPrint:SetValue( "Placeholder Text" )
    InfoTextPrint.OnEnter = function( self )
        chat.AddText( self:GetValue() )
    end
    InfoTextPrint.OnMousePressed = function( self, keyCode )
        PanelManager:AddIgnorePanel( self );
        PanelManager:MakePopup();
        PanelManager:PanelState( self, true, true );
        PanelManager:RemoveIgnorePanel( self );
    end
    PanelManager:AddPanel( InfoTextPrint );
   
    local InfoButtonYes = vgui.Create( "DButton" )
    InfoButtonYes:SetParent( InfoPanel )
    InfoButtonYes:SetText( "Вступить" )
    InfoButtonYes:SetPos( 15, 150 )
    InfoButtonYes:SetSize( 130, 30 )
    InfoButtonYes.DoClick = function ()
        InfoPanel:Close()
    end
    PanelManager:AddPanel( InfoButtonYes );
   
    local InfoButtonNo = vgui.Create( "DButton" )
    InfoButtonNo:SetParent( InfoPanel )
    InfoButtonNo:SetText( "Отклонить" )
    InfoButtonNo:SetPos( 15, 200 )
    InfoButtonNo:SetSize( 130, 30 )
    InfoButtonNo.DoClick = function ()
        InfoPanel:Close()
    end
    PanelManager:AddPanel( InfoButtonNo );
end)