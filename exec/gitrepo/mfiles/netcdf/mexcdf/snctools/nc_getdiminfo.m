function dinfo = nc_getdiminfo ( arg1, arg2 )
% NC_GETDIMINFO:  returns metadata about a specific NetCDF dimension
%
% DINFO = NC_GETDIMINFO(NCFILE,DIMNAME) returns information about the
% dimension DIMNAME in the netCDF file NCFILE.
%
% DINFO = NC_GETDIMINFO(NCID,DIMID) returns information about the
% dimension with numeric ID DIMID in the already-opened netCDF file
% with file ID NCID.  This form is not recommended for use from the
% command line.
%
% Upon output, DINFO will have the following fields.
%
%    Name:  
%        a string containing the name of the dimension.
%    Length:  
%        a scalar equal to the length of the dimension
%    Unlimited:  
%        A flag, either 1 if the dimension is an unlimited dimension
%        or 0 if not.
%
% In case of an error, an exception is thrown.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Id: nc_getdiminfo.m 2528 2008-11-03 23:06:25Z johnevans007 $
% $LastChangedDate: 2008-11-03 18:06:25 -0500 (Mon, 03 Nov 2008) $
% $LastChangedRevision: 2528 $
% $LastChangedBy: johnevans007 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


nargchk(2,2,nargin);
nargoutchk(1,1,nargout);

use_tmw = getpref('SNCTOOLS','USE_TMW',false);
use_java = getpref('SNCTOOLS','USE_JAVA',false);
if ischar(arg1) && ~isempty(regexp(arg1,'\<http[s]*'))
	is_a_url = true;
else
	is_a_url = false;
end

%
% Use the proper version of nc_varget.
if use_java ...                                
	&& (isa(arg1,'ucar.nc2.NetcdfFile') || is_a_url)      
    dinfo = nc_getdiminfo_java(arg1,arg2);
elseif use_tmw
    dinfo = nc_getdiminfo_tmw(arg1,arg2);
else
    dinfo = nc_getdiminfo_mex(arg1,arg2);
end







%===============================================================================
function dinfo = nc_getdiminfo_java ( arg1, arg2 )

import ucar.nc2.dods.*  ;
import ucar.nc2.*       ;

if isa(arg1,'char') && isa(arg2,'char')
	if exist(arg1,'file')
		jncid = NetcdfFile.open(arg1);
	else
		jncid = DODSNetcdfFile(arg1);
	end
	dim = jncid.findDimension(arg2);
elseif isa(arg1,'ucar.nc2.NetcdfFile') && isa(arg2,'ucar.nc2.Dimension')
	jncid = arg1;
	dim = arg2;
elseif isa(arg1,'ucar.nc2.dods.DODSNetcdfFile') && isa(arg2,'ucar.nc2.Dimension')
	jncid = arg1;
	dim = arg2;
else
	eid = 'SNCTOOLS:nc_getdiminfo:java:badDatatypes';
	msg = sprintf ( 'For a java retrieval, datatypes must be either both char, or one must be a file ID and the other a dimension ID.' );
	error ( eid, msg );
end

dinfo.Name = char(dim.getName());
dinfo.Length = dim.getLength();
dinfo.Unlimited = dim.isUnlimited();

if isa(arg1,'char') && isa(arg2,'char')
	jncid.close();	
end

return

%===============================================================================
function dinfo = nc_getdiminfo_tmw ( arg1, arg2 )

%
% If we are here, then we must have been given something local.
if ischar(arg1) && ischar(arg2)
    dinfo = handle_char_nc_getdiminfo_tmw(arg1,arg2);

elseif isnumeric ( arg1 ) && isnumeric ( arg2 )
	dinfo = handle_numeric_nc_getdiminfo_tmw(arg1,arg2);
else
	error ( 'SNCTOOLS:NC_GETDIMINFO_TMW:badInputDatatypes', ...
	            'Must supply either two character or two numeric arguments.' );
end



return





%===============================================================================
function dinfo = nc_getdiminfo_mex ( arg1, arg2 )

%
% If we are here, then we must have been given something local.
if ischar(arg1) && ischar(arg2)
    dinfo = handle_char_nc_getdiminfo(arg1,arg2);
elseif isnumeric ( arg1 ) && isnumeric ( arg2 )
	dinfo = handle_numeric_nc_getdiminfo(arg1,arg2);
else
	error ( 'SNCTOOLS:NC_GETDIMINFO_MEX:badInputDatatypes', ...
	            'Must supply either two character or two numeric arguments.' );
end



return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dinfo = handle_char_nc_getdiminfo ( ncfile, dimname )

[ncid,status ]=mexnc('open', ncfile, nc_nowrite_mode );
if status ~= 0
	ncerror = mexnc ( 'strerror', status );
	error ( 'SNCTOOLS:NC_GETDIMINFO:handle_char_nc_getdiminfo:openFailed', ncerror );
end


[dimid, status] = mexnc('INQ_DIMID', ncid, dimname);
if ( status ~= 0 )
	mexnc('close',ncid);
	ncerror = mexnc ( 'strerror', status );
	error ( 'SNCTOOLS:NC_GETDIMINFO:handle_char_nc_getdiminfo:inq_dimidFailed', ncerror );
end


dinfo = handle_numeric_nc_getdiminfo ( ncid,  dimid );

mexnc('close',ncid);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dinfo = handle_numeric_nc_getdiminfo ( ncid, dimid )


[unlimdim, status] = mexnc ( 'inq_unlimdim', ncid );
if status ~= 0
	mexnc('close',ncid);
	ncerror = mexnc ( 'strerror', status );
	error ( 'SNCTOOLS:NC_GETDIMINFO:MEXNC:inq_ulimdimFailed', ncerror );
end



[dimname, dimlength, status] = mexnc('INQ_DIM', ncid, dimid);
if status ~= 0
	mexnc('close',ncid);
	ncerror = mexnc ( 'strerror', status );
	error ( 'SNCTOOLS:NC_GETDIMINFO:MEXNC:inq_dimFailed', ncerror );
end

dinfo.Name = dimname;
dinfo.Length = dimlength;

if dimid == unlimdim
	dinfo.Unlimited = true;
else
	dinfo.Unlimited = false;
end


return






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dinfo = handle_char_nc_getdiminfo_tmw ( ncfile, dimname )

ncid=netcdf.open(ncfile,nc_nowrite_mode);
dimid = netcdf.inqDimID(ncid, dimname);
dinfo = handle_numeric_nc_getdiminfo_tmw ( ncid,  dimid );
netcdf.close(ncid);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dinfo = handle_numeric_nc_getdiminfo_tmw ( ncid, dimid )


[dud,dud,dud,unlimdim] = netcdf.inq(ncid );
[dimname, dimlength] = netcdf.inqDim(ncid, dimid);


dinfo.Name = dimname;
dinfo.Length = dimlength;

if dimid == unlimdim
	dinfo.Unlimited = true;
else
	dinfo.Unlimited = false;
end


return
