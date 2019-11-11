function e=hex_from_bounds(bounds_vec)


% Given a vector of numbers in the format [xmin xmax ymin ymax zmin zmax]
% This function computes the nodes of the corners of a hex element that
% adheres to these bounds


xmin=bounds_vec(1);
xmax=bounds_vec(2);
ymin=bounds_vec(3);
ymax=bounds_vec(4);
zmin=bounds_vec(5);
zmax=bounds_vec(6);


e=[xmin, ymin, zmin; ...
    xmin, ymin, zmax; ...
    xmin, ymax, zmin; ...
    xmin, ymax, zmax; ...
    xmax, ymin, zmin; ...
    xmax, ymin, zmax; ...
    xmax, ymax, zmin ; ...
    xmax, ymax, zmax; ...
    ];

end