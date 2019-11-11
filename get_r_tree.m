function [rtree, idx_out] = get_r_tree(rtree, n_tot, n, e, split_dim)   

% Create new line at first available spot
ct=size(rtree,1)+1;

% Generate centroids associated with each element
c=[]; 
for kk=1:size(e,1)
    c(kk,:)=mean(n_tot(e(kk,:),:)); 
end

% Get bounds of nodes
xmin=min(n(:,1));
xmax=max(n(:,1));
ymin=min(n(:,2));
ymax=max(n(:,2));
zmin=min(n(:,3));
zmax=max(n(:,3));

% Allocate 
rtree{ct,1}=xmin;
rtree{ct,2}=xmax;
rtree{ct,3}=ymin;
rtree{ct,4}=ymax;
rtree{ct,5}=zmin;
rtree{ct,6}=zmax;
rtree{ct,7}=split_dim;

% Split into left and right branches
if split_dim==1 % split at xy plane (z-dim)
    med=median(c(:,3)); % median z-value
    e_left=e(c(:,3)<=med,:);
    e_right=e(c(:,3)>med,:);
end

if split_dim==2 % split at yz plane (x-dim)
    med=median(c(:,1)); % median x-value
    e_left=e(c(:,1)<=med,:);
    e_right=e(c(:,1)>med,:);
end

if split_dim==3 % split at xz plane (y-dim)
    med=median(c(:,2)); % median y-value
    e_left=e(c(:,2)<=med,:);
    e_right=e(c(:,2)>med,:);
end

% Get left/right nodes
n_left=n_tot(unique(reshape(e_left,size(e_left,1),[])),:);
n_right=n_tot(unique(reshape(e_right,size(e_right,1),[])),:);

% Either get leaf or keep going!
if size(e_left,1)==1 % We have reached a leaf on the left side
    size_rt=size(rtree,1);
    idx_left=size_rt+1;
    rtree{idx_left,1}=e_left;
    rtree{idx_left,2}=0; rtree{idx_left,3}=0;  rtree{idx_left,4}=0;
    rtree{idx_left,5}=0;  rtree{idx_left,6}=0;  rtree{idx_left,7}=0;
    rtree{idx_left,8}=0;  rtree{idx_left,9}=0;
else % Continue to buld out the subtree on left side
    [rtree, idx_left]=get_r_tree(rtree, n_tot, n_left, e_left, mod(split_dim,3)+1);
end


if size(e_right,1)==1 % We have reached a leaf on the right side 
    size_rt=size(rtree,1);
    idx_right=size_rt+1;
    rtree{idx_right,1}=e_right;
    rtree{idx_right,2}=0; rtree{idx_right,3}=0;  rtree{idx_right,4}=0;
    rtree{idx_right,5}=0;  rtree{idx_right,6}=0;  rtree{idx_right,7}=0;
    rtree{idx_right,8}=0;  rtree{idx_right,9}=0;
else % Continue to buld out the subtree on right side
    [rtree, idx_right]=get_r_tree(rtree, n_tot, n_right, e_right, mod(split_dim,3)+1);
end
    
rtree{ct,8}= idx_left; %idx to left, we dont know it yet
rtree{ct,9}= idx_right; %idx to right, we dont know it yet
idx_out=ct;

end






