function varargout = tissue_reliability(varargin)
% TISSUE_RELIABILITY MATLAB code for tissue_reliability.fig
%      TISSUE_RELIABILITY, by itself, creates a new TISSUE_RELIABILITY or raises the existing
%      singleton*.
%
%      H = TISSUE_RELIABILITY returns the handle to a new TISSUE_RELIABILITY or the handle to
%      the existing singleton*.
%
%      TISSUE_RELIABILITY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TISSUE_RELIABILITY.M with the given input arguments.
%
%      TISSUE_RELIABILITY('Property','Value',...) creates a new TISSUE_RELIABILITY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tissue_reliability_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tissue_reliability_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tissue_reliability

% Last Modified by GUIDE v2.5 18-Jul-2017 11:55:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tissue_reliability_OpeningFcn, ...
                   'gui_OutputFcn',  @tissue_reliability_OutputFcn, ...
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


% --- Executes just before tissue_reliability is made visible.
function tissue_reliability_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tissue_reliability (see VARARGIN)

% Choose default command line output for tissue_reliability
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tissue_reliability wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tissue_reliability_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in display_GM_voxels.
function display_GM_voxels_Callback(hObject, eventdata, handles)
% hObject    handle to display_GM_voxels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of display_GM_voxels


% --- Executes on button press in display_WM_voxels.
function display_WM_voxels_Callback(hObject, eventdata, handles)
% hObject    handle to display_WM_voxels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of display_WM_voxels


% --- Executes on button press in display_CSF_voxels.
function display_CSF_voxels_Callback(hObject, eventdata, handles)
% hObject    handle to display_CSF_voxels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of display_CSF_voxels


% --- Executes on slider movement.
function GM_slider_Callback(hObject, eventdata, handles)
% hObject    handle to GM_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function GM_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GM_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
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


% --- Executes during object creation, after setting all properties.
function WM_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WM_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
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


% --- Executes during object creation, after setting all properties.
function CSF_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CSF_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function curves_title_Callback(hObject, eventdata, handles)
% hObject    handle to curves_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curves_title as text
%        str2double(get(hObject,'String')) returns contents of curves_title as a double


% --- Executes during object creation, after setting all properties.
function curves_title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curves_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function voxel_title_Callback(hObject, eventdata, handles)
% hObject    handle to voxel_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of voxel_title as text
%        str2double(get(hObject,'String')) returns contents of voxel_title as a double


% --- Executes during object creation, after setting all properties.
function voxel_title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to voxel_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
