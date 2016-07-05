function varargout = Jtweaker(varargin)
% JTWEAKER MATLAB code for Jtweaker.fig
%      JTWEAKER, by itself, creates a new JTWEAKER or raises the existing
%      singleton*.
%
%      H = JTWEAKER returns the handle to a new JTWEAKER or the handle to
%      the existing singleton*.
%
%      JTWEAKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JTWEAKER.M with the given input arguments.
%
%      JTWEAKER('Property','Value',...) creates a new JTWEAKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Jtweaker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Jtweaker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Jtweaker

% Last Modified by GUIDE v2.5 18-May-2016 12:10:29
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Jtweaker_OpeningFcn, ...
                   'gui_OutputFcn',  @Jtweaker_OutputFcn, ...
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

function [ss_var, fraction, all_x, all_y,...
    sp_x, vq3, saveData] =  Jtweaker_Process(handles, ds_surface, surface_data, ag, bg, cg)

s_mean = [];
s_stdev = [];

ds_size = size(ds_surface);

for j=1:ds_size(1)
    wol = ds_surface{j,2};
    wol(isnan(wol)) = [];
    s_mean = [s_mean; mean(wol)];
    s_stdev = [s_stdev; std(wol)];
end

ds_dist = cell2mat(ds_surface(:,1));
ds_norm = ds_dist./max(ds_dist);

ss = surface_data.ss;

ed = -3.5:1:5.5;
xp = [-3:1:5];
all_x = [];
all_y = [];

for k=1:length(ss)
   [N,edges] = histcounts(ss{k}, ed);
   all_x = [all_x; xp];
   
   % Frequency Density
   fD = N./sum(N);
   
   all_y = [all_y; fD];
end

freq_no = numel(all_y);
norm = all_y./freq_no;
sp_x = -3:.1:5;
vq2 = interp1(xp,mean(norm),sp_x,'spline');
vq3 = interp1(xp,mean(all_y),sp_x,'spline');


xdx = .01;
dist_dx = [];

for l=1:length(ds_dist)
    if l==length(ds_dist)
       dist_dx(l) = 0; 
    else
       dist_dx(l) = ds_dist(l+1)-ds_dist(l); 
    end
end

ds_x = min(ds_norm):xdx:1;
mean_interp = interp1(ds_norm,s_mean,ds_x,'spline');
stdev_interp = interp1(ds_norm,s_stdev,ds_x,'spline');

int_constant = trapz(sp_x,vq2);

expsym = vq2./int_constant;

CV = mean(surface_data.cv_norm); 

C1 = [];
C2 = [];

mean_fit = polyfit(ds_x,mean_interp,1);
mean_linear = polyval(mean_fit,ds_x);

stdev_fit = polyfit(ds_x,stdev_interp,1);
stdev_linear = polyval(stdev_fit,ds_x);
% 
% figure
% plot(ds_x, mean_interp);
% hold on;
% plot(ds_x, mean_linear, 'k--');
% 
% figure
% plot(ds_x, stdev_interp);
% hold on;
% plot(ds_x, stdev_linear, 'k--');

% for k=1:length(ds_x)
%     if k == 1
%         k1 = k;
%         k2 = k+1;     
%     else
%         k1 = k-1;
%         k2 = k;
%     end
%     
%     ddx = mean_interp(k1)-mean_interp(k2);
%     stdx = stdev_interp(k1)-stdev_interp(k2);
%     dx = ds_x(k2)-ds_x(k1);
%     cc1 = (1-(1/stdev_interp(k)))*(stdx/dx);
%     cc2 = (1-(1/mean_interp(k)))*(stdx/dx);
%     C1 = [C1;cc1];
%     C2 = [C2;cc2];
% end
% 
% C1_av = mean(C1);
% C2_av = mean(C2);

% Using linear decay

% C1 = (1-(1./stdev_interp))*(stdev_fit(1)*xdx);
% C2 = (1-(1./mean_interp))*(stdev_fit(1)*xdx);
% 
% C1_av = mean(C1);
% C2_av = mean(C2);

% Using 'real' distance dx

for o=1:length(dist_dx)-1
	C1(o) = (1-(1/stdev_interp(o)))*(stdev_fit(1)/dist_dx(o));
	C2(o) = (1-(1/mean_interp(o)))*(stdev_fit(1)/dist_dx(o));    
end

C1_av = mean(C1);
C2_av = mean(C2);

