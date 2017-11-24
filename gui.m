function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 04-Jun-2017 15:08:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

%global f;
%f = imread('Desert.jpg');
axis off;
% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in rotacija.
function rotacija_Callback(hObject, eventdata, handles)
% hObject    handle to rotacija (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
f = im2double(f);
prompt = {'Unesite kut rotacije'};
dlg_title = 'Unos';
answer = inputdlg(prompt,dlg_title);
kut = str2num(answer{1});
B = imrotate(f, kut);
imshow(B)
title('Rotirana slika')

% --- Executes on button press in komplement.
function komplement_Callback(hObject, eventdata, handles)
% hObject    handle to komplement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
G = imcomplement(f);
imshow(G)
title('Komplement slike')

% --- Executes on button press in sharpening.
function sharpening_Callback(hObject, eventdata, handles)
% hObject    handle to sharpening (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
f = im2double(f);
lapmask = [0,-1, 0; -1,5,-1; 0,-1,0];
f = imfilter(f, lapmask, 'replicate');
imshow(f)
title('Izoštrena slika')

% --- Executes on button press in grayscale.
function grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
rgb = imread(slika);
gray = 0.2126 * rgb(:,:,1) + 0.7152 * rgb(:,:,2) + 0.0722 * rgb(:,:,3); 
imshow(gray)
title('Crno-bijela slika')

% --- Executes on button press in edges.
function edges_Callback(hObject, eventdata, handles)
% hObject    handle to edges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
f = rgb2gray(f);
g = edge(f,'canny');
%x = [-1 0 1; -2 0 2; -1 0 1];
%y = [1 2 1; 0 0 0; -1 -2 -1];
%g = imfilter(f, x);
%g = imfilter(f ,y);
imshow(g);
title('Slika sa isticanim rubovima')


% --- Executes on button press in hsi.
function hsi_Callback(hObject, eventdata, handles)
% hObject    handle to hsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
rgb = imread(slika);
rgb = im2double(rgb);
r = rgb(:, :, 1);
g = rgb(:, :, 2);
b = rgb(:, :, 3);
% Implement the conversion equations.
num = 0.5*((r - g) + (r - b));
den = sqrt((r - g) .^2 + (r - b).*(g - b));
theta = acos(num./(den + eps));
H = theta;
H(b > g) = 2*pi - H(b > g);
H = H/(2*pi);
num = min(min(r, g), b);
den = r + g + b;
den(den == 0) = eps;
S = 1 - 3.* num./den;
H(S == 0) = 0;
I = (r+g+b)/3;
image = cat(3,H,S,I);
imshow(image);

% --- Executes on button press in blurring.
function blurring_Callback(hObject, eventdata, handles)
% hObject    handle to blurring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
kernelRadius = 20;
kernelLength = (2 * kernelRadius ) + 1;
mGaussianKernel = fspecial('gaussian', [kernelLength, kernelLength], kernelRadius);

% Blur Image
blurredImage = imfilter(f,mGaussianKernel,'same');

imshow(blurredImage);
title('Zamucena slika');

% --- Executes during object creation, after setting all properties.
function original_CreateFcn(hObject, eventdata, handles)
% hObject    handle to original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in red.
function red_Callback(hObject, eventdata, handles)
% hObject    handle to red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of red

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
red = f;

red(:,:,2)= 0;
red(:,:,3)= 0;
imshow(red)
title('Crvena slika')

% --- Executes on button press in green.
function green_Callback(hObject, eventdata, handles)
% hObject    handle to green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of green

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
green = f;

green(:,:,1)= 0;
green(:,:,3)= 0;
imshow(green)
title('Zelena slika')

% --- Executes on button press in blue.
function blue_Callback(hObject, eventdata, handles)
% hObject    handle to blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of blue

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
blue = f;

blue(:,:,1)= 0;
blue(:,:,2)= 0;
imshow(blue)
title('Plava slika')


% --- Executes on button press in redPojacanje.
function redPojacanje_Callback(hObject, eventdata, handles)
% hObject    handle to redPojacanje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of redPojacanje

slika = getappdata(handles.ucitajSliku,'picture');
RGBImage = imread(slika);
RGBImage = im2double(RGBImage);
Red = RGBImage(:, :, 1);
enhancedRed = max(Red + 0.1, 1.0);
RGBImage(:, :, 1) = enhancedRed;
imshow(RGBImage);
title('Pove?anje crvene boje')

% --- Executes on button press in greenPojacanje.
function greenPojacanje_Callback(hObject, eventdata, handles)
% hObject    handle to greenPojacanje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of greenPojacanje

slika = getappdata(handles.ucitajSliku,'picture');
RGBImage = imread(slika);
RGBImage = im2double(RGBImage);
Green = RGBImage(:, :, 2);
enhancedGreen = max(Green + 0.1, 1.0);
RGBImage(:, :, 2) = enhancedGreen;
imshow(RGBImage)
title('Pove?anje zelene boje')

% --- Executes on button press in bluePojacanje.
function bluePojacanje_Callback(hObject, eventdata, handles)
% hObject    handle to bluePojacanje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bluePojacanje

slika = getappdata(handles.ucitajSliku,'picture');
RGBImage = imread(slika);
RGBImage = im2double(RGBImage);
Blue = RGBImage(:, :, 3);
enhancedBlue = max(Blue + 0.1, 1.0);
RGBImage(:, :, 3) = enhancedBlue;
imshow(RGBImage);
title('Pove?anje plave boje')


% --- Executes on button press in original.
function original_Callback(hObject, eventdata, handles)
% hObject    handle to original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
imshow(f); title('Originalna slika')


% --- Executes on button press in gamma.
function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gamma

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
f = im2double(f);
prompt = {'Unesite gamma'};
dlg_title = 'Unos';
answer = inputdlg(prompt,dlg_title);
gam = str2num(answer{1});
g = imadjust(f, [ ], [ ], gam);
imshow(g)
title('Gamma transformacija')

% --- Executes on button press in stretch.
function stretch_Callback(hObject, eventdata, handles)
% hObject    handle to stretch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stretch

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
f = im2double(f);
m = mean2(f);
prompt = {'Unesite epsilon: '};
dlg_title = 'Unos';
answer = inputdlg(prompt,dlg_title);
E = str2num(answer{1});
g = 1./(1 + (m./(f + eps)).^E);
imshow(g)
title('Stretch transformacija')

% --- Executes on button press in sum.
function sum_Callback(hObject, eventdata, handles)
% hObject    handle to sum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
f = im2double(f);
f = rgb2gray(f);
noise_mean = 0;
noise_var = 0.01;
noisy = imnoise(f, 'gaussian', noise_mean, noise_var);
figure(1), imshow(noisy)
title('Slika sa šumovima')

noisy = im2double(noisy);
suma2 = sum(noisy(:));
n = numel(noisy);
mean = suma2/n;
devijacija = std(noisy(:));
signalToNoise = 20 * log10(mean/devijacija);

K = wiener2(noisy,[10 10]);
figure(2),imshow(K)
title('Slika sa uklonjenim šumovima')
K = im2double(K(:));
suma2 = sum(K(:));
n2 = numel(K);
mean2 = suma2/n2;
devijacija2 = std(K);
signalToNoise2 = 20 * log10(mean2/devijacija2);
message = sprintf('Omjer signal/sum na slici sa sumovima = %f\nOmjer signal/sum nakon uklanjanja sumova = %f', signalToNoise2, signalToNoise);
msgbox(message)

% --- Executes on button press in ucitajSliku.
function ucitajSliku_Callback(hObject, eventdata, handles)
% hObject    handle to ucitajSliku (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename;
filename = uigetfile('*.jpg;*.tif;*.png;*.gif', 'Select a MATLAB picture');
imshow(filename);
title(filename);
setappdata(handles.ucitajSliku,'picture',filename);

% --- Executes on button press in detekcijaTocke.
function detekcijaTocke_Callback(hObject, eventdata, handles)
% hObject    handle to detekcijaTocke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slika = getappdata(handles.ucitajSliku,'picture');
f = imread(slika);
%f = rgb2gray(f);
f = double(f);
%f(1:end, 1:end)= 0;
f(100, 100) = 2000;
w = [-1 -1 -1; -1 8 -1; -1 -1 -1];
g = abs(imfilter(f, w));

T = max(g(:));
T
g = g >= T;
imshow(g); title('Detekcija tocke'); colormap gray;