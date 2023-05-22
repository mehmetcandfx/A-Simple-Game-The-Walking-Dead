%Mehnetcan Caniklioðlu 2167963
%Mustafa Serkan Ýyidemir 2095982
classdef Player < Character
    properties(Access = private)
        health       % number of health points that the player has
    end %private properties
    
    properties
        poisoned     % 0 if player is not poisoned; 1 if player is poisoned
        poisonHit    % #health points lost per move if player is poisoned
        poisonEscape % probability that player will be unpoisoned
    end %public properties
    
    methods
        function p = Player(startRoom, startHealth, poisonHit, poisonEscape)
            % Mission
            p@Character(startRoom);
            p.poisoned=0;
            if nargin<4    
            p.poisonHit=0    ;   
            p.poisonEscape=.5;   
            else    
            p.poisonHit=poisonHit    ;   
            p.poisonEscape=poisonEscape;  
            end
            p.health=startHealth;
            
            
        end
        
        function health = getHealth(self)
            % Mission
            health=self.health;
        end
        
        function decreaseHealth(self, damage)
            % Mission
            self.health=self.getHealth-damage;
      
        end
        
        function status = checkPoison(self)
            % Mission
            if self.poisoned==1
                status=1;
            else
                status=0;
            end
        end
        
        function poison(self)
            % Mission
            self.poisoned=1;
        end
        
        function r = move(self, roomArr, dx, dy)
            % Update the player's position and return the handle of the room
            % that the player has moved to.
            % Mission
            
            switch self.checkPoison
                case 0
                case 1
                if self.poisonEscape>=rand
                  self.poisoned=0; 
                else
                  self.decreaseHealth(self.poisonHit);    
                end
            end
            self.room=self.moveCharacter(roomArr, dx, dy);
            r=self.room;
            r.applyHazard(self)
            
           
        end
        
        % ---- Do not modify the code below ---- %
        function draw(self)
            DrawRectNoBorder(self.room.xCoord+0.05, ...
                self.room.yCoord+0.05, ...
                0.3,0.3,([168,78,3])/255)
            text(self.room.xCoord+0.16,self.room.yCoord+0.18, ...
                '\color[rgb]{1,1,1}P')
        end
        
        function removeDrawing(self)
            if self.room.exit == 1
                col = ([96,196,106])/255;
            elseif self.room.playerVisited == 1 && self.room.hazardID==1
                col= ([174, 18, 0])/255;
            elseif self.room.playerVisited == 1 && self.room.hazardID==2
                col= ([232, 162, 49])/255;
            else
                col =([137,208,224])/255;
            end
            DrawRectNoBorder(self.room.xCoord+0.05, ...
                self.room.yCoord+0.05, ...
                0.3,0.3,col)
        end
    end % public methods
    
end % class Player