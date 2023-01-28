function distance = distanceToDiagonal(x, y, scale)
narginchk(2,3);
if nargin <3
    scale = "linear";
end

if strcmpi(scale, "log10")
    point1 = [x, y];
    point2 = [y, x];
    distance = pdist2(point1, point2, 'euclidean')/2;
end
