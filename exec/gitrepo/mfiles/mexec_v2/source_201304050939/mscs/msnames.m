function matlist = msnames
% function matlist = msnames
%
% approximate triplets of mexec short names, rvs streams and scs streams 
% for JR195
% If called with no output arguments, list is printed to terminal.
%
% entries are
% mexec short name; rvs name; scs name

% JC032. If you need to add lines, that is harmless. If you need a whole
% new set of correspondences, retain this list but comment it out, and add
% your new list.

m_common

matlist = cell(0);

if strncmp(MEXEC_G.Mshipdatasystem,'scs',3)

matlist = {
        'anemometer'                  ' '                             'anemometer'
           'ashtech'                  ' '                                'ashtech'
        'dopplerlog'                  ' '                             'dopplerlog'
            'ea600m'                  ' '                                  'ea600'
%              'em120'                  ' '                                  'em120'
             'em122'                  ' '                                  'em122'  % bak on jr281, em122 instead of em120
         'emlog_vhw'                  ' '                              'emlog-vhw'
         'emlog_vlw'                  ' '                              'emlog-vlw'
        'furuno_gga'                  ' '                             'furuno-gga'
        'furuno_gll'                  ' '                             'furuno-gll'
        'furuno_rmc'                  ' '                             'furuno-rmc'
        'furuno_vtg'                  ' '                             'furuno-vtg'
        'furuno_zda'                  ' '                             'furuno-zda'
           'glonass'                  ' '                                'glonass'
            'gyro_s'                  ' '                                   'gyro'
        'netmonitor'                  ' '                             'netmonitor'
       'oceanlogger'                  ' '                            'oceanlogger'
            'seaspy'                  ' '                                 'seaspy'
        'seatex_gga'                  ' '                             'seatex-gga'
        'seatex_gll'                  ' '                             'seatex-gll'
        'seatex_hdt'                  ' '                             'seatex-hdt'
%        'seatex_psxn'                  ' '                            'seatex-psxn'  % format errors on seatex-psxn         
        'seatex_vtg'                  ' '                             'seatex-vtg'
        'seatex_zda'                  ' '                             'seatex-zda'
            'tsshrp'                  ' '                                 'tsshrp'
          'usbl_gga'                  ' '                               'usbl-gga' % added bak 27 march 2013 on jr281 for completeness. unlikely to be used
             'winch'                  ' '                                  'winch'
              'fake'                  ' '                                   'fake'    % for test purposes
             };

             
elseif strncmp(MEXEC_G.Mshipdatasystem,'techsas',7)

matlist = {
            'adupos'                  ' '                  'ADUPOS-ADUPOS_JC1.gps'
           'smartsv'            'smartsv'                          'AML-AMLSV.SVP'
           'gravity'            'gravity'                  'AirSeaII-S84_JC1.grav'
            'ea600m'             'ea600m'                  'EA600-EA600_JC1.EA600'
           'gyropmv'            'gyropmv'                 'GyroJC-GYRO1_JC1.gyrJC'
            'gyro_s'             'gyro_s'                 'GyroJC-SGYRO_JC1.gyrJC'
             'winch'              'winch'                 'JCWinch-CLAM_JC1.winch'
         'surflight'            'surfmet'              'Light-JC-SM_JC1.SURFMETv2'
           'surfmet'            'surfmet'                'MET-JC-SM_JC1.SURFMETv2'
             'SBE45'              'SBE45'                          'SBE-SBE45.TSG'
           'surftsg'            'surfmet'               'Surf-JC-SM_JC1.SURFMETv2'
           'adu5pat'            'adu5pat'                    'gppat-GPPAT_JC1.att'
          'posmvpos'           'posmvpos'          'position-Applanix_GPS_JC1.gps'
            'dps116'             'dps116'               'position-DPS-116_JC1.gps'
            'seapos'                  ' '            'position-Seapath200_JC1.gps'
            'usbpos'                  ' '                  'position-usbl_JC1.gps'
      'satinfoposmv'                  ' '     'satelliteinfo-Applanix_GPS_JC1.gps'
        'satinfodps'                  ' '          'satelliteinfo-DPS-116_JC1.gps'
        'satinfosea'                  ' '       'satelliteinfo-Seapath200_JC1.gps'
        'satinfousb'                  ' '             'satelliteinfo-usbl_JC1.gps'
               'mag'                  ' '              'scalar_mag-SeaSpy_JC1.mag'
          'posmvtss'           'posmvtss'       'shipattitude-Aplanix_TSS_JC1.att'
            'attsea'                  ' '      'shipattitude-Seapath200AT_JC1.att'
          'attposmv'                  ' '   'shipattitude_aux-Aplanix_TSS_JC1.att'
         'attseaaux'                  ' '  'shipattitude_aux-Seapath200AT_JC1.att'
          'log_skip'           'log_skip'                 'vdvhw-log_skip_JC1.log'
           'log_chf'            'log_chf'                  'vmvbw-log_chf_JC1.log'
           };

end

if nargout > 0; return; end

fprintf(1,'\n%20s %20s %45s\n\n',['mexec short name'],['rvs stream name'],['    scs stream name']);

for kstream = 1:size(matlist,1)
fprintf(1,'%20s %20s %45s\n',['''' matlist{kstream,1} ''''],['''' matlist{kstream,2} ''''],['''' matlist{kstream,3} '''']);
end