%% William Burton
%% University of Denver
%% November 2019

clear all
close all
clc

%% Import gometries
path_main='C:\Users\Azhar\Desktop\CG\';
path_femcart='Femcart_HEX.inp';
path_tibcart_med='Tibcart_Lateral_HEX.inp';
path_tibcart_lat='Tibcart_Medial_HEX.inp';

[nf_o, ef, nodes, elems] = import_hex_mesh([path_main path_femcart]);
[ntm, etm, nodes, elems] = import_hex_mesh([path_main path_tibcart_med]);
[ntl, etl, nodes, elems] = import_hex_mesh([path_main path_tibcart_lat]);


%% Initialize geometries

% Intialize goemetries by translating femoral cartilage 10 mm superiorly
nf_o(:,3)=nf_o(:,3)+4;

figure
patch_ver =patch('vertices',nf_o,'faces',Hex2Quads(ef)); axis equal, view(3), lighting gouraud
set(patch_ver,'FaceColor',[1 0 0],'FaceLighting','phong','EdgeColor','r','FaceAlpha',0.1,'EdgeAlpha',0.4); hold on

patch_ver =patch('vertices',ntm,'faces',Hex2Quads(etm)); axis equal, view(3), lighting gouraud
set(patch_ver,'FaceColor',[0 1 0],'FaceLighting','phong','EdgeColor','g','FaceAlpha',0.1,'EdgeAlpha',0.4); hold on

patch_ver =patch('vertices',ntl,'faces',Hex2Quads(etl)); axis equal, view(3), lighting gouraud
set(patch_ver,'FaceColor',[0 0 1],'FaceLighting','phong','EdgeColor','b','FaceAlpha',0.1,'EdgeAlpha',0.4); hold on

title('Linear Hex Meshes of Cartilage Geometries at the Tibiofemoral Joint')

xlabel('X -- Med(+)/Lat(-)')
ylabel('Y -- Pos(+)/Ant(-)')
zlabel('Z -- Sup(+)/Inf(-)')


%% Define geometry displacement
d=0.25*ones(25,1);

%% Brute force method -- Check for intersection between all pairs of femoral and tibial cartilage elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialize things to store at each iteration
t_brute=[];
num_contact_brute=zeros(length(d),1);
contact_elems_brute=cell(length(d),1);
nf=nf_o;

for i=1:length(d) % All time steps
    

    for j=1:length(ef(:,1)) % All femoral cartilage elements
        tic
        disp(j)
        for k=1:length(etl(:,1)) % All lateral tibial cartilage elements
            c=check_hex_contact(nf(ef(j,:),:), ntl(etl(k,:),:));
            if c==1
                num_contact(i)=num_contact(i)+1;
                contact_elems{i}=[contact_elems{i}; nf(ef(j,:))];
            else
            end
        end
        for k=1:length(etm(:,1)) % All medial tibial cartilage elements
            c=check_hex_contact(nf(ef(j,:),:), ntm(etm(k,:),:)); 
            if c==1
                num_contact(i)=num_contact(i)+1;
                contact_elems{i}=[contact_elems{i}; nf(ef(j,:))];
            end
        end
        disp(toc)
    end
    
    % Translate femoral cartilage nodes inferiorly  
    nf=nf-d(i);
    t_brute(i)=toc;
    
    
end

% 0.9 second per femcart element * 20000 ef elems for ONE TIME ITERATION -->
% Not feasible
      
% Store time at each iteration
% Store contact pairs at each iteration


%% Bucket sorting method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bux_vec=[100];
t_bux=[];
num_contact_bux=zeros(length(d),length(bux_vec));

