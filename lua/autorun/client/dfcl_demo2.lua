concommand.Add("enter_the_locker_room_2", function()
    local InfoPanel = vgui.Create( "DFrameContext" )
    InfoPanel:ChildSync()   -- Sync children panel (only if they are added dynamically)
    InfoPanel:MakePopup()   -- This method must be called ALWAYS at the TOP
    InfoPanel:SetSize( 160, 250 )
    InfoPanel:SetPos( ScrW()/2 - 400, ScrH()/2 - 150 )
    InfoPanel:SetTitle( "Vote" )
    InfoPanel:SetSizable( false )
    InfoPanel:SetDraggable( true )
    InfoPanel:ShowCloseButton( false )
    InfoPanel:SetKeyboardInputEnabled( false )  -- Manually disable keyboard focus
    InfoPanel:SetMouseInputEnabled( false )     -- Manually disable mouse focus
    InfoPanel:SetVisible( true )
    InfoPanel.Paint = function( self, width, height )
        draw.RoundedBox( 0, 0, 0, width, height, Color(33,29,46,255) )
        surface.SetFont( "Default" )
        surface.SetTextColor( 255, 255, 255, 255 )
        surface.SetTextPos( 5, 25 )
        surface.DrawText( "You are invited" )
        surface.SetTextPos( 5, 40 )
        surface.DrawText( "to join: " )
        surface.SetTextColor( 46, 163, 23, 255 )
        surface.SetTextPos( 5, 55 )
        surface.DrawText( "GAY CLUB" )
    end

    local PanelManager = InfoPanel:GetPanelManager();

    local InfoTextPrint = vgui.Create( "DTextEntry" )
    InfoTextPrint:SetParent( InfoPanel )
    InfoTextPrint:SetPos( 15, 90 )
    InfoTextPrint:SetSize( 130, 25 )
    InfoTextPrint:SetValue( "Oh shit, I'm sorry." )
    InfoTextPrint.OnEnter = function( self )
        chat.AddText( self:GetValue() )
    end
    InfoTextPrint.OnMousePressed = function( self, keyCode )
        PanelManager:AddIgnorePanel( self )             -- Adding a panel to the ignore list
        PanelManager:PanelState( self, true, true )     -- Panel state setting
        PanelManager:MakePopup()                        -- Updating the state of all panels
        PanelManager:RemoveIgnorePanel( self )          -- Removing a panel from an ignore list
    end
   
    local InfoButtonYes = vgui.Create( "DButton" )
    InfoButtonYes:SetParent( InfoPanel )
    InfoButtonYes:SetText( "Join" )
    InfoButtonYes:SetPos( 15, 150 )
    InfoButtonYes:SetSize( 130, 30 )
    InfoButtonYes.DoClick = function ()
        chat.AddText( "WELCOME TO THE CLUB, BUDDY!" )
        InfoPanel:Close()
    end
   
    local InfoButtonNo = vgui.Create( "DButton" )
    InfoButtonNo:SetParent( InfoPanel )
    InfoButtonNo:SetText( "To leave" )
    InfoButtonNo:SetPos( 15, 200 )
    InfoButtonNo:SetSize( 130, 30 )
    InfoButtonNo.DoClick = function ()
        InfoPanel:Close()
    end
end)