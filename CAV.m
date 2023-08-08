addpath 'C:\Users\dell\text2speech'
nhood = true(9);

nhood2 = ones(3);

vid = videoinput('winvideo', 1, 'YUY2_352x288', 'ReturnedColorSpace','rgb');

set(vid, 'TriggerRepeat', 100);

vid.FrameGrabInterval = 4;

vid_src = getselectedsource(vid);

set(vid_src, 'Tag', 'motion detection setup');

figure;

start(vid);

c = int8(0);

count = 0;

%count < 50
%vid.FramesAvailable >=0
while(vid.FramesAvailable >=0)
    
I = getdata(vid, 1);
    
I = flipdim(I,2);
    
Itemp=I;
    
I = rgb2gray(I);
    
I = imadjust(I);
    
I = imdilate(I,nhood2);
    
E2 = stdfilt(I,nhood);
    
E2im = mat2gray(E2);
    
BW2 = im2bw(E2im,graythresh(E2im));
    
mask2 = imopen(BW2,ones(3));
    
rgb = imfuse(Itemp, mask2);
    
    
i2 = mask2(60:288, 97:255);
    
i1 = mask2(60:288, 1:96);
    
i3 = mask2(60:288, 256:352);
    
    
s2 = sum(sum(i2));
    
s1 = sum(sum(i1));
    
s3 = sum(sum(i3));
    
    
if s2>=7000
        
c=c+1;   
    
end    
    
if c==10    
        
c=0;
        
tts('obstacle ahead');
        
        
if s3>=4000 && s1 >= 4000
            
tts('dead end') ;
        
else if s1<s3
            
tts('move left');
        
else 
           
tts('move right');
        
end
        
end
        
    
end    
    
    
imshow(rgb);
%Itemp,mask2,rgb
    
hold on
    
p1 = [60,97];
    
p2 = [288,97];
    
p3 = [288,255];
   
p4 = [60,255];
    
p5 = [60,0];
    
p6 = [60, 352];
    
plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',2)
    
plot([p1(2),p4(2)],[p1(1),p4(1)],'Color','r','LineWidth',2)
    
plot([p3(2),p4(2)],[p3(1),p4(1)],'Color','r','LineWidth',2)
    
plot([p5(2),p1(2)],[p5(1),p1(1)],'Color','r','LineWidth',2)
    
plot([p6(2),p4(2)],[p6(1),p4(1)],'Color','r','LineWidth',2)
    
    
count = count + 1;
    
if count==2
        
flushdata(vid);
        
count=0;
    
end    

end
stop(vid);