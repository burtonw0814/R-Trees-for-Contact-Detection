function contact=check_hex_contact(n_box1, n_box2)

%     %      n_box1=nf(ef(j,:),:)
%     %      n_box2=ntl(etl(k,:),:)
%     
% hold on
%       scatter3(e_f_root(:,1), e_f_root(:,2), e_f_root(:,3), 'k'); hold on
%       scatter3(e_tm_root(:,1), e_tm_root(:,2), e_tm_root(:,3), 'k')
%            scatter3(o1(:,1),o1(:,2),o1(:,3), 'c')
%                 scatter3(o2(:,1), o2(:,2), o2(:,3), 'c')
% % %      
% % %      % Check contact between root nodes
% % %      c=check_hex_contact(e_f_root, e_tm_root);
% % %     
%      n_box1=e_f_root;
%      n_box2=e_tm_root;


% n_box1=nt1;
% n_box2=nt2;

    % Get box origins
    o1=mean(n_box1);
    o2=mean(n_box2);

    % Get vectors to corners
    for ii=1:length(n_box1(:,1))
        vecs1(ii,:)=n_box1(ii,:)-o1;
        vecs2(ii,:)=n_box2(ii,:)-o2;
    end

    % Get projection axis
    proj_axis=o2-o1;

    proj1=[]; proj2=[];
    % Get dot products from box vectors to projection axis
    for ii=1:length(vecs1(:,1))
       proj1(ii)=dot(vecs1(ii,:),(proj_axis./vecnorm(proj_axis)));
       proj2(ii)=dot(vecs2(ii,:),(proj_axis./vecnorm(proj_axis)));
    end

%     % Get maximum dot product from the first box and minimum dot product from
%     % second box
%     [max1, argmax1]=max(dot1);
%     [min2, argmin2]=min(dot2);
%     
%     % Projeciton of these vectors onto the main projection axis
%     proj1=max1.*proj_axis/(vecnorm(proj_axis)*vecnorm(proj_axis));
%     proj2=min2.*proj_axis/(vecnorm(proj_axis)*vecnorm(proj_axis));
    
    % Check difference
    if    vecnorm(proj_axis)-(max(proj1)-min(proj2))>0
        contact=0;
    else
        contact=1;
    end

end











