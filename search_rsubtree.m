function contact_elems=search_rsubtree(contact_elems, rtree, idx, ref_box, n,depth)

% contact_elems=fem_contact_elems;
% rtree=rtree1;
% %idx
% %ref_box
% n=n1;

    % contact_elems: iteratively updates list of elements that are in contact
    % rtree: rtree that is searched
    % idx: current index of rtree
    % ref_box: current box that is compared with the r_tree
    
    
    
    % Check for contact at current level
    % if no contact: return contact elements
    % if contact and leaf: add to list of contact elements
    % if contact and no leaf: go further down the rtree on both sides
    
    
    
    % Get box at current level
    if size(rtree{idx,1},2)==1 % Not at a leaf yet
       qbox=hex_from_bounds([rtree{idx,1} rtree{idx,2} rtree{idx,3} rtree{idx,4} rtree{idx,5} rtree{idx,6}]); 
       at_leaf=0;
    else % We have reached a leaf
        qbox=n(rtree{idx,1},:);
        at_leaf=1;
        %disp('Found leaf');
    end
    
%     disp(['Current depth is '  num2str(depth)]);
%     disp(['qbox is ']);
%     disp(qbox)
%     disp(['at_leaf is '  num2str(at_leaf)]);
    
    
    % Check for contact
    c=check_hex_contact(qbox, ref_box);
    
    %disp(['contact is '  num2str(c)]);
    % Case 1: No contact --> nothing happens, reached end of search path
    if c==0
        [];
%         disp(qbox)
%         disp(ref_box)
    end
    
    
    
    % Case 2: Contact present and we are at a leaf
    if c==1 && at_leaf==1
        % Add current leaf onto list of contact elements condidates
        contact_elems=[contact_elems; rtree{idx,1}];
    end
    
    
    
    % Case 3: Contact present but we are not at a leaf
    if c==1 && at_leaf==0
        % Continue search down tree on both sides
        idx_left=rtree{idx,8}; % Pointer to index of left-sided tree node
        %disp(['idx_left is '  num2str(idx_left)]);
        contact_elems=search_rsubtree(contact_elems, rtree, idx_left, ref_box, n,depth+1);
        
        idx_right=rtree{idx,9}; % Pointer to index of left-sided tree node
        %disp(['idx_right is '  num2str(idx_right)]);
        contact_elems=search_rsubtree(contact_elems, rtree, idx_right, ref_box, n,depth+1);
        
    end
    


end
