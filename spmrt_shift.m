function [xd yd delta deltaCI] = spmrt_shift(image1,image2,mask,plotshift,threshold)

spm('defaults', 'FMRI');

%% Get the data
if exist('threshold','var')
    [X,x,y,z] = spmrt_getdata(image1,image2,mask,threshold);
else
    [X,x,y,z] = spmrt_getdata(image1,image2,mask);
end
n = size(X,1);
A = X(:,1); 
B = X(:,2);
clear X

% Compute Harell-Davis estimates and Shift function
nboot=200;
c=(37./n.^1.4)+2.75; % The constant c was determined so that the simultaneous 
                     % probability coverage of all 9 differences is
                     % approximately 95% when sampling from normal
                     % distributions
                     
% Get >>ONE<< set of B bootstrap samples
% The same set is used for all nine quantiles being compared
list = zeros(nboot,n);
for b=1:nboot
    list(b,:) = randsample(1:n,n,true);
end

xd = NaN(1,9);
yd = NaN(1,9);
delta = NaN(1,9);
if nargout == 4
    deltaCI = NaN(9,2);
end

for d=1:9
   fprintf('estimating decile %g\n',d)
   xd(d) = spmrt_hd(A,d./10);
   yd(d) = spmrt_hd(B,d./10);
   delta(d) = yd(d) - xd(d);

   if nargout == 4
       parfor b=1:nboot
           bootdelta(b) = spmrt_hd(B(list(b,:)),d./10) - spmrt_hd(A(list(b,:)),d./10);
       end
       delta_bse = std(bootdelta,0);
       deltaCI(d,1) = yd(d)-xd(d)-c.*delta_bse;
       deltaCI(d,2) = yd(d)-xd(d)+c.*delta_bse;
   end
end

% check which voxels are in common in each decile
for d=1:10
    if d == 1
        index = find(((A<=xd(d)) + (B<=xd(d)))==2);
    elseif d = 10
            
    else
            
    end
end


  
%% figure
if plotshift==1 && nargout == 4
    figure('Name','Shit function between image voxel values');set(gcf,'Color','w');
    plot(xd,delta,'ko'); hold on
    fillhandle=fill([xd fliplr(xd)],[deltaCI(:,1)' fliplr(deltaCI(:,2)')],[1 0 0]);
    set(fillhandle,'LineWidth',2,'EdgeColor',[1 0 0],'FaceAlpha',0.2,'EdgeAlpha',0.8);%set edge color
    refline(0,0); xlabel('x (image 1)','FontSize',14)
    ylabel('Delta','FontSize',14); set(gca,'FontSize',12)
    grid on; box on
end


