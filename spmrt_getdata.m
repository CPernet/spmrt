function X = spmrt_getdata(image1,image2,mask,threshold)

% routine to read data from image1 and image2 inside the mask (above threshold)
%
% FORMAT X = spmrt_getdata(image1,image2,mask)
%        X = spmrt_getdata(image1,image2,mask,threshold)
%
% INPUT image1 is the filename of an image (see spm_select)
%       image2 is the filename of an image (see spm_select)
%       mask   is the filename of a mask in same space as image1 and image2
%       threshold (optional) if mask is not binary, threshold to apply
%
% OUTPUT X is a [N voxels by 2] matrix (with NaN removed if any)
%
% Cyril Pernet
% --------------------------------------------------------------------------
% Copyright (C) spmrt 


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
    mask = mask >= threshold;
end

%% Get the data
[x,y,z] = ind2sub(M.dim,find(mask));
X = [spm_get_data(V1,[x y z]'); spm_get_data(V2,[x y z]')]';
X(isnan(X(:,1)),:) = []; % clean up if needed
X(isnan(X(:,2)),:) = [];

