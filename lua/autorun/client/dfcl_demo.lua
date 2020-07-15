concommand.Add("enter_the_locker_room", function()
    local PanelManager = DFCL:New( "InfoPanelTest" )    -- Creating a Class Object
    PanelManager:AddMouseClickListener()    -- Mouse listener activation
    PanelManager:AddContextMenuListener()   -- Context menu listener activation

    -- Maintains focus on the panel after closing the context menu (If there was focus before).
    PanelManager:AddFocusName( "DTextEntry" );

    local InfoPanel = vgui.Create( "DFrame" )
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
    InfoPanel.OnClose = function()
        PanelManager:Destruct() -- Removing a class object after closing the panel
    end
    -- Adding a panel to the list. The second parameter means - the main panel
    PanelManager:AddPanel( InfoPanel, true )

    local InfoTextPrint = vgui.Create( "DTextEntry" )
    InfoTextPrint:SetParent( InfoPanel )
    InfoTextPrint:SetPos( 15, 90 )
    InfoTextPrint:SetSize( 130, 25 )
    InfoTextPrint:SetValue( "Oh shit, I'm sorry." )
    InfoTextPrint.OnEnter = function( self )
        chat.AddText( self:GetValue() )
        
        -- Reset panel states so that the mouse and keyboard are not locked.
        PanelManager:PanelStateReset()
    end
    InfoTextPrint.OnMousePressed = function( self, keyCode )
        PanelManager:SetFocusPanel( self )  -- Set focus to the panel when pressed
    end
    PanelManager:AddPanel( InfoTextPrint )  -- Adding a panel to the list
   
    local InfoButtonYes = vgui.Create( "DButton" )
    InfoButtonYes:SetParent( InfoPanel )
    InfoButtonYes:SetText( "Join" )
    InfoButtonYes:SetPos( 15, 150 )
    InfoButtonYes:SetSize( 130, 30 )
    InfoButtonYes.DoClick = function ()
        chat.AddText( "WELCOME TO THE CLUB, BUDDY!" )
        InfoPanel:Close()
    end
    PanelManager:AddPanel( InfoButtonYes )  -- Adding a panel to the list
   
    local InfoButtonNo = vgui.Create( "DButton" )
    InfoButtonNo:SetParent( InfoPanel )
    InfoButtonNo:SetText( "To leave" )
    InfoButtonNo:SetPos( 15, 200 )
    InfoButtonNo:SetSize( 130, 30 )
    InfoButtonNo.DoClick = function ()
        InfoPanel:Close()
    end
    PanelManager:AddPanel( InfoButtonNo )   -- Adding a panel to the list
end)