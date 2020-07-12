DFCL = {};

function DFCL:Create( parent )
    setmetatable( self, { __index = parent } );
end;

function DFCL:New( panel )

    local object = {};
    object.panels = {};

    function object:AddPanel( panel )
        table.insert( self.panels, panel );
    end;

    function object:GetPanels()
        return self.panels;
    end;

    setmetatable( object, self );
    self.__index = self;
    
    return object;
end;