function e=search_rtrees_wrapper(rtree1,  rtree2)

     e_f_root=hex_from_bounds([rtree_f{1,1} rtree_f{1,2} rtree_f{1,3} rtree_f{1,4} rtree_f{1,5} rtree_f{1,6}]);
     e_tm_root=hex_from_bounds([rtree_tm{1,1} rtree_tm{1,2} rtree_tm{1,3} rtree_tm{1,4} rtree_tm{1,5} rtree_tm{1,6}]);
     c=check_hex_contact(e_f_root, e_tm_root);
     
     
     if c==1
        % Span down femoral cartialge r-tree first
        
         
     else
         % Span down tibial cartilage r-tree second
         
     end


end
