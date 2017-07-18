function [rP,CIP,rC,CIC] = spmrt_corrsub(image1, image2, masks, metric)

% Computes the Pearson (vector-wise) and concordance correlations with CI
% between image1 and image2 for data included in the mask
%
% FORMAT [rP,CIP,rC,CIC]=spmrt_corrsub(image1,image1,masks)
%
% INPUT image1 is the filename of an image (see spm_select)
%       image2 is the filename of an image (see spm_select)
%       masks is a cell array of filename of masks in same space as image1 and image2
%             the assumption for masks that the 1st filename is the full
%             brain mask, while the 2nd, 3rd and 4th are for gray matter,
%             white matter, and CSF (inpout at least one filename)
%       metric is 'Pearson', 'Concordance', or 'both'
%
% OUTPUT rP is the Pearson correlation coefficient
%        CIP is the 95% Confidence interval of the Pearson correlation coefficient
%        rC is the concordance correlation coefficient
%        CIC is the 95% Confidence interval of the Concordance correlation coefficient
%
% Conditional input/output:
% - if masks is a single filename, it is assumed to be the full brain mask and 
% rP, CIP, rC, CIC are returned as individual variables
% - if masks has multiple filenames, rP, CIP, rC, CIC are returned in a
% matrix format in which each row corresponds to the mask file
% - if mssks 2,3,4 are not binary, it is assumed to be probability maps and
% correlation curves are computed
%
% Cyril Pernet
% --------------------------------------------------------------------------
% Copyright (C) spmrt

if nargin < 3
    error()
elseif nargin == 3
    metric = 'both';
end
%% whole brain analysis

if iscell(masks); M = masks{1}; N =size(masks,2);
else, M = masks(1,:); N =size(masks,1); end
disp('whole brain analysis')
[rP,rC,CIP,CIC]=spmrt_corr(image1,image2,M,metric);
disp('--------------------')


%% analysis per tissue class

if N > 1
    
    % check all the masks are of the same data type
    % ---------------------------------------------
    binary_test = [1 1 1]; % assume all is binary
    for tc = 2:N
        if iscell(masks)
            M = spm_read_vols(spm_vol(masks{tc}));
        else
            M = spm_read_vols(spm_vol(masks(tc,:)));
        end
        
        if length(unique(M))>2
            binary_test(tc-1) = 0;
        end
    end
    
    if sum(binary_test)>0 && sum(binary_test)<3
        error('tissue class masks are not of the same type')
    end
    
    % compute correlation per tissue class
    % -------------------------------------
    if sum(binary_test) == 3
        if strcmpi(metric,'Pearson') || strcmpi(metric,'Both')
            tmp = NaN(N,1); tmp(1,1) = rP;  rP = tmp;  clear tmp
            tmp = NaN(N,2); tmp(1,:) = CIP; CIP = tmp; clear tmp
        end
        
        if strcmpi(metric,'Concordance') || strcmpi(metric,'Both')
            tmp = NaN(N,1); tmp(1,1) = rC;  rC = tmp;  clear tmp
            tmp = NaN(N,2); tmp(1,:) = CIC; CIC = tmp; clear tmp
        end
        
        for tc = 2:N
            if iscell(masks); M = masks{tc};
            else, M = masks(tc,:); end
            fprintf('computing correlations for tissue class %g\n',tc-1)
            [tmpP,tmpC,tmpcip,tmpcic]=spmrt_corr(image1,image2,M,metric);
            
            if strcmpi(metric,'Pearson') || strcmpi(metric,'Both')
                rP(tc,1) = tmpP; CIP(tc,:) = tmpcip;
            end
            
            if strcmpi(metric,'Concordance') || strcmpi(metric,'Both')
                rC(tc,1) = tmpC; CIC(tc,:) = tmpcic;
            end
       end
        
    elseif sum(binary_test) == 0
        if strcmpi(metric,'Pearson') || strcmpi(metric,'Both')
            tmp = NaN(N,10);   tmp(1,1) = rP;    rP = tmp;  clear tmp
            tmp = NaN(N,10,2); tmp(1,1,:) = CIP; CIP = tmp; clear tmp
        end
        
        if strcmpi(metric,'Concordance') || strcmpi(metric,'Both')
            tmp = NaN(N,10);   tmp(1,1) = rC;    rC = tmp;  clear tmp
            tmp = NaN(N,10,2); tmp(1,1,:) = CIC; CIC = tmp; clear tmp
        end
        
        for tc = 2:N % for each tissue class
            if iscell(masks); M = masks{tc};
            else, M = masks(tc,:); end
            for th=1:10 % for each threshold of the mask
                fprintf('computing correlations for tissue class %g threshold %g \n',tc-1,th/10-0.1)
                [tmpP,tmpC,tmpcip,tmpcic]=spmrt_corr(image1,image2,M,metric,0,th/10-0.1,0.005);
                
                if strcmpi(metric,'Pearson') || strcmpi(metric,'Both')
                    rP(tc,th) = tmpP; CIP(tc,th,1) = tmpcip(1); CIP(tc,th,2) = tmpcip(2);
                end
                
                if strcmpi(metric,'Concordance') || strcmpi(metric,'Both')
                    rC(tc,th) = tmpC; CIC(tc,th,1) = tmpcic(1); CIC(tc,th,2) = tmpcic(2);
                end
            end
        end
    end
