function [rP,rC,CIP,CIC]=spmrt_corr(image1,image2,mask,metric,figout,threshold,alpha_level)

% Computes the Pearson (vector-wise) and concordance correlations
% between image1 and image2 for data included in the mask
%
% FORMAT [rP,rC,CIP,CIC]=spmup_corr(image1,image1,'both',mask,threshold,alpha_level)
%        [rP,CIP]=spmup_corr(image1,image1,'Pearson',mask,threshold,alpha_level)
%        [rC,CIC]=spmup_corr(image1,image1,'Concordance',mask,threshold,alpha_level)
%
% INPUT image1 is the filename of an image (see spm_select)
%       image2 is the filename of an image (see spm_select)
%       mask   is the filename of a mask in same space as image1 and image2
%       metric is 'Pearson', 'Concordance', or 'both'
%       figout 1/0 (default) to get correlation figure out
%       threshold (optional) if mask is not binary, threshold to apply
%       alpha_level is the level used to compute the confidence interval (default is 5%)
%
% OUTPUT rP is the Pearson correlation coefficient
%        rC is the concordance correlation coefficient
%        CIP is the 95% confidence interval of rP (if 0 not included then significant)
%        CIC is the 95% confidence interval of rC (if 0 not included then significant)
%
% Concordance correlation is more useful for reliability because it estimates
% how much variation from the 45 degree line we have (by using the cov)
% see Lin, L.I. 1989. A Corcordance Correlation Coefficient to Evaluate
% Reproducibility. Biometrics 45, 255-268.
%
% Cyril Pernet
% --------------------------------------------------------------------------
% Copyright (C) spmrt 

rP = []; CIP = [];
rC = []; CIC = [];
nboot = 1000; % a thousand bootstraps

%% check inputs
spm('defaults', 'FMRI');
if nargin < 7; alpha_level = 5/100; end 
if nargin < 5; figout = 0; end 
if nargin < 4; metric = 'both'; end

%% Get the data
if exist('threshold','var')
    X = spmrt_getdata(image1,image2,mask,threshold);
else
    X = spmrt_getdata(image1,image2,mask);
end
n = size(X,1);

%% Pearson correlation
if strcmpi(metric,'Pearson') || strcmpi(metric,'Both')
    rP = sum(detrend(X(:,1),'constant').*detrend(X(:,2),'constant')) ./ ...
        (sum(detrend(X(:,1),'constant').^2).*sum(detrend(X(:,2),'constant').^2)).^(1/2);
   
    if nargout > 1
        disp('computing Pearson''s CI')
        table = randi(n,n,nboot); 
        for b=1:nboot
            rPB(b) = sum(detrend(X(table(:,b),1),'constant').*detrend(X(table(:,b),2),'constant')) ./ ...
                (sum(detrend(X(table(:,b),1),'constant').^2).*sum(detrend(X(table(:,b),2),'constant').^2)).^(1/2);
        end
        rPB = sort(rPB,1);
        adj_nboot = nboot - sum(isnan(rPB));
        low = round((alpha_level*adj_nboot)/2); % lower bound
        high = adj_nboot - low; % upper bound
        CIP = [rPB(low) rPB(high)];
    end
end


%% Concordance
if strcmpi(metric,'Concordance') || strcmpi(metric,'Both')
    S = cov(X,1); Var1 = S(1,1); Var2 = S(2,2); S = S(1,2);
    rC = (2.*S) ./ (Var1+Var2+((mean(X(:,1)-mean(X(:,2)).^2))));

    if nargout > 1
        disp('computing Concordance correlation CI')
        if strcmpi(metric,'Concordance')
            table = randi(n,n,nboot); % otherwise reuse the one from above = same sampling scheme
        end
        
        for b=1:nboot
            S = cov(X(table(:,b),:),1); Var1 = S(1,1); Var2 = S(2,2); S = S(1,2);
            rCB(b) = (2.*S) ./ (Var1+Var2+((mean(X(table(:,b),1)-mean(X(table(:,b),2)).^2))));
        end
        rCB = sort(rCB,1);
        adj_nboot = nboot - sum(isnan(rCB));
        low = round((alpha_level*adj_nboot)/2); % lower bound
        high = adj_nboot - low; % upper bound
        CIC = [rCB(low) rCB(high)];
    end
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


