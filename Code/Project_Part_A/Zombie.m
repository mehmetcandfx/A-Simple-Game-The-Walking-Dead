%Mehnetcan Caniklioðlu 2167963
%Mustafa Serkan Ýyidemir 2095982
classdef Zombie < Character    
    methods
        function m = Zombie(startRoom)
            % Mission
            if nargin~=1
            startRoom=Room();            
            end
              m@Character(startRoom);  
        end
        
        function move(self, game)
            % Mission
            [XZ,YZ]=game.getZomLoc;
            [XP,YP]=game.getPlayerLoc;
            [Xe,Ye]=game.exitRoom.getLoc  ;
            A=size(game.roomArr);
            switch sqrt(((XZ-Xe)^2)+((YZ-Ye)^2))>sqrt(((XP-Xe)^2)+((YP-Ye)^2))
                case 0
                 if XP<XZ
                     dx =-1;
                 elseif XP>XZ
                     dx =1;
                 else 
                     dx =0;
                 end
                 if YP<YZ
                     dy =-1;
                 elseif YP>YZ
                     dy =1;
                 else 
                     dy =0;
                 end    
                case 1
                    if (XZ==A) 
                    dx=1;dy=0;
                    elseif (YZ==A)
                     dx=1;dy=0;
                    else
                     dx=1;dy=1;
                    end         
            end
            self.room=self.moveCharacter(game.roomArr, dx, dy);
           
        end
            
        % ---- Do not modify the code below ---- %
        function draw(self)
            DrawRectNoBorder(self.room.xCoord+0.05,self.room.yCoord+0.05,0.3,0.3,[0.9,0,0])
            text(self.room.xCoord+0.16,self.room.yCoord+0.18,'\color[rgb]{1,1,1}Z')
        end
        
        function removeDrawing(self)
           if self.room.exit == 1
               col = ([96,196,106])/255;
           elseif self.room.playerVisited && self.room.hazardID==1
               col= ([174, 18, 0])/255;
           elseif self.room.playerVisited && self.room.hazardID==2
               col= ([232, 162, 49])/255;
           else
               col =([137,208,224])/255;
           end
           DrawRectNoBorder(self.room.xCoord+0.05,self.room.yCoord+0.05,0.3,0.3,col)
        end
        
        
    end % public methods
    
end % class Zombie