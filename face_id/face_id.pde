import gohai.glvideo.*;
GLCapture video;

int dfilenum = 0;
float matchP = 0;
int[] white_pixel;
int[] dbWhitePixel;
boolean pass = false;
boolean compare = false;
PImage compareBW;

PrintWriter output;

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
  //BufferedReader reader = createReader("dfilenum.txt");
  //String line = null;
  // try{
  //  while((line = reader.readLine()) != null){
  //    String[] pieces = split(line, TAB);
  //    int num = int(pieces[0]);
  //    dfilenum = num;
  //  }
  //  reader.close();
  //}
  //catch (IOException e){
  //  output = createWriter("dfilenum.txt");
  //  output.println(dfilenum);
  //  output.close();
  //}
  //println(dfilenum);
}
void keyPressed(){
  if(key == 'r' || key == 'R'){
    compare = true;
    pass = false;
  }
  if(key == 's' || key == 'S'){
    PImage center = get(221,116,200,250);
    blackwhite(center);
    compareBW.save("Image"+dfilenum+".jpg");
    calculateImage(compareBW);
    saveImageData();
    dfilenum++;
  }
  if(key == ' '){
    PImage center = get(221,116,200,250);
    blackwhite(center);
    calculateImage(compareBW);
    compareBW.save("Compare0.jpg");
    compare = false;
    for(int num = 0; num<dfilenum;num++){
      readImageData(num);
      compareImageData();
      println("-----------");
      println(num);
      println(matchP);
      println("-----------");
      if(matchP >= 20){
        pass = false;
      }
      else if(matchP < 20){
        pass = true;
        break;
      } 
    }
  }
  if(key == 'q' || key == 'Q'){
    //output = createWriter("dfilenum.txt");
    //output.println(dfilenum);
    //output.close();
    for(int num = 0; num<dfilenum;num++){
      String filename = sketchPath("Image"+num+".txt");
      String imagename = sketchPath("Image"+num+".jpg");
      File f = new File(filename);
      File image = new File(imagename);
      if(f.exists()){
        f.delete();
      }
      if(image.exists()){
        image.delete();
      }
    }
    String filename = sketchPath("Compare0.jpg");
    File f = new File(filename);
    if(f.exists()){
        f.delete();
      }
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
    rect(220,115,201,250);
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

void calculateImage(PImage image){
  color white = color(255);
  int numWhite;
  image.loadPixels();
  white_pixel = new int[image.height];
  for(int y = 0; y < image.height; y++){
    numWhite = 0;
    for(int x = 0; x <image.width; x++){
      int loc = x + y * image.width;
      color pixel = image.pixels[loc];
      if(pixel == white){
        numWhite++;
      }
    }
    white_pixel[y] = numWhite;
  }
}

void readImageData(int dfile){
  BufferedReader reader = createReader("Image"+dfile+".txt");
  String line = null;
  dbWhitePixel = new int[250];
  int i = 0;
  try{
    while((line = reader.readLine()) != null){
      String[] pieces = split(line, TAB);
      int num = int(pieces[0]);
      dbWhitePixel[i] = num;
      i++;
    }
    reader.close();
  }
  catch (IOException e){
    e.printStackTrace();
  }
}

void saveImageData(){
  output = createWriter("Image"+dfilenum+".txt");
  for(int i = 0; i < white_pixel.length; i++){
    output.println(white_pixel[i]);
  }
  output.close();
}

void compareImageData(){
  float cValue = 0;
  float dValue = 0;
  float absV;
  for(int i = 0; i <white_pixel.length; i++){
    cValue += white_pixel[i];
    dValue += dbWhitePixel[i];
  }
  absV = abs(dValue-cValue);
  matchP = (absV/dValue)*100;
  println(cValue);
  println(dValue);
  //println(matchP);
}

void blackwhite(PImage source){
  float threshold = 160;
  compareBW = source;
  compareBW.loadPixels();
  for (int x = 0; x < compareBW.width; x++ ) {
    for (int y = 0; y < compareBW.height; y++ ) {
      int loc = x + y*compareBW.width;
      // Test the brightness against the threshold
      if (brightness(compareBW.pixels[loc]) > threshold){
        compareBW.pixels[loc] = color(255); // White
      } else {
        compareBW.pixels[loc] = color(0);   // Black
      }
    }
  }  
  // We changed the pixels in destination 
  compareBW.updatePixels();
}