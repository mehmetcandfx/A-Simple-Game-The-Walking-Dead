%Mehnetcan Caniklioğlu 2167963
%Mustafa Serkan İyidemir 2095982
classdef Room < handle
    % A room has an id, rooms to the north, east, south, and west, and an
    % exit property.
    
    properties(Access = private)
        id   % Unique id
    end %private properties
    
    properties
        xCoord
        yCoord
        exit
        hazardID
        playerVisited
    end %public properties
    
    properties (Constant)
        hazardAmount=20;  % Standard deduction of player's health if
        % player enters a trap room.
    end
    
    methods
        function r = Room(xCoord, yCoord, exit, id, hID)
            % Set fields to arguments if only all 5 arguments are given
            % Mission  
            
            if nargin==5
        r.xCoord=xCoord;
        r.yCoord=yCoord;
        r.exit=exit;
        r.id=id;
        r.hazardID=hID;
        r.playerVisited=0;
            else 
        r.xCoord=0;
        r.yCoord=0;
        r. exit=0;
        r.hazardID=0;
        r.playerVisited=0;
        r.id=0; 
            end
     
        end
        function [xCoord,yCoord] = getLoc(self)
            % Return this room's x- and y-coordinates
            % Mission
            xCoord=self.xCoord;
            yCoord=self.yCoord;

        end
        
        function id = getID(self)
            % Return this room's ID
            % Mission
             id=self.id;
        end
        
        function bool = isHazardous(self)
            % Return 0 if this room is not hazardous and 1 if it is.
            % Mission
            bool=self.hazardID;
        end
        
        function applyHazard(self, player)
            % Damage the player's health according to the hazard of this room.
            % Mission
            switch self.hazardID
                case 0 
                case 1
                   player.decreaseHealth(self.hazardAmount); 
                case 2
                    player.poison;
            end
            end
   
        
        % ---- Do not modify the code below ---- %
        function draw(self)
            if self.xCoord == 1 && self.yCoord == 1
                str = sprintf('Room %d\nSTART',self.id);
            else
                str = sprintf('Room %d',self.id);
            end
            if self.exit == 1
                col = ([96,196,106])/255;
                str = sprintf('Room %d\nEXIT',self.id);
            elseif self.playerVisited == 1 && self.hazardID==1
                col= ([174, 18, 0])/255;
            elseif self.playerVisited == 1 && self.hazardID==2
                col= ([232, 162, 49])/255;
            else
                col = ([137,208,224])/255;
            end
            DrawRect(self.xCoord,self.yCoord,1,1,col)
            text(self.xCoord+0.1,self.yCoord+0.8,str)
        end
        
    end % public methods
    
end % class Room
