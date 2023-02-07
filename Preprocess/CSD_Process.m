function [CSD, LFP] = CSD_Process(trialsLFP, window, varargin)

%% Validate input
mInputParser = inputParser;
mInputParser.addRequired("trialsLFP");
mInputParser.addRequired("window");
mInputParser.addOptional("CSD_Method", "kCSD", @(x) any(validatestring(x, {'five point','three point', 'kCSD'})));
mInputParser.addOptional("badCh", [], @(x) validateattributes(x, {'numeric'}, "2d"));
mInputParser.addOptional("dz", 150, @(x) validateattributes(x, {'numeric'}, {'numel', 1}));

mInputParser.parse(trialsLFP, window, varargin{:});
CSD_Method = mInputParser.Results.CSD_Method;
badCh = mInputParser.Results.badCh;
dz = mInputParser.Results.dz;
%% handle bad channel
    temp = changeCellRowNum(trialsLFP);
    if ~isempty(badCh)
        if ~ismember(badCh, [1, size(trialsLFP{1}, 1)])
            temp{badCh, 1} = (temp{badCh - 1} + temp{badCh + 1}) / 2;
        else
            temp{badCh, 1} = [];
        end
    end
    trialsLFP = changeCellRowNum(temp);
    
%% compute CSD
    switch string(CSD_Method)
        case "five point"
            W = -1*[0.23, 0.08, -0.62, 0.08, .23];
            Boundary = 2;
            dz = 2 * dz;
        case "three point"
            W = -1*[ 0.23, -0.54, 0.23];
            Boundary = 1;
            dz = 2 * dz;
        case "kCSD" % 
            W = -0.4 * [1, -2, 1];
            Boundary = 1;
    end
[CSD_Raw, CSD_Wave] = cellfun(@(x) CSD_Compute(x, Boundary, W, dz), trialsLFP, "UniformOutput", false);

CSD.Data = cell2mat(cellfun(@mean, changeCellRowNum(CSD_Raw), "uni", false));
CSD.Chs = Boundary + 1 : size(trialsLFP{1}, 1) - Boundary;
CSD.t = linspace(window(1), window(2), size(CSD.Data, 2));
CSD.Boundary = Boundary;
CSD.tWave = linspace(window(1), window(2), size(CSD_Wave{1}, 2));
CSD.Wave = CSD_Wave;

%% compute lfp image data
temp = cellfun(@(x) interp2(x, 3), trialsLFP, "UniformOutput", false);
LFP.Data = cell2mat(cellfun(@mean, changeCellRowNum(temp), "UniformOutput", false));
LFP.Chs = 1 : size(trialsLFP{1}, 1);
LFP.Raw = double(cell2mat(cellfun(@mean, changeCellRowNum(trialsLFP), "UniformOutput", false)));
LFP.tImage = linspace(window(1), window(2), size(LFP.Data, 2));
LFP.tWave = linspace(window(1), window(2), size(LFP.Raw, 2));







    

    



