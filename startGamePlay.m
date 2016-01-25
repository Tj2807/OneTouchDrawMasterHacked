%This code is Written by Tejas S. Niphadkar.
%The code is openSource and can be used in any project directly
%without any prior permission.

while true
    clear all % Clear all the variables.
    close all % Close all the open Figures.
    clc %Clear Command Window.
    
    %Capture a Screenshot and store it to folder on sdcard.
    system('adb shell screencap -p /sdcard/oneTouchImages/img.png');
    
    %Pull the Image file to laptop in folder same as adb.exe
    system('adb pull /sdcard/oneTouchImages/img.png');
    
    %Now that image is captured, call the OneTouchDraw for image
    %processing.
    OneTouchDraw
    
    %Remove the image stored on SdCard.
    system('adb shell rm /sdcard/oneTouchImages/img.png');
    
    %Remove the image stored in current directory.
    delete('img.png');
    
end


