///////////////////////////////////////////////////////////////////////
//
//  Ray Tracing Shell
//
///////////////////////////////////////////////////////////////////////

int screen_width = 300;
int screen_height = 300;

int refine = 8;
String gCurrentFile = new String("rect_test.cli"); // A global variable for holding current active file name.

// global matrix values
//PMatrix3D global_mat;
//float[] gmat = new float[16];  // global matrix values

// Some initializations for the scene.
Scene currentScene;
Surface currSurface;

void setup(){
  size (300, 300);  // use P3D environment so that matrix commands work properly
  noStroke();
  colorMode (RGB, 1.0);
  background (0, 0, 0);
  currentScene = new Scene();
  
  // grab the global matrix values (to use later when drawing pixels)
  //PMatrix3D global_mat = (PMatrix3D) getMatrix();
  //global_mat.get(gmat);  
  //printMatrix();
  //resetMatrix();    // you may want to reset the matrix here

  interpreter();
}

// Press key 1 to 9 and 0 to run different test cases.

void keyPressed() {
  switch(key){
    case '~':  background(0); gCurrentFile = new String("rect_test.cli"); currentScene = new Scene(); interpreter(); break;
    case '1':  gCurrentFile = new String("t01.cli"); currentScene = new Scene(); interpreter(); break;
    case '2':  gCurrentFile = new String("t02.cli"); currentScene = new Scene(); interpreter(); break;
    case '3':  gCurrentFile = new String("t03.cli"); currentScene = new Scene(); interpreter(); break;
    case '4':  gCurrentFile = new String("t04.cli"); currentScene = new Scene(); interpreter(); break;
    case '5':  gCurrentFile = new String("t05.cli"); currentScene = new Scene(); interpreter(); break;
    case '6':  gCurrentFile = new String("t06.cli"); currentScene = new Scene(); interpreter(); break;
    case '7':  gCurrentFile = new String("t07.cli"); currentScene = new Scene(); interpreter(); break;
    case '8':  gCurrentFile = new String("t08.cli"); currentScene = new Scene(); interpreter(); break;
    case '9':  gCurrentFile = new String("t09.cli"); currentScene = new Scene(); interpreter(); break;
    case '0':  gCurrentFile = new String("t10.cli"); currentScene = new Scene(); interpreter(); break;
    case 's':  gCurrentFile = new String("specular01.cli"); currentScene = new Scene(); interpreter(); break;
    case 'S':  gCurrentFile = new String("specular02.cli"); currentScene = new Scene(); interpreter(); break;
    case 'q':  exit(); break;
  }
  if (key == 'r') {
    if(refine == 1){
      refine = 9;
    }
    else{
      refine = refine/2;
    }
  }
}

//  Parser core. It parses the CLI file and processes it based on each 
//  token. Only "color", "rect", and "write" tokens are implemented. 
//  You should start from here and add more functionalities for your
//  ray tracer.
//
//  Note: Function "splitToken()" is only available in processing 1.25 or higher.

void interpreter() {
  
  String str[] = loadStrings(gCurrentFile);
  if (str == null){
    println("Error! Failed to read the file.");
  }
  else{
    for (int i=0; i<str.length; i++) {
      
      String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
      if (token.length == 0) continue; // Skip blank line.
      
      if (token[0].equals("fov")) {
        currentScene.setFOV(Float.parseFloat(token[1]));
      }
      else if (token[0].equals("background")) {
        currentScene.setBackground(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3]));
      }
      else if (token[0].equals("point_light")) {
        currentScene.addPointLight(new PointLight(new Point(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3])), 
                                                  new Color(Float.parseFloat(token[4]),Float.parseFloat(token[5]),Float.parseFloat(token[6]))));
      }
      else if (token[0].equals("diffuse")) {
        currSurface = new Surface(new Color(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3])), 
                                  new Color(Float.parseFloat(token[4]), Float.parseFloat(token[5]), Float.parseFloat(token[6])));
      }
      else if (token[0].equals("shiny")) {
        currSurface = new Surface(new Color(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3])), 
                                  new Color(Float.parseFloat(token[4]), Float.parseFloat(token[5]), Float.parseFloat(token[6])),
                                  new Color(Float.parseFloat(token[7]), Float.parseFloat(token[8]), Float.parseFloat(token[9])),
                                  Float.parseFloat(token[10]), Float.parseFloat(token[11]), Float.parseFloat(token[12]), Float.parseFloat(token[13]));
        //println(currSurface.getSpecularColor().toString());
      }
      else if (token[0].equals("sphere")) {
        Sphere newShape = new Sphere(Float.parseFloat(token[1]), new Point(Float.parseFloat(token[2]), Float.parseFloat(token[3]), Float.parseFloat(token[4])), currSurface);
        currentScene.addShape(newShape);
        //println(currentScene.getAllObjects().get(0).getSurface().getSpecularColor().toString());
      }
      else if (token[0].equals("read")) {  // reads input from another file
        gCurrentFile = new String(token[1]); interpreter(); currentScene = new Scene(); break;
      }
      else if (token[0].equals("color")) {  // example command -- not part of ray tracer
       float r = float(token[1]);
       float g = float(token[2]);
       float b = float(token[3]);
       fill(r, g, b);
      }
      else if (token[0].equals("rect")) {  // example command -- not part of ray tracer
       float x0 = float(token[1]);
       float y0 = float(token[2]);
       float x1 = float(token[3]);
       float y1 = float(token[4]);
       rect(x0, screen_height-y1, x1-x0, y1-y0);
      }
      else if (token[0].equals("write")) {
        // save the current image to a .png file
        save(token[1]);  
      }
    }
  }
}

