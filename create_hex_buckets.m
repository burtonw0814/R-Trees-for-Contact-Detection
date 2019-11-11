function [bucket_metadata, femcart_buckets, tibcart_m_buckets, tibcart_l_buckets]=create_hex_buckets(nf, ef, ntl, etl, ntm, etm, num_bux)


% Create bounds for buckets
all_nodes=[nf; ntl; ntm];
xmin=min(all_nodes(:,1))-1;
xmax=max(all_nodes(:,1))+1;
ymin=min(all_nodes(:,2))-1;
ymax=max(all_nodes(:,2))+1;
zmin=min(all_nodes(:,3))-1;
zmax=max(all_nodes(:,3))+1;

x_bounds=linspace(xmin,xmax,num_bux+1);
y_bounds=linspace(ymin,ymax,num_bux+1);

% Generate centroids associated with each element
cf=[]; ctl=[]; ctm=[];
for kk=1:length(ef(:,1))
   cf(kk,:)=mean(nf(ef(kk,:),:)); 
end
for kk=1:length(etl(:,1))
   ctl(kk,:)=mean(ntl(etl(kk,:),:)); 
end
for kk=1:length(etm(:,1))
   ctm(kk,:)=mean(ntm(etm(kk,:),:)); 
end

% Create metadata  matrix. Just stores bounds of each bucket.
bucket_metadata=[];
for kk=2:length(y_bounds)
    for jj= 2:length(x_bounds)
        bucket_metadata{kk-1,jj-1}=[x_bounds(jj-1) x_bounds(jj) y_bounds(kk-1) y_bounds(kk)];
    end
end


% Create buckets. Array of cells where each cell is a bucket that stores
% its elements
femcart_buckets=cell(num_bux,num_bux);
tibcart_m_buckets=cell(num_bux,num_bux);
tibcart_l_buckets=cell(num_bux,num_bux);


% Generate buckets by iterating through each element
for kk=1:length(cf(:,1))
   ctx=1;
   cty=1;
   while cf(kk,1)>x_bounds(ctx) % Iterate through x borders
       ctx=ctx+1;
   end
   while cf(kk,2)>y_bounds(cty) % Iterate through y borders
       cty=cty+1;
   end
   ctx=ctx-1;
   cty=cty-1;
   
   femcart_buckets{cty, ctx}=[femcart_buckets{cty,ctx}; ef(kk,:)];
end


% Generate buckets for medial tibcart
for kk=1:length(ctm(:,1))
   ctx=1;
   cty=1;
   while ctm(kk,1)>x_bounds(ctx) % Iterate through x borders
       ctx=ctx+1;
   end
   while ctm(kk,2)>y_bounds(cty) % Iterate through y borders
       cty=cty+1;
   end
   ctx=ctx-1;
   cty=cty-1;
   
   tibcart_m_buckets{cty, ctx}=[tibcart_m_buckets{cty,ctx}; etm(kk,:)];
end


% Generate buckets for lateral tibcart
for kk=1:length(ctl(:,1))
   ctx=1;
   cty=1;
   while ctl(kk,1)>x_bounds(ctx) % Iterate through x borders
       ctx=ctx+1;
   end
   while ctl(kk,2)>y_bounds(cty) % Iterate through y borders
       cty=cty+1;
   end
   ctx=ctx-1;
   cty=cty-1;
   
   tibcart_l_buckets{cty, ctx}=[tibcart_l_buckets{cty,ctx}; etl(kk,:)];
end

end


