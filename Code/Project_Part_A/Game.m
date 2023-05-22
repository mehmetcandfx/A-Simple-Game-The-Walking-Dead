%Mehnetcan Caniklioðlu 2167963
%Mustafa Serkan Ýyidemir 2095982
classdef Game < handle
    
    % ---- Only modify the Mission part in this class ---- %
    
    properties
        roomArr         % Square matrix of Room objects
        player          % Reference to a Player object
        zombie          % Reference to a Zombie object
        exitRoom        % Reference to Room object
        numRooms        % Number of rooms (must be square)
        currentState    % 0: playing, 1: player died, 2:catch by zombie,
                        % 3: win
    end %public properties
    
    methods
        
        function g = Game(numRooms, hazardChance)
            % Game constructor. hazardChance is the probability that a
            % room will be hazardous.
            if (nargin <= 1)
                hazardChance=0;
            end
            
            if (nargin > 1)
                g.numRooms=numRooms;
                gridLength = floor(sqrt(numRooms));
                g.roomArr=Room();
               i = 0;
                for x = 1:gridLength
                    for y = 1:gridLength
                        i = i+1;
                        hazard=0;
                        if rand<hazardChance
                            hazard=round(rand)+1;
                        end
                        g.roomArr(x,y) = Room(x,y,0,i,hazard);
                    end
                end
                % The player always starts at the bottom-left room
                g.player = Player(g.roomArr(1,1),...
                    100,Room.hazardAmount/2,.5);
                
                % The exit room is always the top-right room.
                g.exitRoom=g.roomArr(gridLength, gridLength);
                g.exitRoom.exit=1;
                
                % The exit room and player's start room cannot be hazardous
                g.exitRoom.hazardID=0;
                g.roomArr(1,1).hazardID=0;
                g.roomArr(1,1).playerVisited = 1;
                % The zombie always begins at the exit room
                g.zombie = Zombie(g.exitRoom);
                g.currentState = 0;
            end
        end
        
        function [x,y]= getZomLoc(self)
            % Mission
             x=self.zombie.room.xCoord;
             y=self.zombie.room.yCoord;
        end
        
        function [x,y]= getPlayerLoc(self)
            % Mission
            x=self.player.room.xCoord;
             y=self.player.room.yCoord;
        end
        
        function dist = getZomDist(self)
            % Mission
            [A, B]=self.getPlayerLoc;
            [a, b]=self.getZomLoc;
            dist=sqrt(((A-a)^2)+((B-b)^2));
        end
        
        function figHandle=draw(self, figHandle)
            % Draws the initial game setup
            if isempty(figHandle)
                figHandle = figure('Color',([73 124 135])/255,'Position', ...
                    [100,100,100*sqrt(self.numRooms), ...
                    100*sqrt(self.numRooms)+15]);
            end
            hold on
            axis([1 sqrt(self.numRooms)+1.5 1 sqrt(self.numRooms)+1.5])
            axis off
            list=listfonts;
            if sum(ismember(list,{'Chiller'}))==1
                font='Chiller';
            else
                font='Arial';
            end
            text(1,sqrt(self.numRooms)+1.2,...
                '\color[rgb]{0.67,0.10,0.10}\fontsize{16}\bf The Walking Dead - Hospital',...
                'FontName',font)
            for i=1:sqrt(self.numRooms)
                for j=1:sqrt(self.numRooms)
                    self.roomArr(i,j).draw();
                end
            end
            
            % ---- Mission: draw the player and zombie --------------------
          self.player.draw;
          self.zombie.draw;    
        end
        
        function [wasPoisoned, fid] = updateGraphics(self, wasPoisoned, fid)
            % Get new position for player and redraw it
            playerStep = 1;  % how many steps player has taken in this turn
            while(playerStep<=2 && self.currentState==0)
                [newX,newY] = ginput(1);
                newX = floor(newX);
                newY = floor(newY);
                oldX = self.player.room.xCoord;
                oldY = self.player.room.yCoord;
                gridLength= length(self.roomArr);
                dx = 0;
                dy = 0;
                if newX>=1 && newX<=gridLength && ...
                        newY>=1 && newY<=gridLength
                    if (newX > oldX && newY == oldY)       % move east
                        dx = 1;
                    elseif (newX > oldX && newY > oldY)    % move northeast
                        dx = 1;
                        dy = 1;
                    elseif (newX > oldX && newY < oldY)    % move southeast
                        dx = 1;
                        dy = -1;
                    elseif (newX < oldX && newY == oldY)   % move west
                        dx = -1;
                    elseif (newX < oldX && newY > oldY)    % move northwest
                        dx = -1;
                        dy = 1;
                    elseif (newX < oldX && newY < oldY)    % move southwest
                        dx = -1;
                        dy = -1;
                    elseif (newX == oldX && newY > oldY)   % move north
                        dy = 1;
                    elseif (newX == oldX && newY < oldY)   % move south
                        dy = -1;
                    end
                end
                % ---- Mission: update the player position----------------
                removeDrawing(self.player);
                [corX, corY]=self.getPlayerLoc;
                self.roomArr(corX+dx,corY+dy).playerVisited=1;
                self.player.move( self.roomArr, dx, dy);  
                self.player.room.draw;
                self.player.draw;

                % ---- Mission: update the title  -------------------
                out=sprintf('Zombie is %.2f spaces away!\n', ...
                    self.getZomDist);
                out=[out sprintf('You have %.0f health points\n', ...
                    self.player.getHealth)];
                if self.player.room.hazardID==1
                    out=[out sprintf(...
                        'You were hit by a trap! (-%d health points)\n', ...
                        self.player.room.hazardAmount)];
                end
                if self.player.checkPoison
                    out=[out sprintf(...
                        'You are poisoned! (-%d health points per move)', ...
                        self.player.poisonHit )];
                    wasPoisoned=1;
                end
                if ~self.player.checkPoison && wasPoisoned
                    out=[out sprintf('You recovered from poison!')];
                    wasPoisoned=0;
                end
                list=listfonts;
                if sum(ismember(list,{'Chiller'}))==1
                    font='Chiller';
                else
                    font='Arial';
                end
                title(out,'Color','white','FontSize',16,'FontName',font);
                
                if self.player.room.hazardID > 0
                    sprintf('Room #%d is hazardous!', ...
                        self.player.room.getID );
                end
                
                % ---- Mission: update the currentState ------------------
                if self.player.getHealth==0
                self.currentState=1;
                elseif self.player.room.getID==self.zombie.room.getID
                    self.currentState=2;
                elseif self.player.room.getID==self.exitRoom.getID
                    self.currentState=3;
                end

               
                playerStep = playerStep+1;
                 
            end
            
            if self.currentState ~=0
                return
            else
                % ---- Mission: update zombie position and currentState -----
            self.zombie.removeDrawing;
            self.zombie.move(self);
            self.zombie.draw;    
            end 
        
               if self.player.getHealth==0
                self.currentState=1;
                elseif self.player.room.getID==self.zombie.room.getID
                    self.currentState=2;
                 elseif self.player.room.getID==self.exitRoom.getID
                    self.currentState=3;
                end
        end
        function run(self)
            % Run the game
            wP=0;
            fID=[];
            fID=self.draw(fID);
            
            while(self.currentState == 0)
                [wP, fID]=self.updateGraphics(wP, fID);
            end
            
            if self.currentState == 3
                title('You reached the exit! You are still a human!', ...
                    'Color','white','FontSize',16);
            elseif self.currentState == 2
                title('OH NO! Zombies bit you! Now you are a zombie too...', ...
                    'Color','white','FontSize',16);
            elseif self.currentState == 1
                title('Game Over! You losed all your health. You will be a zombie!', ...
                    'Color','white','FontSize',16);
            end
           
        end
        
    end % public methods
    
end % class Game