void rayTrace(){
  //println(currSurface.getSpecularColor().toString());
  loadPixels();
  Ray ray = new Ray();
  Color backgroundColor = currentScene.getBackground();
  //println(currentScene.getFOV());
  float k = tan(radians(currentScene.getFOV()/2.0));
  ArrayList<Shape> allObjects = currentScene.getAllObjects();
  //println(allObjects.get(0).getSurface().getSpecularColor().toString());
  for(int x = 0; x < width; x+=refine){
    float xPrime = ((2.0*k/width)*x)-k;
    for(int y = 0; y < height; y+=refine){
      Color totalColor = new Color();
      float yPrime = ((-2.0*k/height)*y)+k;
      Point origin = ray.getOrigin();
      float rayMag = sqrt(sq(xPrime-origin.getX()) + sq(yPrime-origin.getY()) + 1);
      ray.setDirection((xPrime-origin.getX())/rayMag, (yPrime-origin.getY())/rayMag, -1/rayMag);      
      float minTime = MAX_FLOAT;
      Shape firstShape = null;
      for(Shape a : allObjects){
        float currTime = a.intersects(ray);
        if(currTime > 0 && currTime <minTime){
          minTime = currTime;
          firstShape = a;
        }
      }
      if(minTime < MAX_FLOAT && firstShape!=null){
        Surface currentShapeSurface = firstShape.getSurface();
        Color diffuseColor = currentShapeSurface.getDiffuseColor();
        Color ambientColor = currentShapeSurface.getAmbientColor();
        Color tempSpecularColor = currentShapeSurface.getSpecularColor();
        
        //println(specularColor.toString());
        totalColor.add(ambientColor);
        ArrayList<PointLight> pointLights = currentScene.getPointLights();
        Point intersectionPoint = firstShape.hitPoint(ray, minTime);
        for(PointLight light : pointLights){
          Point lightLocation = light.getPoint();
          PVector shapeToLight = lightLocation.subtract(intersectionPoint);
          float shapeToLightMag = shapeToLight.mag();
          shapeToLight.div(shapeToLightMag);
          
          PVector firstShapeSurfaceNormal = firstShape.shapeNormal(intersectionPoint);
          PVector firstIntersectionToOrigin = origin.subtract(intersectionPoint);
          firstIntersectionToOrigin.div(firstIntersectionToOrigin.mag());
          
          float lightAndShapeNormalAlignment = firstShapeSurfaceNormal.dot(shapeToLight);
          float diffuse = max(0, lightAndShapeNormalAlignment);

          Color diffuseSurfaceColor = new Color(diffuseColor.getR()*diffuse, diffuseColor.getG()*diffuse, diffuseColor.getB()*diffuse);
          
          if(tempSpecularColor!=null){
            Color specularColor = new Color(tempSpecularColor.getR(), tempSpecularColor.getG(), tempSpecularColor.getB());
            //println(currentShapeSurface.getSpecularHighlightExponent());
            PVector reflectedLightVector = new PVector(firstShapeSurfaceNormal.x, firstShapeSurfaceNormal.y, firstShapeSurfaceNormal.z);
            reflectedLightVector.mult(2.0*lightAndShapeNormalAlignment).sub(shapeToLight);
            float specular = max(0, firstIntersectionToOrigin.dot(reflectedLightVector));  //TODO FIX THIS
            float specularPower = pow(specular, currentShapeSurface.getSpecularHighlightExponent());
            specularColor.multiply(specularPower);
            diffuseSurfaceColor.add(specularColor);
          }
          totalColor.add(diffuseSurfaceColor.dotProduct(light.getColor()));
        }
        for(int i = x; i < x + refine; i++){
          for(int j = y; j< y + refine; j++){
            if(j*width+i < width*height){
              pixels[j*width+i] = color(totalColor.getR(), totalColor.getG(), totalColor.getB());
            }
          }
        }
        
        //println(totalColor.toString());
        //println("X: " + x + "\tY: " + y +"\tX': " + xPrime + "\tY': " + yPrime + "\tMag: " + rayMag);  
      }
      else{
        for(int i = x; i < x + refine; i++){
          for(int j = y; j < y + refine; j++){
            if(j*width+i < width*height){
              pixels[j*width+i] = color(backgroundColor.getR(), backgroundColor.getG(), backgroundColor.getB());
            }
          }
        }
      }
      
    }
  }
  updatePixels();
}

void draw() {
  if(!gCurrentFile.equals("rect_test.cli")){
    rayTrace();
  }
}

// when mouse is pressed, print the cursor location
void mousePressed() {
  println ("mouse: " + mouseX + " " + mouseY);
}