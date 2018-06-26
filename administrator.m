function varargout = administrator(varargin)
% ADMINISTRATOR M-file for administrator.fig
%      ADMINISTRATOR, by itself, creates a new ADMINISTRATOR or raises the existing
%      singleton*.
%
%      H = ADMINISTRATOR returns the handle to a new ADMINISTRATOR or the handle to
%      the existing singleton*.
%
%      ADMINISTRATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADMINISTRATOR.M with the given input arguments.
%
%      ADMINISTRATOR('Property','Value',...) creates a new ADMINISTRATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before administrator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to administrator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help administrator

% Last Modified by GUIDE v2.5 31-Mar-2018 16:18:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @administrator_OpeningFcn, ...
                   'gui_OutputFcn',  @administrator_OutputFcn, ...
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


% --- Executes just before administrator is made visible.
function administrator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to administrator (see VARARGIN)

% Choose default command line output for administrator
handles.output = hObject;

%authentication
userid='admin';
password='admin';

[id pw]=logindlg('title','Administrator'); % Ask for Id and password

% Update handles structure
guidata(hObject, handles);

set(gcf, 'visible','off')

axis(handles.axes4);
im=imread('background.png');
imshow(im,[]);


if strcmp(pw,password) && strcmp(id,userid)
    set(gcf, 'visible','on')
    
    % Set names in option bar
    load DB
    strs = {'New Entry'};
    for ii = 1:idx
        strs{ii+1,1} = DB(ii).name;
    end
    
    set(handles.popupmenu1,'String',strs)
else
    close(gcf);
    h=errordlg('Either Userid or Password is wrong');
    try
        pause(1)
        close(h)
    end
    main
end

try
% Update handles structure
guidata(hObject, handles);
end
% UIWAIT makes administrator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = administrator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browsefaceimage.
function browsefaceimage_Callback(hObject, eventdata, handles)
% hObject    handle to browsefaceimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global face1
[filename,pathname] = uigetfile('*.jpg','Choose the Face image');
vfilename = [pathname filename];

axes(handles.axes1);
inp = imread(vfilename);
imshow(inp,[]);
face1=inp;


% --- Executes on button press in push_update.
function push_update_Callback(hObject, eventdata, handles)
% hObject    handle to push_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global face1


if get(handles.popupmenu1,'Value') == 1
    % Check inputs
    name1 = get(handles.edit_name,'String');
    un = get(handles.edit_un,'String');
    pw = get(handles.edit_phonenum,'String');

    if isempty(name1)
        warndlg('Please enter the name')
        return;
    elseif isempty(un)
        warndlg('Please enter the USN')
        return;
    elseif isempty(pw)
        warndlg('Please enter the Phone number')
        return;
    elseif isempty(face1)
        warndlg('Please browse the face')
        return;
    end

    load DB
    % Incremnt index
    idx = idx+1;
    % Save details
    DB(idx).name = name1;
    DB(idx).un = un;
    DB(idx).pw = pw;
    DB(idx).face=face1;
    
   

    save DB DB idx

    % Set names in option bar
    load DB
    strs = {'New Entry'};
    for ii = 1:idx
        strs{ii+1,1} = DB(ii).name;
    end

    set(handles.popupmenu1,'String',strs)
      
end
disp('The database is updated succesfully')
msgbox('The database is updated succesfully')



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
if get(hObject,'Value') ==1
    set(handles.edit_name,'Enable','On')
    set(handles.edit_un,'Enable','On')
    set(handles.edit_phonenum,'Enable','On')
    set(handles.edit_name,'String','')
    set(handles.edit_un,'String','')
    set(handles.edit_phonenum,'String','')
else
    set(handles.edit_name,'Enable','Off')
    set(handles.edit_un,'Enable','Off')
    set(handles.edit_phonenum,'Enable','Off')
   load DB
    tid = get(handles.popupmenu1,'Value')-1;
    
    set(handles.edit_name,'String',DB(tid).name)
    set(handles.edit_un,'String',DB(tid).un)
    set(handles.edit_phonenum,'String','')
    
    
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_name as text
%        str2double(get(hObject,'String')) returns contents of edit_name as a double


% --- Executes during object creation, after setting all properties.
function edit_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_back.
function push_back_Callback(hObject, eventdata, handles)
% hObject    handle to push_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);
main_gui;


% --- Executes on button press in push_log.
function push_log_Callback(hObject, eventdata, handles)
% hObject    handle to push_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

view_log

function edit_un_Callback(hObject, eventdata, handles)
% hObject    handle to edit_un (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_un as text
%        str2double(get(hObject,'String')) returns contents of edit_un as a double


% --- Executes during object creation, after setting all properties.
function edit_un_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_un (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_phonenum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_phonenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_phonenum as text
%        str2double(get(hObject,'String')) returns contents of edit_phonenum as a double


% --- Executes during object creation, after setting all properties.
function edit_phonenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_phonenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);
main



