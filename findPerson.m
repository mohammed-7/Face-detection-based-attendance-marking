function varargout = findPerson(varargin)
% FINDPERSON MATLAB code for findPerson.fig
%      FINDPERSON, by itself, creates a new FINDPERSON or raises the existing
%      singleton*.
%
%      H = FINDPERSON returns the handle to a new FINDPERSON or the handle to
%      the existing singleton*.
%
%      FINDPERSON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDPERSON.M with the given input arguments.
%
%      FINDPERSON('Property','Value',...) creates a new FINDPERSON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before findPerson_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to findPerson_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help findPerson

% Last Modified by GUIDE v2.5 31-Mar-2018 17:20:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @findPerson_OpeningFcn, ...
                   'gui_OutputFcn',  @findPerson_OutputFcn, ...
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


% --- Executes just before findPerson is made visible.
function findPerson_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to findPerson (see VARARGIN)

% Choose default command line output for findPerson
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes findPerson wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axis(handles.axes3);
im=imread('background.png');
imshow(im,[]);


% --- Outputs from this function are returned to the command line.
function varargout = findPerson_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browseFace.
function browseFace_Callback(hObject, eventdata, handles)
% hObject    handle to browseFace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f1
[filename,pathname] = uigetfile('*.jpg','Choose the Face image');
vfilename = [pathname filename];

axes(handles.axes2);
inp = imread(vfilename);
imshow(inp,[]);

im=rgb2gray(inp);
im=imresize(im,[200 200]);
points=detectSURFFeatures(im);
[f1,vpts1] = extractFeatures(im,points);




% --- Executes on button press in findPersonInFeed.
function findPersonInFeed_Callback(hObject, eventdata, handles)
% hObject    handle to findPersonInFeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f1

matchthres=0.15;
% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();

% Read a video frame and run the face detector.
%videoFileReader = vision.VideoFileReader('visionface.avi');
videoFileReader = vision.VideoFileReader('visionface.avi');


videoPlayer  = vision.VideoPlayer('Position', [200, 400, 700, 400]);

while ~isDone(videoFileReader)
    % get the next frame
    videoFrame = step(videoFileReader);

    videoFrame      = step(videoFileReader);
    bbox            = step(faceDetector, videoFrame);

    numface = size(bbox,1);
    if numface>0

        for i=1:numface
            faceimgx = imcrop(videoFrame,bbox(i,:));
            
            imf=rgb2gray(faceimgx);
            imf=imresize(imf,[200 200]);
            points=detectSURFFeatures(imf);
            [f2,vpts1] = extractFeatures(imf,points);
            [indexPairs,matchmetric] = matchFeatures(f1,f2);
            dis=sum(matchmetric);
            
            fprintf(1,'Dis of matching = %f \n',dis);
            if dis<matchthres
     
                x = bbox(i, 1); y = bbox(i, 2); w = bbox(i, 3); h = bbox(i, 4);
                % Draw the returned bounding box around the detected face.
                bboxPolygon = [x, y, x+w, y, x+w, y+h, x, y+h];
                videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon);
                posit=[x,y,w,h];
                videoFrame=insertObjectAnnotation(videoFrame,'rectangle',posit,'Found');
            end
            
        end
        
    end
     % Display the annotated video frame using the video player object
    step(videoPlayer, videoFrame);
end


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);
main
