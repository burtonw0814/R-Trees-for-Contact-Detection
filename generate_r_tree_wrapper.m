function rtree = generate_r_tree_wrapper(n,e)   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Each row has format [xmin xmax ymin ymax zmin zmax split_dim idx-to-left idx-right]
% idx-to-left and idx-right are 0 if we have reached a leaf
% If split dim = 1, split at xy plane for next level
% If split dim = 2, split at yz plane for next level
% If split dim = 3, split at yz plane for next level
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  n=nf_o;
%  e=ef;

ct=1;

% Generate centroids associated with each element
c=[]; 
for kk=1:length(e(:,1))
   c(kk,:)=mean(n(e(kk,:),:)); 
end

xmin=min(n(:,1));
xmax=max(n(:,1));
ymin=min(n(:,2));
ymax=max(n(:,2));
zmin=min(n(:,3));
zmax=max(n(:,3));

split_dim=1;
rtree=[];

% Allocate root
rtree{ct,1}=xmin;
rtree{ct,2}=xmax;
rtree{ct,3}=ymin;
rtree{ct,4}=ymax;
rtree{ct,5}=zmin;
rtree{ct,6}=zmax;
rtree{ct,7}=split_dim;

% Split dim is always 1 for root node
med=median(c(:,3)); % median z-value

% Get left/right elems
e_left=e(c(:,3)<=med,:);
e_right=e(c(:,3)>med,:);

% Get left/right nodes
n_left=n(unique(reshape(e_left,size(e_left,1),[])),:);
n_right=n(unique(reshape(e_right,size(e_right,1),[])),:);
% 
% xmin=min(n_left(:,1))
% xmax=max(n_left(:,1))
% ymin=min(n_left(:,2))
% ymax=max(n_left(:,2))
% zmin=min(n_left(:,3))
% zmax=max(n_left(:,3))
% 
% xmin=min(n_right(:,1))
% xmax=max(n_right(:,1))
% ymin=min(n_right(:,2))
% ymax=max(n_right(:,2))
% zmin=min(n_right(:,3))
% zmax=max(n_right(:,3))


% Recursively build out the sub trees
[rtree, idx_left]=get_r_tree(rtree, n, n_left, e_left, mod(split_dim,3)+1);
[rtree, idx_right]=get_r_tree(rtree, n, n_right, e_right, mod(split_dim,3)+1);

rtree{1,8}=idx_left; 
rtree{1,9}=idx_right; 

end

