% Duller et al. 2010 values
% CV = 1.11;
C1_av = .7;
% C2_av = .5;
C2_av = C1_av/CV;

ss_var = -3:.1:5;

jfunc = @(x) (ag*(exp(-bg*x))+cg);

J = arrayfun(jfunc, ss_var, 'UniformOutput', true)';
Jprime = zeros(length(ss_var), 1);
phi = zeros(length(ss_var), 1);
sym = zeros(length(ss_var), 1);
expsym = zeros(length(ss_var), 1);
intsysmeps = zeros(length(ss_var), 1);
sigma = zeros(length(ss_var), 1);

for p=1:length(ss_var)    
    if p == 1
        k1 = p;
        k2 = p+1;     
    else
        k1 = p-1;
        k2 = p;
    end
    ss_change = ss_var(k1)-ss_var(k2);
    J_change = J(k1)-J(k2);
    Jprime(p) = J_change/ss_change;
    phi(p) = (1/(C1_av*(1+(C2_av/C1_av)*ss_var(p))))*(1-(1/J(p)))-(Jprime(p)/J(p));
    phi_change = phi(k1)+phi(k2);
    sym(p) = 0.5*phi_change*ss_change;    
end

for y=1:length(sym)
    if y > 1
        sigma(y) = sigma(y-1)+sym(y);
    else
        sigma(y) = sym(y);
    end
    expsym(y) = exp(-sigma(y));
end

for r=1:length(sigma)
    if r == 1
        k1 = r;
        k2 = r+1;
    else
        k1 = r-1;
        k2 = r;      
    end
    
    ss_change = ss_var(k1)-ss_var(k2);
    expsym_change = expsym(k1)+expsym(k2);
    intsysmeps(r) = 0.5*expsym_change*ss_change;
end


int_val = sum(intsysmeps);
int_constant_ana = freq_no/int_val;
%int_constant_ana = 1/int_val;
fraction = intsysmeps*int_constant_ana;

saveData = struct();
saveData.J = J;
saveData.Jprime = Jprime;
saveData.phi = phi;
saveData.sym = sym;
saveData.sigma = sigma;
saveData.expsym = expsym;
saveData.intsysmeps = intsysmeps;
saveData.fraction = fraction;
saveData.ss_var = ss_var';
saveData.int_constant_ana = int_constant_ana;

set(handles.c1_output, 'String', C1_av);
set(handles.c2_output, 'String', C2_av);
set(handles.cv_output, 'String', CV);

function Jtweaker_ProbabilityPlot(handles)
cla(handles.axes1,'reset')
axes(handles.axes1)
p1 = plot(handles.ss,handles.fraction);
hold on;
p2 = plot(handles.fit_x, handles.fit_y, 'x');
hold on;
p3 = plot(handles.field_x,handles.field_y);   

function [handles] = Jtweaker_UpdateHandles(handles, ss, fraction, fit_x,...
    fit_y, field_x, field_y, saveData)
handles.saveData = saveData;
handles.fit_x = fit_x;
handles.fit_y = fit_y;
handles.field_x = field_x;
handles.field_y = field_y;
handles.ss = ss;
handles.fraction = fraction;

function Jtweaker_UpdateSystem(handles, ss, fraction, field_x, field_y, fit_x, fit_y, saveData)
handles = Jtweaker_UpdateHandles(handles, ss, fraction, field_x, field_y, fit_x, fit_y, saveData);
guidata(handles.output, handles);
Jtweaker_ProbabilityPlot(handles);

function Jtweaker_ProcessJValues(handles)
    new_ag = get(handles.a_val_slider, 'Value');
    new_bg = get(handles.bg_val_slider, 'Value');
    new_cg = get(handles.cg_val_slider, 'Value');
    
    [ss, fraction, field_x, field_y,...
        fit_x, fit_y, saveData] = Jtweaker_Process(handles, handles.ds_surface, ...
        handles.surface_data, new_ag, new_bg, new_cg);
    
    Jtweaker_UpdateSystem(handles, ss, fraction, field_x, field_y, fit_x, fit_y, saveData);


% --- Executes just before Jtweaker is made visible.
function Jtweaker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Jtweaker (see VARARGIN)

% Choose default command line output for Jtweaker
handles.output = hObject;
ag = .9;
bg = .2;
cg = .15;

if length(varargin) == 4
    previous_params = varargin{4};
    ag = previous_params.ag;
    bg = previous_params.bg;
    cg = previous_params.cg; 
end

