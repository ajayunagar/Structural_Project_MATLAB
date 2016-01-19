function varargout = RadioButtonsForLoadingType(varargin)
% RADIOBUTTONSFORLOADINGTYPE MATLAB code for RadioButtonsForLoadingType.fig
%      RADIOBUTTONSFORLOADINGTYPE, by itself, creates a new RADIOBUTTONSFORLOADINGTYPE or raises the existing
%      singleton*.
%
%      H = RADIOBUTTONSFORLOADINGTYPE returns the handle to a new RADIOBUTTONSFORLOADINGTYPE or the handle to
%      the existing singleton*.
%
%      RADIOBUTTONSFORLOADINGTYPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RADIOBUTTONSFORLOADINGTYPE.M with the given input arguments.
%
%      RADIOBUTTONSFORLOADINGTYPE('Property','Value',...) creates a new RADIOBUTTONSFORLOADINGTYPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RadioButtonsForLoadingType_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RadioButtonsForLoadingType_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RadioButtonsForLoadingType

% Last Modified by GUIDE v2.5 16-Jan-2015 22:35:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RadioButtonsForLoadingType_OpeningFcn, ...
                   'gui_OutputFcn',  @RadioButtonsForLoadingType_OutputFcn, ...
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


% --- Executes just before RadioButtonsForLoadingType is made visible.
function RadioButtonsForLoadingType_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RadioButtonsForLoadingType (see VARARGIN)

% Choose default command line output for RadioButtonsForLoadingType
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RadioButtonsForLoadingType wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RadioButtonsForLoadingType_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PointLoad.
function PointLoad_Callback(hObject, eventdata, handles)
% hObject    handle to PointLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PointLoad
pointload = get(hObject,'Value');
% --- Executes on button press in UDL.
function UDL_Callback(hObject, eventdata, handles)
% hObject    handle to UDL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UDL
UDL = get(hObject,'Value');
% --- Executes on button press in VUDL.
function VUDL_Callback(hObject, eventdata, handles)
% hObject    handle to VUDL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VUDLget(hObject,'Value')
VUDL = get(hObject,'Value');
PointLoad_Callback(