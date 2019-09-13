function [  ] = clean_exit(function_name, message )
    disp(['------>ERROR IN FUNCTION: ' function_name]);
    disp(message);
    disp('Quit the program now?');                    
    disp('<a href="MATLAB: dbquit;">Yes</a> / <a href="MATLAB: dbcont;">No</a>');
    keyboard;
end

