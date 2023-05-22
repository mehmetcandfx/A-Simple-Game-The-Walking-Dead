%Mehnetcan Caniklioğlu 2167963
%Mustafa Serkan İyidemir 2095982
classdef Character < handle
    
    properties
        room   % Reference to Room object that character is in
    end %public properties
    
    methods
        function c = Character(startRoom)
            if (nargin == 1)
                c.room = startRoom;
            else
                c.room = Room();
            end    
        end
        
        function r = moveCharacter(self, roomArr, dx, dy)
        % r is the handle to the room after the character's move
            % Mission
            [a,b]=self.room.getLoc;
            self.room=roomArr(a+dx,b+dy);
            r=self.room;             
        end
        
    end % public methods
    
end % class Character