for bux_trial=1:length(bux_vec)
    
    disp(['Bucket sorting simulation with bucket grid of '  num2str(bux_vec(bux_trial)) ' x ' num2str(bux_vec(bux_trial))])
    
    nf=nf_o;

    %%%% Create buckets for bucket sorting %%%%
    num_bux=bux_vec(bux_trial);
    [bucket_metadata, femcart_buckets, tibcart_m_buckets, tibcart_l_buckets]=create_hex_buckets(nf, ef, ntl, etl, ntm, etm, num_bux);

    %%%% Perform simulation using buckets %%%%

    for dd=1:length(d) % All time steps
        tic

        for i=1:size(bucket_metadata, 1) % Iterate along height of bucket grid
            for j=1:size(bucket_metadata, 2) % Iterate along width of bucket grid
                %disp(['Bucket ' num2str(i) ' ' num2str(j)])

                % Generate search buckets based on neighbors
                search_buckets=[];
                for ii=i-1:1:i+1
                    for jj=j-1:1:j+1
                        if ii>=1 && ii<=num_bux && jj>=1 && jj<=num_bux
                            search_buckets=[search_buckets; [ii,jj]]; % y,x
                        end
                    end
                end


                for f=1:size(femcart_buckets{i,j},1) % Each fmcart element in the current femcart bucket
                    fc_nodes=nf(femcart_buckets{i,j}(f,:),:);
                    for sb=1:size(search_buckets,1) % Search all neighboring buckets as well

                        % Medial tibial cartilage
                        for tm=1:size(tibcart_m_buckets{search_buckets(sb,1),search_buckets(sb,2)},1)
                            tmc_nodes=ntm(tibcart_m_buckets{search_buckets(sb,1),search_buckets(sb,2)}(tm,:),:);
                            c=check_hex_contact(fc_nodes, tmc_nodes);
                            if c==1
                                num_contact_bux(dd,bux_trial)=num_contact_bux(dd,bux_trial)+1;
                            end
                        end
                        
                        % Lateral tibial cartilage
                        for tl=1:size(tibcart_l_buckets{search_buckets(sb,1),search_buckets(sb,2)},1)
                            tlc_nodes=ntl(tibcart_l_buckets{search_buckets(sb,1),search_buckets(sb,2)}(tl,:),:);
                            c=check_hex_contact(fc_nodes, tlc_nodes);
                            if c==1
                                num_contact_bux(dd,bux_trial)=num_contact_bux(dd,bux_trial)+1;
                            end
                        end

                    end
                end


            end 
        end

        % Translate femoral cartilage nodes inferiorly  at end of time step        
        disp(toc)
        nf=nf-d(dd);
        t_brute(dd,bux_trial)=toc;
        
    end
    
end

clear tibcart_l_buckets
clear tibcart_m_buckets
clear femcart_buckets

%% Create R-trees %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rtree_f=generate_r_tree_wrapper(nf_o, ef);
rtree_tm=generate_r_tree_wrapper(ntm, etm);
rtree_tl=generate_r_tree_wrapper(ntl, etl);


%% Perform simulation using R-tree method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nf=nf_o;
t_r=[];
ne_r=[];
n_cur=[];

for dd=1:length(d) % All time steps
    disp(['time step ' num2str(dd)])
    tic
    
    % Search for contact elements by comparing femoral cartilage r-tree to
    % medial tibial cartilage r-tree
    efc1=search_rtrees_wrapper(rtree_f, rtree_tm, nf, ntm);
    
    % Repeat with lateral tibial r-tree
    efc2=search_rtrees_wrapper(rtree_f, rtree_tl, nf, ntl);
    
    efc_tot=[efc1; efc2];

    
    t_r(dd)=toc;
    ne_r(dd)=size(efc_tot,1);
    n_cur{dd}=nf;
    
    % Update femoral cartilage nodes
    nf(:,3)=nf(:,3)-d(dd);
    
    disp(['Updating R-tree for time step ' num2str(dd)])
    % Update femoral R-tree
    for jj=1:size(rtree_f,1) % Iterate through all entries in the tree
       if size(rtree_f{jj,1},2)==1 % Check to see if the current level is not a leaf
            rtree_f{jj,5}=rtree_f{jj,5}-d(dd);
            rtree_f{jj,6}=rtree_f{jj,6}-d(dd);
       end
    end
   disp(['Step took ' num2str(toc)])
    

end

