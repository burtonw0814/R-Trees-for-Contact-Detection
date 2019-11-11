function e=search_rtrees_wrapper(rtree1, rtree2, n1, n2)
% % 
% rtree1=rtree_f;
% rtree2=rtree_tm;
% n1=nf;
% n2=ntm;

     % Non-terminal tree nodes of the R-trees store cartesian extrema of
     % the bounding boxes
     % So we need to get the corners of the bounding boxes from these
     % extrema
     e_f_root=hex_from_bounds([rtree1{1,1} rtree1{1,2} rtree1{1,3} rtree1{1,4} rtree1{1,5} rtree1{1,6}]);
     e_tm_root=hex_from_bounds([rtree2{1,1} rtree2{1,2} rtree2{1,3} rtree2{1,4} rtree2{1,5} rtree2{1,6}]);
     
     % Check for contact between root nodes
     c=check_hex_contact(e_f_root, e_tm_root);
     
     % Initialize list of femoral cartilage contact nodes
     fem_contact_elems=[];     
     if c==1
            
        disp('Root Check Passed')
        depth=1;    
        % Span down femoral cartilage r-tree first
        % Find all femoral elems that intersect the tibial tree root box
        ref_box=e_tm_root;
        idx=1;
        fem_contact_elems=search_rsubtree(fem_contact_elems, rtree1, idx, ref_box, n1, depth);
        
        %disp('Refining candidates')
        fem_contact_elems_refined=[];
        % Search down tib tree for all femoral contract eleemnts        
        for j=1:size(fem_contact_elems,1)
            contact_elems_tib=[];
            ref_box=n1(fem_contact_elems(j,:),:);
            idx=1;
            contact_elems_tib=search_rsubtree(contact_elems_tib, rtree2, idx, ref_box, n2, depth);
            if size(contact_elems_tib,1)>1
                fem_contact_elems_refined=[fem_contact_elems_refined; fem_contact_elems(j,:)];
            end
        end
        fem_contact_elems=fem_contact_elems_refined;

     end
       
     e=fem_contact_elems;
     
end
