function [ quads ] = Hex2Quads( hex )
%Hex2Quads Transform 8-node hexahedrons into their 6 4-node faces 
%
% B. Rodríguez-Vila and D.M. Pierce 
% Interdisciplinary Mechanics Laboratory, http://im.engr.uconn.edu
% University of Connecticut, Storrs
% June 05, 2017
% Copyright (c) 2017, All Rights Reserved.
%
% CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
% EITHER EXPRESSED OR IMPLIED.

    quads = [hex, ...
        hex(:,1), hex(:,4), hex(:,8), hex(:,5),...
        hex(:,2), hex(:,3), hex(:,7), hex(:,6),...
        hex(:,1), hex(:,2), hex(:,6), hex(:,5),...
        hex(:,4), hex(:,3), hex(:,7), hex(:,8)];

    quads = reshape(quads',4,[])';

end