%% Plots and visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot of time as a function of number of elements in contact for R-tree
% Add bux
% Add brute force
figure(9999)
plot(ne_r,t_r,'r'); hold on
plot(ne_r,40*ones(length(ne_r)),'b'); hold on
title('Duration of Simulation Steps as a Function of Contacted Femoral Cartilage Elements')
legend('R-Tree Approach','Bucket Sorting Approach')
xlabel('Number of Femoral Elements Experiencing Contact')
ylabel('Duration of Simulation Step (sec)')

% Plots
for dd=1:length(d)
    figure(dd)
    patch_ver =patch('vertices', n_cur{dd},'faces',Hex2Quads(ef)); axis equal, view(3), lighting gouraud
    set(patch_ver,'FaceColor',[1 0 0],'FaceLighting','phong','EdgeColor','r','FaceAlpha',0.1,'EdgeAlpha',1); hold on

    patch_ver =patch('vertices',ntm,'faces',Hex2Quads(etm)); axis equal, view(3), lighting gouraud
    set(patch_ver,'FaceColor',[0 1 0],'FaceLighting','phong','EdgeColor','g','FaceAlpha',0.1,'EdgeAlpha',1); hold on

    patch_ver =patch('vertices',ntl,'faces',Hex2Quads(etl)); axis equal, view(3), lighting gouraud
    set(patch_ver,'FaceColor',[0 0 1],'FaceLighting','phong','EdgeColor','b','FaceAlpha',0.1,'EdgeAlpha',1); hold on

    title(['Cartilage Positions at Time Step '  num2str(dd)])

    xlabel('X -- Med(+)/Lat(-)')
    ylabel('Y -- Pos(+)/Ant(-)')
    zlabel('Z -- Sup(+)/Inf(-)')
    view(90,0)
end

% Plot of fem cart with some bounding boxes
figure(909)
patch_ver =patch('vertices', nf,'faces',Hex2Quads(ef)); axis equal, view(3), lighting gouraud
set(patch_ver,'FaceColor',[1 0 0],'FaceLighting','phong','EdgeColor','r','FaceAlpha',0.3,'EdgeAlpha',0.4); hold on

root_elem=hex_from_bounds([rtree_f{1,1} rtree_f{1,2} rtree_f{1,3} rtree_f{1,4} rtree_f{1,5} rtree_f{1,6}]);
scatter3(root_elem(:,1),root_elem(:,2),root_elem(:,3),'filled')
title('Femoral Cartilage Mesh with R-Tree Root Bounding Box')


% Plot of grid
figure(911)
patch_ver =patch('vertices', n_cur{dd},'faces',Hex2Quads(ef)); axis equal, view(3), lighting gouraud
set(patch_ver,'FaceColor',[1 0 0],'FaceLighting','phong','EdgeColor','r','FaceAlpha',0.0,'EdgeAlpha',0.05); hold on

patch_ver =patch('vertices',ntm,'faces',Hex2Quads(etm)); axis equal, view(3), lighting gouraud
set(patch_ver,'FaceColor',[0 1 0],'FaceLighting','phong','EdgeColor','g','FaceAlpha',0.0,'EdgeAlpha',0.05); hold on

patch_ver =patch('vertices',ntl,'faces',Hex2Quads(etl)); axis equal, view(3), lighting gouraud
set(patch_ver,'FaceColor',[0 0 1],'FaceLighting','phong','EdgeColor','b','FaceAlpha',0.0,'EdgeAlpha',0.05); hold on

for i=1:size(bucket_metadata,1)
    for j=1:size(bucket_metadata,1)
        plot([bucket_metadata{i,j}(1) bucket_metadata{i,j}(1)],[bucket_metadata{i,j}(3) bucket_metadata{i,j}(4)], 'k');
        plot([bucket_metadata{i,j}(1) bucket_metadata{i,j}(2)],[bucket_metadata{i,j}(3) bucket_metadata{i,j}(3)], 'k');
        plot([bucket_metadata{i,j}(1) bucket_metadata{i,j}(2)],[bucket_metadata{i,j}(4) bucket_metadata{i,j}(4)], 'k');
        plot([bucket_metadata{i,j}(2) bucket_metadata{i,j}(2)],[bucket_metadata{i,j}(3) bucket_metadata{i,j}(4)], 'k');
    end
end

title('Visulaization of Bucket Grid on XY Plane')

