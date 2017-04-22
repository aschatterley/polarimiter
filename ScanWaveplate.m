function varargout = ScanWaveplate(varargin)
% SCANWAVEPLATE MATLAB code for ScanWaveplate.fig
%      SCANWAVEPLATE, by itself, creates a new SCANWAVEPLATE or raises the existing
%      singleton*.
%
%      H = SCANWAVEPLATE returns the handle to a new SCANWAVEPLATE or the handle to
%      the existing singleton*.
%
%      SCANWAVEPLATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCANWAVEPLATE.M with the given input arguments.
%
%      SCANWAVEPLATE('Property','Value',...) creates a new SCANWAVEPLATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ScanWaveplate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ScanWaveplate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ScanWaveplate

% Last Modified by GUIDE v2.5 22-Apr-2017 23:38:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ScanWaveplate_OpeningFcn, ...
    'gui_OutputFcn',  @ScanWaveplate_OutputFcn, ...
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
end

% --- Executes just before ScanWaveplate is made visible.
function ScanWaveplate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScanWaveplate (see VARARGIN)

% Choose default command line output for ScanWaveplate
handles.output = hObject;

%handles.wpTable.Data = {'0.5', '45'; '0.25', 'th'};
%handles.stokesTable.Data = [1; 1; 0; 0];

handles.theta = (0:359);

if ~isfield(handles, 'polPlot')
    %make the scan plot
    hold(handles.scanAxes, 'on');
    yyaxis(handles.scanAxes, 'left')
    handles.polPlot = plot(handles.theta, handles.theta, ...
        'LineWidth', 1.5, 'Parent', handles.scanAxes);
    ylabel(handles.scanAxes, 'Intensity through vertical polarizer');
    ylim(handles.scanAxes, [0 1]);

    
    yyaxis(handles.scanAxes, 'right')
    handles.circPlot = plot(handles.theta, handles.theta, ...
        'LineStyle', '--', 'LineWidth', 1.5, 'Parent', handles.scanAxes);
    ylabel(handles.scanAxes, 'Ellipse aspect ratio');
    
    
    hold(handles.scanAxes, 'off');
    grid(handles.scanAxes, 'on');
    xlim(handles.scanAxes, [0 359]);
    ylim(handles.scanAxes, [0 1]);
    xlabel(handles.scanAxes, 'Waveplate Angle (deg)');
    
    %make the ellipse plot
    handles.elPlot =  plot(handles.theta, handles.theta, ...
        'LineStyle', '-', 'LineWidth', 2, 'Parent', handles.ellipseAxes);
    grid(handles.ellipseAxes, 'on');
    axis(handles.ellipseAxes, 'tight');
    xlim(handles.ellipseAxes, [-1 1]);
    ylim(handles.ellipseAxes, [-1 1]);
    
    %make the data tip for the ellipse
    handles.tip = makedatatip(handles.polPlot, 1);
    
    set(handles.tip, 'UpdateFcn', @ellipseDataTip );
    
   % handles.tip.UpdateFcn = @ellipseDataTip;
    
    handles = updatePlot(handles);
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ScanWaveplate wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = ScanWaveplate_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes when entered data in editable cell(s) in wpTable.
function wpTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to wpTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% Update handles structure
handles = updatePlot(handles);

if ~isempty(handles.wpTable.Data{end, 1})
    handles.wpTable.Data{end+1,1} = '';
end

guidata(hObject, handles);
end

% --- Executes when entered data in editable cell(s) in stokesTable.
function stokesTable_CellEditCallback(hObject, eventdata, handles)
handles = updatePlot(handles);
guidata(hObject, handles);
end


function handleBack = updatePlot(handles)

%the general approach here is that we make a [theta x 4] matrix to hold the
%stokes parameters at each theta. For every waveplate, we update this.

stokes = repmat(handles.stokesTable.Data, 1, length(handles.theta));

%loop through each waveplate
for n=1:size(handles.wpTable.Data, 1)
    ret = 360*str2double(handles.wpTable.Data{n,1});
    angle = handles.wpTable.Data{n,2};
    
    if isnan(ret)
        continue;
    end
    
    if (strcmp(angle, 'scan'))
        ang = Inf;
    else
        ang = str2double(angle);
        if isnan(ang)
            continue
        end
    end
    
    %loop through every theta (we need to do this even if it's not a scan)
    k = 1;
    for th=handles.theta
        if (ang == Inf)
            stokes(:,k) = Retarder(stokes(:,k), ret, th);
        else
            stokes(:,k) = Retarder(stokes(:,k), ret, ang);
        end
        k = k+1;
    end
end

%finally, stick every angle through a polarizer
k = 1;
for th=handles.theta
    [ellipse] = MakeEllipse(stokes(:,k), handles.theta);    
    handles.circPlot.YData(k) = abs(min(ellipse(1:2)) / max(ellipse(1:2)));
    
    handles.polPlot.YData(k) = Polarizer(stokes(:,k));
    k = k+1;
end

handles.stokes = stokes;

handleBack = handles;
end


function output_txt = ellipseDataTip(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
handles = guidata(obj);

pos = get(event_obj,'Position');
output_txt = {['theta: ',num2str(pos(1),4)],...
    ['I: ',num2str(pos(2),4)]};


[el, handles.elPlot.XData, handles.elPlot.YData] = ...
    MakeEllipse(handles.stokes(:, event_obj.DataIndex), handles.theta);

handles.ellipseLabel.String = sprintf('aspect ratio = %0.3f',...
    abs(min(el(1:2)) / max(el(1:2))));

guidata(obj, handles);
end
