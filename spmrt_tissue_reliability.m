function varargout = spmrt_tissue_reliability(varargin)

% code for spmrt_tissue_reliability.fig, a simple interface to show
% reliability/correlation curves per tissue type whilst plotting the data 
% from initial images with an interactive thresholding of tissue maps
% Last Modified by GUIDE v2.5 31-Aug-2017 11:25:23
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% FORMAT varargout = spmrt_tissue_reliability(Data,GM,WM,CSF)
%
% INPUT Data is a 9*m matrix with m the number of correlations computed to
%            make correlation curves for different thresholds of the tissue
%            maps - row are order as low CI, corr, high CI and repeated for
%            tissue types 
%       tissue_values a cell array containing n*6 matrices for
%           GM is a n*6 matrix with values of image1, image2, x, y, z and
%               tissue values - this last column is used to vixualize at different
%               thresholds (matching m in Data)
%           WM is simular the GM
%           CSF is similar to GM
%
% Cyril Pernet
% --------------------------------------------------------------------------
% Copyright (C) spmrt 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spmrt_tissue_reliability_OpeningFcn, ...
                   'gui_OutputFcn',  @spmrt_tissue_reliability_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% warning off
% --- Executes just before spmrt_tissue_reliability is made visible.
function spmrt_tissue_reliability_OpeningFcn(hObject, ~, handles, varargin)
global handles

handles.data    = varargin{1};
handles.GM      = varargin{2}{1};
handles.WM      = varargin{3}{2};
handles.CSF     = varargin{4}{3};
handles.showGM  = 1;
handles.showWM  = 1;
handles.showCSF = 1;
handles.output  = hObject;

set(hObject,'Tag','Tissue type reliability');
axes2_CreateFcn(hObject, [], handles)
guidata(hObject,handles);
uiwait(handles.output);


% --- Outputs from this function are returned to the command line.
function varargout = spmrt_tissue_reliability_OutputFcn(hObject, eventdata, handles) 
if isempty(handles)
    varargout{1} = 'Reliability data viz terminated';
else
    varargout{1} = handles;
    delete(handles.output)
end


% --- Executes during object creation, after setting all properties.

% -------------------------------------------------
%% show the correlations
% -------------------------------------------------

function curves_title_Callback(hObject, eventdata, handles)
function curves_title_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
global handles

l = size(handles.data,2);
plot(handles.data(2,:),'k','LineWidth',1)
hold on; fillhandle=fill([1:l,l:-1:1],[handles.data(1,:),fliplr(handles.data(3,:))],[0 0 1]);
set(fillhandle,'EdgeColor',[0 0 1],'FaceAlpha',0.2,'EdgeAlpha',0.8); 

plot(handles.data(5,:),'k','LineWidth',1)
hold on; fillhandle=fill([1:l,l:-1:1],[handles.data(4,:),fliplr(handles.data(6,:))],[1 0 0]);
set(fillhandle,'EdgeColor',[1 0 0],'FaceAlpha',0.2,'EdgeAlpha',0.8); 

plot(handles.data(8,:),'k','LineWidth',1)
hold on; fillhandle=fill([1:l,l:-1:1],[handles.data(7,:),fliplr(handles.data(9,:))],[0 1 0 ]);
set(fillhandle,'EdgeColor',[0 1 0],'FaceAlpha',0.2,'EdgeAlpha',0.8); 

grid on; box on
guidata(hObject,handles);

% -------------------------------------------------
%% show the data and update with button and sliders
% -------------------------------------------------

function voxel_title_Callback(hObject, eventdata, handles)
function voxel_title_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function axes1_CreateFcn(hObject, eventdata, handles)
global handles

if handles.showCSF  == 1
    s = scatter(handles.CSF(:,1),handles.CSF(:,2),50,[0 1 0]); hold on
    s.MarkerEdgeAlpha = 0.5;
    s.MarkerFaceAlpha = 0.5;
    % s.MarkerFaceColor = 'green';
end

if handles.showWM  == 1
    s = scatter(handles.WM(:,1), handles.WM(:,2) ,50,[1 0 0]); hold on
    s.MarkerEdgeAlpha = 0.8;
    s.MarkerFaceAlpha = 0.8;
    % s.MarkerFaceColor = 'red';
end

if handles.showGM  == 1
    s = scatter(handles.GM(:,1), handles.GM(:,2) ,50,[0 0 1]); hold on
    s.MarkerEdgeAlpha = 0.8;
    s.MarkerFaceAlpha = 0.8;
    % s.MarkerFaceColor = 'blue';
end

grid on; box on
guidata(hObject,handles);

% --- Executes on button press in display_GM_voxels.
function display_GM_voxels_Callback(hObject, eventdata, handles)
% hObject    handle to display_GM_voxels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

content = get(hObject,'Value');
if content == 1
    handles.showGM = 1;
    guidata(hObject,handles);
    axes1_CreateFcn(hObject, eventdata, handles)
else
    handles.showGM = 0;
end
guidata(hObject,handles);

% --- Executes on button press in display_WM_voxels.
function display_WM_voxels_Callback(hObject, eventdata, handles)
% hObject    handle to display_WM_voxels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

content = get(hObject,'Value');


% --- Executes on button press in display_CSF_voxels.
function display_CSF_voxels_Callback(hObject, eventdata, handles)
% hObject    handle to display_CSF_voxels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

content = get(hObject,'Value');


function GM_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes on slider movement.
function GM_slider_Callback(hObject, eventdata, handles)
% hObject    handle to GM_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

content = get(hObject,'Value');
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider



function WM_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function WM_slider_Callback(hObject, eventdata, handles)
% hObject    handle to WM_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider





function CSF_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes on slider movement.
function CSF_slider_Callback(hObject, eventdata, handles)
% hObject    handle to CSF_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
