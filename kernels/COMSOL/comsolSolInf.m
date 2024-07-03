% Create COMSOL solution information for extract B field
% Syntax:
%
%           comsol=comsolSolInf(num,coilName)
%
% Parameters:
%
%           num        - channel number
%
%           coilName   - specify coil, like 'solenoid'
%
% Outputs:
%
%           comsol   - COMSOL solution information
%
% Mengjia He, 2024.01.06

function comsol=comsolSolInf(num,nuclei,coilName)

% default options
if ~exist('coilName','var') coilName = 'solenoid'; end

% DC simulation file name
comsol.DC.fileName = append('C',num2str(num),'_',coilName,'_DC');

if numel(nuclei) == 1
    
    % RF simulation file name
    comsol.RF.fileName = append('C',num2str(num),'_',coilName,'_RF');
else
    
    comsol.RF.fileName = append('C',num2str(num),'_',coilName,'_RF_mulFreq');

end

% data set
comsol.RF.dset = 'dset2';
comsol.DC.dset = 'dset1';
comsol.GD.dset = 'dset2';

% marked point
switch num
    case 1
        comsol.RF.objname = "pt1";

        comsol.DC.objname = "pt1";
		
		comsol.RF.dset = 'dset1';

    case 2
        comsol.RF.objname = ["mov2(4)","rot3(1)"];

        comsol.DC.objname = ["mov2(4)","rot3(1)"];
		
		comsol.GD.objname = ["pt1","pt2"];

    case 4
        comsol.RF.objname = ["mov2(4)","rot3(1)","rot3(2)","rot3(3)"];

        comsol.DC.objname = ["mov2(4)","rot3(1)","rot3(2)","rot3(3)"];

    case 8
        comsol.RF.objname = ["mov2(4)","rot3(1)","rot3(2)","rot3(3)",...
                             "rot3(4)","rot3(5)","rot3(6)","rot3(7)"];

        comsol.DC.objname = ["mov2(4)","rot3(1)","rot3(2)","rot3(3)",...
                             "rot3(4)","rot3(5)","rot3(6)","rot3(7)"];

    case 16

        comsol.RF.objname = ["mov2(4)","rot3(1)","rot3(2)","rot3(3)",...
                             "rot3(4)","rot3(5)","rot3(6)","rot3(7)",...
                             "rot3(8)","rot3(9)", "rot3(10)","rot3(11)",...
                             "rot3(12)","rot3(13)","rot3(14)","rot3(15)"];

        comsol.DC.objname = ["mov2(4)","rot3(46)","rot3(47)","rot3(48)",...
                             "rot3(49)","rot3(50)","rot3(51)","rot3(52)",...
                             "rot3(53)","rot3(54)", "rot3(55)","rot3(56)",...
                             "rot3(57)","rot3(58)","rot3(59)","rot3(60)"];

end
end