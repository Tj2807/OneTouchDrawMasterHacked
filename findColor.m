function [ color ] = findColor( img_crop,pixelValue )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
pixelValue=floor(pixelValue);
red=img_crop(pixelValue(2),pixelValue(1),1);
green=img_crop(pixelValue(2),pixelValue(1),2);
blue=img_crop(pixelValue(2),pixelValue(1),3);

red_lb_yellow=200; red_ub_yellow=255;
green_lb_yellow=150; green_ub_yellow=210;
blue_lb_yellow=0; blue_ub_yellow=0;

red_lb_green=70; red_ub_green=100;
green_lb_green=190; green_ub_green=255;
blue_lb_green=70; blue_ub_green=100;

red_lb_green1=0; red_ub_green1=0;
green_lb_green1=255; green_ub_green1=255;
blue_lb_green1=90; blue_ub_green1=110;

red_lb_red=255; red_ub_red=255;
green_lb_red=95; green_ub_red=110;
blue_lb_red=140; blue_ub_red=165;

red_lb_blue=30; red_ub_blue=55;
green_lb_blue=150; green_ub_blue=230;
blue_lb_blue=150; blue_ub_blue=230;

if red>=red_lb_yellow && red<=red_ub_yellow && ...
   green>=green_lb_yellow && green<=green_ub_yellow && ...
   blue>=blue_lb_yellow && blue<=blue_ub_yellow
    color='y';
    
elseif red>=red_lb_red && red<=red_ub_red && ...
   green>=green_lb_red && green<=green_ub_red && ...
   blue>=blue_lb_red && blue<=blue_ub_red
    color='r';

elseif red>=red_lb_green && red<=red_ub_green && ...
   green>=green_lb_green && green<=green_ub_green && ...
   blue>=blue_lb_green && blue<=blue_ub_green
    color='g';
    
elseif red>=red_lb_green1 && red<=red_ub_green1 && ...
   green>=green_lb_green1 && green<=green_ub_green1 && ...
   blue>=blue_lb_green1 && blue<=blue_ub_green1
    color='g';
    
elseif red>=red_lb_blue && red<=red_ub_blue && ...
   green>=green_lb_blue && green<=green_ub_blue && ...
   blue>=blue_lb_blue && blue<=blue_ub_blue
    color='b';
    
else color='w';
end
    
end

