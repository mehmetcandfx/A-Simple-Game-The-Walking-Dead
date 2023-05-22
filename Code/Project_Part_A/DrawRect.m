%Mehnetcan Caniklioðlu 2167963
%Mustafa Serkan Ýyidemir 2095982
function DrawRect(a,b,L,W,c)
% Adds a rectangle to the current window. Assumes hold is on.
% The rectangle has vertices (a,b), (a+L,b), (a+L,b+W),
% and (a,b+W) and color c where c is either an rgb vector
% or one of the built-in colors 'r', 'g', 'y', 'b', 'w',
% 'k', 'c', or 'm'.

x = [a a+L a+L a  ];
y = [b b   b+W b+W];
fill(x,y,c)
