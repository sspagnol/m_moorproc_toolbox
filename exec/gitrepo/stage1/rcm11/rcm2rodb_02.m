
% Reads ACSII output from Aanderaa RCM 11 (310) and converts to RODB format
%--------------------------------------------------------------------------
% By: Hao Zuo (adapted from rcm2rodb_scu.m by Aazani)
% need function rcm2rodb_z.m (adapted from rcm2rodb.m)
% moor number need to be specified\
% input files should be named with the formated of ***_data.asc and *** is
% the serial number of the instruments.

% CHANGES:
% 27/4/06 - create version 02 - DR modified code to prompt for inpath, outpath and moor
%         - Hao's original file is rcm2rodb_scuzuo.m
%         - also included addpath lines



close all
clear all

moor = input('Please enter complete mooring name (e.g. wb1_2_200527): ','s');
[gash, operator]=system('whoami'); % This line will not work if run from a PC. May need to edit it out.
% gash is not used, but a second variable needs to be specified for the system command
inpath = input('Please enter complete path for infiles (e.g. /data/jrd/hydro10/rapid/data/moor/raw/WB1_2005/rcm/): ','s');
outpath = input('Please enter complete path for outfiles (NB: Check you have write permissions for this folder): ','s');
infofile = ['/data/jrd/hydro10/rapid/data/moor/proc/',moor,'/',moor,'info.dat'];

addpath /data/jrd/hydro10/rapid/data/exec/moor/rodb
addpath /data/jrd/hydro10/rapid/data/exec/moor/tools
addpath /data/jrd/hydro10/rapid/data/exec/mfiles/sea

%moor     = 'wb1_2_200527';
%operator = 'hz';
%inpath   = ['/data/jrd/hydro10/rapid/data/moor/raw/WB1_2005/rcm/'];
%outpath  = ['/data/jrd/hydro10/users/zuo/proc/',moor,'/'];
%infofile = ['/data/jrd/hydro10/users/zuo/proc/',moor,'/',moor,'info.dat'];

out_ext  = ['.raw'];

toffset = 0;

% vector of serial numbers

[id,sn,c1,c2]= rodbload(infofile,'id:sn:rcmc1:rcmc2');
if isempty(id) | isnan(id)  ;
[id,sn,lat,lon]= rodbload(infofile,'instrument:serialnumber:latitude:longitude');
end

ii = find(id == 310);
vec = sn(ii);           % serial numbers of RCM11
c_low = c1(ii);         % lower limit of RCM11 conductivity range [mS/cm]
c_upp = c2(ii);         % upper limit of RCM11 conductivity range [mS/cm]

fidlog = fopen([outpath,'RCM_stage1_log'],'w');
fprintf(fidlog,'Transformation of ascii data to rodb format \n');
fprintf(fidlog,'Processing carried out by %s at %s\n\n\n',operator,datestr(clock));

fprintf(fidlog,'Mooring   %s \n',moor);
fprintf(fidlog,'Latitude  %6.3f \n',lat);
fprintf(fidlog,'Longitude %6.3f \n',lon);




 for i = 1:length(vec),
    fprintf(fidlog,'\n\n');
    
 infile = [inpath,sprintf('%3.3d',vec(i)),'_data.asc'];
    
    % ......in case of other infile names.....
    % if exist(infile)~=2
    %   ......... 
    % end
    
 outfile = [outpath,moor,'_',sprintf('%3.3d',vec(i)),out_ext];
    
%    infile = ['/local1/rapid/data/moor/raw/WB1_2005/rcm/test_DATA.ASC'];
%    outfile = [outpath,'test.raw'];
%    using a test input file to test the program
    
    rcm2rodb_z(infile,outfile,infofile,fidlog,vec(i),c_low(i),c_upp(i),toffset)
    
    disp(['proceeding to next file ']);
    pause

end

comment = input('Enter additional comment to be save in Log file? ','s'); 

if ~isempty(comment)
  fprintf(fidlog,'\n COMMENT:\n %s',comment)
end

fclose(fidlog);
    


