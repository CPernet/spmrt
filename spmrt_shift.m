function [xd yd delta deltaCI] = spmrt_shift(image1,image2,mask,plotshift,threshold)

% Implementation of thr shift function analysis for dependent measures.
% It compares the distributions of voxels between two images (within in a maks)
% and then check the spatial location of those - this tells if some deciles are more
% reliable than others (for instance all low values can be the same but not
% hight ones)
%
% FORMAT xd yd delta deltaCI] = spmrt_shift(image1,image2,mask,plotshift,threshold)
%
% INPUT if no input the user is prompted
%       threshold (optional) if mask is not binary, threshold to apply
%
% OUTPUT xd and yd are the Harell-Davis estimators (decile) of each image
%        delta and deltaCI the result of the shif function
%        -- images are also writen on the drive for each decile
%
% Cyril Pernet
% --------------------------------------------------------------------------
% Copyright (C) spmrt


%% check inputs
spm('defaults', 'FMRI');
if nargin < 5; threshold = []; end 
if nargin < 4; plotshift = 'yes'; threshold = []; end 

if nargin == 0
    [image1,image2,mask]=spmrt_pickupfiles;
    if size(mask,1) > 1
        warning('only one mask image allowed, using the 1st frame only')
        mask = mask(1,:);
    end
    figout = 1; % if user if prompt to enter data then return a figure
end

%% Get the data
if exist('threshold','var') && ~isempty(threshold)
    X = spmrt_getdata(image1,image2,mask,threshold);
else
    X = spmrt_getdata(image1,image2,mask);
end
n = size(X,1);
if any(sum(X,1) == 0)
    error('at least one image is empty')
end

A = X(:,1); 
B = X(:,2);
clear X

% Compute Harell-Davis estimates and Shift function
c=(37./n.^1.4)+2.75; % The constant c was determined so that the simultaneous 
                     % probability coverage of all 9 differences is
                     % approximately 95% when sampling from normal
                     % distributions
nboot = 200;         % default suggested by Wilcox


% Get >>ONE<< set of B bootstrap samples
% The same set is used for all nine quantiles being compared
btable = zeros(n,nboot);
for b=1:nboot
    btable(:,b) = randsample(1:n,n,true);
end

xd = NaN(1,9);
yd = NaN(1,9);
delta = NaN(1,9);
deltaCI = NaN(9,2);

for d=1:9
   fprintf('estimating decile %g\n',d)
   xd(d) = spmrt_hd(A,d./10);
   yd(d) = spmrt_hd(B,d./10);
   delta(d) = yd(d) - xd(d);
   bootdelta =spmrt_hd(B(btable),d./10)- spmrt_hd(A(btable),d./10);
   delta_bse = std(bootdelta,0);
   deltaCI(d,1) = yd(d)-xd(d)-c.*delta_bse;
   deltaCI(d,2) = yd(d)-xd(d)+c.*delta_bse;
end

% check which voxels are in common in each decile

V1 = spm_vol(image1);
V2 = spm_vol(image2);
 

for d=1:10
    [xA,yA,zA] = ind2sub(V1.dim,find((A<=xd(d))));
    [xB,yB,zB] = ind2sub(V2.dim,find((B<=yd(d))));
    [xC,yC,zC] = ind2sub(V2.dim,find(((A<=xd(d)) + (B<=yd(d)))==2));
    % write an image of this
    W = V1; W.fname = [pwd filesep 'decile_' num2str(d) '.nii'];
    W.descrip = [num2str(d) 'decile from a shift function analysis'];
    W.private.descrip = W.descrip;
    data = zeros(W.dim);
    data(xA,yA,zA) = 80;
    data(xB,yB,zB) = 160;
    data(xC,yC,zC) = 240;
    spm_write_vol(W,data)

    if d == 1
        find((A<=xd(d))
        
    elseif d = 10
            
    else
            
    end
end


  
%% figure
if strcmpi('plotshift','yes')
    figure('Name','Shit function between image voxel values');set(gcf,'Color','w');
    plot(xd,delta,'ko'); hold on
    fillhandle=fill([xd fliplr(xd)],[deltaCI(:,1)' fliplr(deltaCI(:,2)')],[1 0 0]);
    set(fillhandle,'LineWidth',2,'EdgeColor',[1 0 0],'FaceAlpha',0.2,'EdgeAlpha',0.8);%set edge color
    refline(0,0); xlabel('x (image 1)','FontSize',14)
    ylabel('Delta','FontSize',14); set(gca,'FontSize',12)
    grid on; box on
end