[ss, fraction, field_x, field_y, fit_x, fit_y] = Jtweaker_Process(handles, varargin{1},  varargin{2}, ag, bg, cg);
handles.ds_surface = varargin{1};
handles.surface_data = varargin{2};
handles.surface_name = varargin{3};
set(handles.surface_title,'String', handles.surface_name)

set(handles.a_val_slider,'Value', ag)
set(handles.bg_val_slider,'Value', bg)
set(handles.cg_val_slider,'Value', cg)
set(handles.ag_output,'String', ag)
set(handles.bg_output,'String', bg)
set(handles.cg_output,'String', cg)

set(handles.a_val_slider,'Min', -5)
set(handles.bg_val_slider,'Min', -5)
set(handles.cg_val_slider,'Min', -5)

set(handles.a_val_slider,'Max', 5)
set(handles.bg_val_slider,'Max', 5)
set(handles.cg_val_slider,'Max', 5)

set(handles.a_val_slider, 'SliderStep', [1/1000 , 10/1000 ]);
set(handles.bg_val_slider, 'SliderStep', [1/1000 , 10/1000 ]);
set(handles.cg_val_slider, 'SliderStep', [1/1000 , 10/1000 ]);
% Update handles structure

Jtweaker_UpdateSystem(handles, ss, fraction, field_x, field_y, fit_x, fit_y, 0);

% UIWAIT makes Jtweaker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Jtweaker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function a_val_slider_Callback(hObject, eventdata, handles)
% hObject    handle to a_val_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

  val = get(hObject,'Value');
  set(handles.ag_output,'String', num2str(val))
  Jtweaker_ProcessJValues(handles);
  
% --- Executes during object creation, after setting all properties.
function a_val_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_val_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bg_val_slider_Callback(hObject, eventdata, handles)
% hObject    handle to bg_val_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
  val = get(hObject,'Value');
  set(handles.bg_output,'string', num2str(val))
Jtweaker_ProcessJValues(handles);

% --- Executes during object creation, after setting all properties.
function bg_val_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg_val_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function cg_val_slider_Callback(hObject, eventdata, handles)
% hObject    handle to cg_val_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
  val = get(hObject,'Value');
  set(handles.cg_output,'string', num2str(val))
  Jtweaker_ProcessJValues(handles);

% --- Executes during object creation, after setting all properties.
function cg_val_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cg_val_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ag_output_Callback(hObject, eventdata, handles)
% hObject    handle to ag_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ag_output as text
%        str2double(get(hObject,'String')) returns contents of ag_output as a double


% --- Executes during object creation, after setting all properties.
function ag_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ag_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cg_output_Callback(hObject, eventdata, handles)
% hObject    handle to cg_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cg_output as text
%        str2double(get(hObject,'String')) returns contents of cg_output as a double


% --- Executes during object creation, after setting all properties.
function cg_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cg_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bg_output_Callback(hObject, eventdata, handles)
% hObject    handle to bg_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg_output as text
%        str2double(get(hObject,'String')) returns contents of bg_output as a double


% --- Executes during object creation, after setting all properties.
function bg_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c1_output_Callback(hObject, eventdata, handles)
% hObject    handle to c1_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c1_output as text
%        str2double(get(hObject,'String')) returns contents of c1_output as a double


% --- Executes during object creation, after setting all properties.
function c1_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c2_output_Callback(hObject, eventdata, handles)
% hObject    handle to c2_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c2_output as text
%        str2double(get(hObject,'String')) returns contents of c2_output as a double


% --- Executes during object creation, after setting all properties.
function c2_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cv_output_Callback(hObject, eventdata, handles)
% hObject    handle to cv_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cv_output as text
%        str2double(get(hObject,'String')) returns contents of cv_output as a double


% --- Executes during object creation, after setting all properties.
function cv_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cv_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_data_btn.
function save_data_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_data_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path]  = uiputfile('*.csv', 'Save Data', handles.surface_name);
saveData = handles.saveData;
disp(handles)
a = get(handles.ag_output,'String');
b = get(handles.bg_output,'String');
c = get(handles.cg_output,'String');
c1 = get(handles.c1_output,'String');
c2 = get(handles.c2_output,'String');
cV = get(handles.cv_output,'String');

saveData.ag        = a;
saveData.bg        = b;
saveData.cg        = c;
saveData.C1         = c1;
saveData.C2         = c2;
saveData.CV         = cV;

struct2csv(saveData,[path file]);
