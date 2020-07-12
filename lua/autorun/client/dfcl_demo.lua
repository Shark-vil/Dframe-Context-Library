concommand.Add("golosovaniye", function()
    local RegisterUI = {}
    local ContextMenuIsOpen = false
    local HookEventName = "InfoPanel_" .. tostring( SysTime() );

    local function PanelsState( keyboard_state, mouse_state, selectPanel, isIgnore )
        if ( selectPanel == nil ) then
            for _, panel in pairs( RegisterUI ) do
                if ( isIgnore ~= nil and isIgnore == true ) then
                    if ( ispanel( selectPanel ) ) then
                        if ( selectPanel == panel ) then
                            continue
                        end
                    elseif ( istable( selectPanel ) ) then
                        if ( table.HasValue( selectPanel, panel ) ) then
                            continue
                        end;
                    end
                end
                panel:SetKeyboardInputEnabled( keyboard_state )
                panel:SetMouseInputEnabled( mouse_state )
            end;
        else
            if ( ispanel( selectPanel ) ) then
                selectPanel:SetKeyboardInputEnabled( keyboard_state )
                selectPanel:SetMouseInputEnabled( mouse_state )
            elseif ( istable( selectPanel ) ) then
                for _, panel in pairs( selectPanel ) do
                    panel:SetKeyboardInputEnabled( keyboard_state )
                    panel:SetMouseInputEnabled( mouse_state )
                end
            end
        end
    end

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
        hook.Remove( "GUIMouseReleased", HookEventName )
        hook.Remove( "OnContextMenuOpen", HookEventName )
        hook.Remove( "OnContextMenuClose", HookEventName )
    end
    table.insert( RegisterUI, InfoPanel )

    local InfoTextPrint = vgui.Create( "DTextEntry" )
    InfoTextPrint:SetParent( InfoPanel )
    InfoTextPrint:SetPos( 15, 90 )
    InfoTextPrint:SetSize( 130, 25 )
    InfoTextPrint:SetValue( "Placeholder Text" )
    InfoTextPrint.OnEnter = function( self )
        chat.AddText( self:GetValue() )
    end
    InfoTextPrint.OnMousePressed = function( self, keyCode )
        PanelsState( true, true );
    end
    table.insert( RegisterUI, InfoTextPrint )
   
    local InfoButtonYes = vgui.Create( "DButton" )
    InfoButtonYes:SetParent( InfoPanel )
    InfoButtonYes:SetText( "Вступить" )
    InfoButtonYes:SetPos( 15, 150 )
    InfoButtonYes:SetSize( 130, 30 )
    InfoButtonYes.DoClick = function ()
        InfoPanel:Close()
    end
    table.insert( RegisterUI, InfoButtonYes )
   
    local InfoButtonNo = vgui.Create( "DButton" )
    InfoButtonNo:SetParent( InfoPanel )
    InfoButtonNo:SetText( "Отклонить" )
    InfoButtonNo:SetPos( 15, 200 )
    InfoButtonNo:SetSize( 130, 30 )
    InfoButtonNo.DoClick = function ()
        InfoPanel:Close()
    end
    table.insert( RegisterUI, InfoButtonNo )

    hook.Add( "GUIMouseReleased", HookEventName, function( mouseCode, aimVector )
        InfoPanel:MakePopup()
        PanelsState( false, true );
    end );
    hook.Add( "OnContextMenuOpen", HookEventName, function()
        PanelsState( false, true );
        ContextMenuIsOpen = true;
    end );
    hook.Add( "OnContextMenuClose", HookEventName, function()
        PanelsState( false, false );
        ContextMenuIsOpen = false;
    end );
end)