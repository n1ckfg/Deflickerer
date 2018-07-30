ArrayList<Float> brightnessList;
float brightnessAvg = 0;
AppState appState;
Settings settings;

void setup() {
  size(50,50,P2D);
  settings = new Settings("settings.txt");

  appState = AppState.BRIGHTNESS;
  fileSetup();
  setupShaders();
  
  brightnessList = new ArrayList<Float>();
}

void draw() {
  fileFirstRun();
  
  switch(appState) {
    case BRIGHTNESS:
      float avg = avgBrightness(img);
      println("brightness of image " + counter + " is " + avg);
      brightnessList.add(avg);
      counter++;
      if (counter > imgNames.size()-1) {
        for (int i=0; i<brightnessList.size(); i++) {
          brightnessAvg += brightnessList.get(i);
        }
        brightnessAvg /= (float) brightnessList.size();
        println("average brightness of scene is " + brightnessAvg);
        counter = 0;
        appState = AppState.RENDERING;
      } else {
        nextImage(counter);
      }
      break;
    case RENDERING:
      targetImg.beginDraw();
      //targetImg.image(exampleProcess(img),0,0);
      targetImg.image(img, 0, 0);
      float b = brightnessAvg / brightnessList.get(counter);
      shader.set("hsbc", 0.0, b, 0.5, 0.5);
      targetImg.filter(shader);
      targetImg.endDraw();
      fileLoop();
      break;
  }
}

float avgBrightness(PImage _img) {
  _img.loadPixels();
  int step = 5;
  float returns = 0;
  float counter = 0;
  PVector p = new PVector(0,0,0);
  for (int i=0; i<_img.pixels.length; i += step) {
    color c = _img.pixels[i];
    PVector col = new PVector(red(c)/255.0, green(c)/255.0, blue(c)/255.0);
    p.add(col);
    counter++;
  }
  PVector avg = p.div(counter);
  return (avg.x + avg.y + avg.z) / 3;  
}

PImage exampleProcess(PImage _img) {
  _img.loadPixels();
  for (int i=0; i<_img.pixels.length; i++) {
    float r = red(_img.pixels[int(random(100))]); 
    float g = green(_img.pixels[i]); 
    float b = blue(_img.pixels[i]); 
    
    r = abs(255 - r);
    g = abs(255 - g);
    b = abs(255 - b);
    
    color c = color(r,g,b);
    _img.pixels[i] = c;
  }
  _img.updatePixels();
  return _img;
}
