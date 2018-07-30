PShader shader; 
//PImage rgbImg, depthImg;

PVector shaderMousePos = new PVector(0,0);
PVector shaderMouseClick = new PVector(0,0);

void setupShaders() {
  shader = loadShader("hsbc.glsl"); 
  shaderSetSize(shader);
  float h = 0.0; // hue 0-1, default 0.0
  float s = 1.0; // saturation 0-1, default 1.0
  float b = 0.5; // brightness 0-1, default 0.5
  float c = 0.5; // contrast 0-1, default 0.5
  shader.set("hsbc", h, b, c, s);
}

void updateShaders() {
  //shaderSetMouse(shader);
  //shaderSetTime(shader);
  shaderSetTexture(shader, "texture", img);
}

void drawShaders() {
  filter(shader);
}

// ~ ~ ~ ~ ~ ~ ~

void shaderSetSize(PShader ps) {
  ps.set("iResolution", float(width), float(height), 1.0);
}

void shaderSetMouse(PShader ps) {
  if (mousePressed) shaderMousePos = new PVector(mouseX, height - mouseY);
  ps.set("iMouse", shaderMousePos.x, shaderMousePos.y, shaderMouseClick.x, shaderMouseClick.y);
}

void shaderSetTime(PShader ps) {
  ps.set("iGlobalTime", float(millis()) / 1000.0);
}

void shaderMousePressed() {
  shaderMouseClick = new PVector(mouseX, height - mouseY);
}

void shaderMouseReleased() {
  shaderMouseClick = new PVector(-shaderMouseClick.x, -shaderMouseClick.y);
}

void shaderSetTexture(PShader ps, String name, PImage tex) {
  ps.set(name, tex);
}
