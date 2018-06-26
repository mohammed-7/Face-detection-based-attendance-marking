function varargout = reporting(varargin)
% REPORTING MATLAB code for reporting.fig
%      REPORTING, by itself, creates a new REPORTING or raises the existing
%      singleton*.
%
%      H = REPORTING returns the handle to a new REPORTING or the handle to
%      the existing singleton*.
%
%      REPORTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REPORTING.M with the given input arguments.
%
%      REPORTING('Property','Value',...) creates a new REPORTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reporting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reporting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reporting

% Last Modified by GUIDE v2.5 31-Mar-2018 13:34:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reporting_OpeningFcn, ...
                   'gui_OutputFcn',  @reporting_OutputFcn, ...
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


% --- Executes just before reporting is made visible.
function reporting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reporting (see VARARGIN)

% Choose default command line output for reporting
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reporting wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axis(handles.axes1);
im=imread('background.png');
imshow(im,[]);


% --- Outputs from this function are returned to the command line.
function varargout = reporting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in viewAttendance.
function viewAttendance_Callback(hObject, eventdata, handles)
% hObject    handle to viewAttendance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view_attendance

% --- Executes on button press in viewLatecomers.
function viewLatecomers_Callback(hObject, eventdata, handles)
% hObject    handle to viewLatecomers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view_latecomer

% --- Executes on button press in viewAttendanceLag.
function viewAttendanceLag_Callback(hObject, eventdata, handles)
% hObject    handle to viewAttendanceLag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lagv = str2num(get(handles.lagper,'String'));

fd = get(handles.fromd,'String');
td = get(handles.tod,'String');

d1=datenum(fd,'dd-mm-yyyy'),
d2=datenum(td,'dd-mm-yyyy'),
d=d1:d2;
numdays=0;
for k=1:numel(d)
  %do
  [DAYNUM,DAYNAME] = weekday(d(k));
  DAYNAME
  if DAYNUM~=1
  numdays=numdays+1;
  end
end
numdays


load log1
% 
% 
usns=[];
for ii = 1:size(log1,1)
      usns = [usns log1(ii,1)]; %usn
      
%     log1(ii,2); %name
%     log1(ii,3); %date
%     log1(ii,4); %time   
     
 end
usns

u = unique(usns)

fp=fopen('attenshortage.csv','w');
load DB

fprintf(1,'************Attendance Lag Persons are **************** \n');
for i=1:length(u)
   count=0;
    for ii=1:size(log1,1)
         
         if  strcmp(log1(ii,1),u(i))
             count=count+1;
         end
    end
    atype = count*100.0/numdays;
    if atype<lagv
      %fprintf(fp,'%s,%f\n',u(i),atype);
      %fprintf(1,'%s,%f\n',u(i),atype);
      %disp('checking attendance for')';
      u(i)
        
      for ii = 1:idx
          if strcmp(DB(ii).name,u(i))
              phone=DB(ii).pw;
              urlstr=['http://192.168.43.1:9090/sendsms?phone=' phone '&text=LowAttendance'];
              urlstr
              [str,status] = urlread(urlstr);
          end
      end
    end
end

fclose(fp);

fprintf(1,'*************************************\n');
%msgbox('saved to attenshortage.csv percentage excel sheet pls check');






function lagper_Callback(hObject, eventdata, handles)
% hObject    handle to lagper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lagper as text
%        str2double(get(hObject,'String')) returns contents of lagper as a double


% --- Executes during object creation, after setting all properties.
function lagper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lagper (see GCBO)
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



function fromd_Callback(hObject, eventdata, handles)
% hObject    handle to fromd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fromd as text
%        str2double(get(hObject,'String')) returns contents of fromd as a double


% --- Executes during object creation, after setting all properties.
function fromd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fromd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tod_Callback(hObject, eventdata, handles)
% hObject    handle to tod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tod as text
%        str2double(get(hObject,'String')) returns contents of tod as a double


% --- Executes during object creation, after setting all properties.
function tod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxlate_Callback(hObject, eventdata, handles)
% hObject    handle to maxlate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxlate as text
%        str2double(get(hObject,'String')) returns contents of maxlate as a double


% --- Executes during object creation, after setting all properties.
function maxlate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxlate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewFreqLates.
function viewFreqLates_Callback(hObject, eventdata, handles)
% hObject    handle to viewFreqLates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load log3

ml = str2num(get(handles.maxlate,'String'));


usns=[];
for ii = 1:size(log3,1)
      usns = [usns log3(ii,1)]; %usn

 end
usns

u = unique(usns)

fp=fopen('freqlates.csv','w');
for i=1:length(u)
    count=0;
    for ii=1:size(log3,1)
         
         if  strcmp(log3(ii,1),u(i))
             count=count+1;
         end
    end
    u(i)
    count
    if count>=ml
        
        fprintf(fp,'%s,%d\n',u(i),count); 
        fprintf(1,'%s,%d\n',u(i),count); 
    end
        
end

fclose(fp);
msgbox('saved to afreqlates.csv  pls check');

