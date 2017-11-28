import gohai.glvideo.*;
GLCapture video;

boolean pass = false;
boolean compare = false;

void setup(){
  size(640,480,P2D);
  String[] devices= GLCapture.list();
  compare = true;
  println("Devices:");
  printArray(devices);
  if(0 < devices.length){
    String[] configs = GLCapture.configs(devices[0]);
    println("Configs:");
    printArray(configs);
  }
  else{
    println("No Devices found, please restart");
    exit();
  }
  video = new GLCapture(this,devices[0],640,480,30);
  println(video);
  video.start();
}
void keyPressed(){
  if(key == 'r' || key == 'R'){
    compare = true;
    pass = false;
  }
  if(key == 's' || key == 'S'){
    PImage cameraP = get(221,116,199,249);
    cameraP.save("save.jpg");
  }
  if(key == ' '){
    PImage center = get(221,116,199,249);
    center.save("compare.jpg");
    compare = false;
    pass = false;
  }
  if(key == 'q' || key == 'Q'){
    exit();
  }
}
void draw(){
  if(compare == true){
    background(0);
    if(video.available()){
      video.read();
    }
    image(video,0,0,width,height);
    //rectMode(CENTER);
    stroke(204,102,0);
    noFill();
    rect(220,115,200,250);
    //text("x: "+mouseX + "y: "+mouseY,mouseX,mouseY);
  }
  else if (compare == false && pass == false){
    if(video.available()){
      video.read();
    }
    image(video,0,0,width,height);
    fill(255,0,0);
    stroke(204,102,0);
    rect(220,115,150,100);
    fill(0);
    textSize(32);
    text("DENIED",240,180);
  }
  else if (compare == false && pass == true){
    if(video.available()){
      video.read();
    }
    image(video,0,0,width,height);
    fill(0,255,0);
    stroke(204,102,0);
    rect(220,115,150,100);
    fill(0);
    textSize(32);
    text("PASS",260,180);
  }
}