end

%% data viz
if sum(binary_test) == 0 &&  N == 4
   tricolors = [0 0 1; 1 0 0; 0 1 0];
   
    if strcmpi(metric,'Pearson') || strcmpi(metric,'Both')
        figure('Name','Pearson Correlations per tissue class')
        for tc = N:-1:1
            if iscell(masks); M = masks{tc};
            else, M = masks(tc,:); end
            subplot(2,2,tc);  
            if tc ~= 1
               X{tc} = spmrt_getdata(image1,image2,M);
               scatter(X{tc}(:,1),X{tc}(:,2),50,tricolors(tc-1,:)); grid on  % plot pairs of observations
               h=lsline; set(h,'Color','r','LineWidth',4); % add the least square line
           else
               X{tc} = spmrt_getdata(image1,image2,M);
               scatter(X{tc}(:,1),X{tc}(:,2),50,[1 1 1]); hold on
               h=lsline; set(h,'Color','r','LineWidth',4); % add the least square line
               scatter(X{4}(:,1),X{4}(:,2),50,tricolors(3,:)); 
               scatter(X{3}(:,1),X{3}(:,2),50,tricolors(2,:)); 
               scatter(X{2}(:,1),X{2}(:,2),50,tricolors(1,:)); grid on
            end
            xlabel('img1','FontSize',14); ylabel('img2','FontSize',14); % label
            box on;set(gca,'Fontsize',14); axis square; hold on
            v = axis; plot([v(1):v(2)],[v(3):v(4)],'k','LineWidth',2);  % add diagonal
           
            if tc == 1
                title(['Whole image corr =' num2str(rP(tc))],'FontSize',12);
            elseif tc == 2
                title(['Grey matter corr =' num2str(rPtc))],'FontSize',12);
            elseif tc == 3
                title(['White matter corr =' num2str(rP(tc))],'FontSize',12);
            else
                title(['CSF corr =' num2str(rP(tc))],'FontSize',12);
            end
        end
    end
    
    if strcmpi(metric,'Concordance') || strcmpi(metric,'Both')
        figure('Name','Concordance Correlations per tissue class')
        for tc = N:-1:1
            if iscell(masks); M = masks{tc};
            else, M = masks(tc,:); end
            subplot(2,2,tc);  
            if tc ~= 1
               X{tc} = spmrt_getdata(image1,image2,M);
               scatter(X{tc}(:,1),X{tc}(:,2),50,tricolors(tc-1,:)); grid on  % plot pairs of observations
               h=lsline; set(h,'Color','r','LineWidth',4); % add the least square line
           else
               X{tc} = spmrt_getdata(image1,image2,M);
               scatter(X{tc}(:,1),X{tc}(:,2),50,[1 1 1]); hold on
               h=lsline; set(h,'Color','r','LineWidth',4); % add the least square line
               scatter(X{4}(:,1),X{4}(:,2),50,tricolors(3,:)); 
               scatter(X{3}(:,1),X{3}(:,2),50,tricolors(2,:)); 
               scatter(X{2}(:,1),X{2}(:,2),50,tricolors(1,:)); grid on
            end
            xlabel('img1','FontSize',14); ylabel('img2','FontSize',14); % label
            box on;set(gca,'Fontsize',14); axis square; hold on
            v = axis; plot([v(1):v(2)],[v(3):v(4)],'k','LineWidth',2);  % add diagonal
           
            if tc == 1
                title(['Whole image corr =' num2str(rC(tc))],'FontSize',12);
            elseif tc == 2
                title(['Grey matter corr =' num2str(rC(tc))],'FontSize',12);
            elseif tc == 3
                title(['White matter corr =' num2str(rC(tc))],'FontSize',12);
            else
                title(['CSF corr =' num2str(rC(tc))],'FontSize',12);
            end
        end
    end
else
    if strcmpi(metric,'Both')
        
    end
    tissue_reliability(Data,GM,WM,CSF)
end
