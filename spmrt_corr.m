function [rP,rC]=spmrt_corr(image1,image2,mask,metric,figout,threshold)

% Computes the Pearson (vector-wise) and concordance correlations
% between image1 and image2 for data included in the mask
%
% FORMAT [rP,rC]=spmup_corr(image1,image1,metric',mask,threshold)
%
% INPUT image1 is the filename of an image (see spm_select)
%       image2 is the filename of an image (see spm_select)
%       mask   is the filename of a mask in same space as image1 and image2
%       metric is 'Pearson', 'Concordance', or 'both'
%       figout 1/0 (default) to get correlation figure out
%       threshold (optional) if mask is not binary, threshold to apply
%
% OUTPUT rP is the Pearson correlation coefficient
%        rC is the concordance correlation coefficient
%
% Concordance correlation is more useful for reliability because it estimates
% how much variation from the 45 degree line we have (by using the cov)
% see Lin, L.I. 1989. A Corcordance Correlation Coefficient to Evaluate
% Reproducibility. Biometrics 45, 255-268.
%
% Cyril Pernet
% --------------------------------------------------------------------------
% Copyright (C) spmrt 

rP = [];
rC = [];

%% check inputs
spm('defaults', 'FMRI');
V1 = spm_vol(image1);
V2 = spm_vol(image2);
if any(V1.dim ~= V2.dim)
    error('input images are of different dimensions')
end

M = spm_vol(mask);
if any(M.dim ~= V1.dim)
    error('mask and input image are of different dimensions')
end
mask = spm_read_vols(M);
if exist('threshold','var')
    mask = mask > threshold;
end

%% Get the data
[x,y,z] = ind2sub(M.dim,find(mask));
X = [spm_get_data(V1,[x y z]'); spm_get_data(V2,[x y z]')]';
X(isnan(X(:,1)),:) = []; % clean up if needed
X(isnan(X(:,2)),:) = [];

%% Pearson correlation
if strcmpi(metric,'Pearson') || strcmpi(metric,'Both')
    rP = sum(detrend(X(:,1),'constant').*detrend(X(:,2),'constant')) ./ ...
        (sum(detrend(X(:,1),'constant').^2).*sum(detrend(X(:,2),'constant').^2)).^(1/2);
end


%% Concordance
if strcmpi(metric,'Concordance') || strcmpi(metric,'Both')
    S = cov(X,1); Var1 = S(1,1); Var2 = S(2,2); S = S(1,2);
    rC = (2.*S) ./ (Var1+Var2+((mean(X(:,1)-mean(X(:,2)).^2))));
end

%% figure
if figout == 1
    figure; scatter(X(:,1),X(:,2),50); grid on          % plot pairs of observations
    xlabel('img1','FontSize',14); ylabel('img2','FontSize',14); % label
    h=lsline; set(h,'Color','r','LineWidth',4); % add the least square line
    box on;set(gca,'Fontsize',14); axis square; hold on
    v = axis; plot([v(1):v(2)],[v(3):v(4)],'k','LineWidth',2);  % add diagonal
    
    if strcmpi(metric,'Pearson')
        title(['Pearson corr =' num2str(rP)],'FontSize',16);
    elseif strcmpi(metric,'Concordance')
        title(['Concordance corr =' num2str(rC)],'FontSize',16);
    else
        title(sprintf('Pearson corr =%g \n Concordance corr =%g', rP,rC),'FontSize',16);
    end
end


