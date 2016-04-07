import java.util.List;

///////////////////////////////////////////////////////////////////////
//
//  Ray Tracing Shell
//
///////////////////////////////////////////////////////////////////////

PrintWriter output = createWriter("C:\\Users\\comfybunny\\Documents\\Ray Tracer\\ray_tracer\\debugger.txt");
boolean printer = false;
int debug_x = 190;
int debug_y = 149;

int screen_width = 300;
int screen_height = 300;
int timer = 0;
int refine = 1;
boolean refineBoolean = false;

// Some initializations for the scene.
Scene currentScene;
Surface currSurface;

void setup(){
  size (300, 300);  // use P3D environment so that matrix commands work properly
  noStroke();
  colorMode (RGB, 1.0);
  background (0, 0, 0);
  currentScene = new Scene();
  interpreter("t03.cli");
  
}

// Press key 1 to 9 and 0 to run different test cases.

void keyPressed() {
  switch(key){
    case '~':  background(0); currentScene = new Scene(); interpreter("rect_test.cli"); if(refineBoolean){refine = 8;}; break;
    case '1':  currentScene = new Scene(); interpreter("t01.cli"); if(refineBoolean){refine = 8;}; break;
    case '2':  currentScene = new Scene(); interpreter("t02.cli"); if(refineBoolean){refine = 8;}; break;
    case '3':  currentScene = new Scene(); interpreter("t03.cli"); if(refineBoolean){refine = 8;}; break;
    case '4':  currentScene = new Scene(); interpreter("t04.cli"); if(refineBoolean){refine = 8;}; break;
    case '5':  currentScene = new Scene(); interpreter("t05.cli"); if(refineBoolean){refine = 8;}; break;
    case '6':  currentScene = new Scene(); interpreter("t06.cli"); if(refineBoolean){refine = 8;}; break;
    case '7':  currentScene = new Scene(); interpreter("t07.cli"); if(refineBoolean){refine = 8;}; break;
    case '8':  currentScene = new Scene(); interpreter("t08.cli"); if(refineBoolean){refine = 8;}; break;
    case '9':  currentScene = new Scene(); interpreter("t09.cli"); if(refineBoolean){refine = 8;}; break;
    case '0':  currentScene = new Scene(); interpreter("t10.cli"); if(refineBoolean){refine = 8;}; break;
    case 's':  currentScene = new Scene(); interpreter("specular01.cli"); if(refineBoolean){refine = 8;}; break;
    case 'S':  currentScene = new Scene(); interpreter("specular02.cli"); if(refineBoolean){refine = 8;}; break;
    case 'q':  exit(); break;
    case 'd':  currentScene = new Scene(); interpreter("debug.cli"); if(refineBoolean){refine = 8;}; break;
    case 't':  currentScene = new Scene(); interpreter("test.cli"); if(refineBoolean){refine = 8;}; break;
  }
  if (key == 'r') {
    if(!refineBoolean){
      refine = 8;
    }
    else{
      refine = 1;
    }
    refineBoolean = !refineBoolean;
  }
}

//  Parser core. It parses the CLI file and processes it based on each 
//  token. Only "color", "rect", and "write" tokens are implemented. 
//  You should start from here and add more functionalities for your
//  ray tracer.

void interpreter(String filename) {
  
  String str[] = loadStrings(filename);
  if (str == null){
    println("Error! Failed to read the file.");
  }
  else{
    for (int i=0; i<str.length; i++) {
      
      String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
      
      if (token.length == 0) continue; // Skip blank line.
      
      else if (token[0].equals("fov")) {
        currentScene.setFOV(Float.parseFloat(token[1]));
      }
      else if(token[0].equals("lens")){
        currentScene.addLens(new Lens(Float.parseFloat(token[1]), Float.parseFloat(token[2])));
      }
      else if (token[0].equals("background")) {
        currentScene.setBackground(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3]));
      }
      else if (token[0].equals("point_light")) {
        currentScene.addLight(new Light(new Point(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3])), 
                                                  new Color(Float.parseFloat(token[4]),Float.parseFloat(token[5]),Float.parseFloat(token[6]))));
      }
      else if(token[0].equals("disk_light")){
        currentScene.addLight(new DiskLight(new Point(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3])), 
                                                  new Color(Float.parseFloat(token[8]),Float.parseFloat(token[9]),Float.parseFloat(token[10])),
                                                  Float.parseFloat(token[4]), new PVector(Float.parseFloat(token[5]),Float.parseFloat(token[6]),Float.parseFloat(token[7]))));
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
      }
      else if (token[0].equals("sphere")) {
        Point fileCenter = new Point(Float.parseFloat(token[2]), Float.parseFloat(token[3]), Float.parseFloat(token[4]));
        float fileRadius = Float.parseFloat(token[1]);
        float[] location = {fileCenter.getX(), fileCenter.getY(), fileCenter.getZ(), 1};
        //float[] surfacePoint = {fileCenter.getX(), fileCenter.getY()+fileRadius, fileCenter.getZ(), 1};
        //Point surfacePointCTM = new Point(currentScene.getMatrixStack().getCTM().vectorMultiply(surfacePoint));
        Point sphereCenterCTM = new Point(currentScene.getMatrixStack().getCTM().vectorMultiply(location));
        //Sphere newShape = new Sphere(surfacePointCTM.euclideanDistance(sphereCenterCTM)/fileRadius, sphereCenterCTM, currSurface);
        Sphere newShape = new Sphere(fileRadius, sphereCenterCTM, currSurface);
        
        currentScene.addShape(newShape);
      }
      else if(token[0].equals("moving_sphere")){
        Point fileCenter = new Point(Float.parseFloat(token[2]), Float.parseFloat(token[3]), Float.parseFloat(token[4]));
        float fileRadius = Float.parseFloat(token[1]);
        Point fileCenter2 = new Point(Float.parseFloat(token[5]), Float.parseFloat(token[6]), Float.parseFloat(token[7]));
        float[] location = {fileCenter.getX(), fileCenter.getY(), fileCenter.getZ(), 1};
        Point sphereCenterCTM = new Point(currentScene.getMatrixStack().getCTM().vectorMultiply(location));
        float[] location2 = {fileCenter2.getX(), fileCenter2.getY(), fileCenter2.getZ(), 1};
        Point sphereCenterCTM2 = new Point(currentScene.getMatrixStack().getCTM().vectorMultiply(location2));
        
        Sphere newShape = new MovingSphere(fileRadius, sphereCenterCTM, currSurface, sphereCenterCTM2);
        
        currentScene.addShape(newShape);
      }
      else if(token[0].equals("cylinder")){
        Cylinder newShape = new Cylinder(Float.parseFloat(token[1]), new Point(Float.parseFloat(token[2]), Float.parseFloat(token[4]), Float.parseFloat(token[3])), Float.parseFloat(token[5]), currSurface);
        currentScene.addShape(newShape);
      }
      else if(token[0].equals("box")){
        Box newShape = new Box(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3]), Float.parseFloat(token[4]), Float.parseFloat(token[5]), Float.parseFloat(token[6]), currSurface);
        currentScene.addShape(newShape);
      }
      
      else if(token[0].equals("named_object")){
        // remove last item from currentScene and move it to a global list for instancing
        Shape newInstance = currentScene.popLastShape();
        currentScene.add_named_object(token[1], newInstance);
      }
      else if(token[0].equals("instance")){
        currentScene.addShape(new Instance(currentScene.getInstance(token[1]),currentScene.getMatrixStack().getCTM()));
        //currentScene.getMatrixStack().getCTM().printDebug();
        //println(currentScene.getAllObjects().size());
      }
      else if(token[0].equals("push")){
        currentScene.getMatrixStack().push();
      }
      else if(token[0].equals("pop")){
        currentScene.getMatrixStack().pop();
      }
      else if(token[0].equals("translate")){
        currentScene.getMatrixStack().addTranslate(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3]));
      }
      else if(token[0].equals("scale")){
        currentScene.getMatrixStack().addScale(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3]));
      }
      else if(token[0].equals("rotate")){
        currentScene.getMatrixStack().addRotate(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3]), Float.parseFloat(token[4]));
      }
      
      else if (token[0].equals("begin")){
        //should be followed by vertex commands and terminated by an end
        ArrayList<Point> currVerticies = new ArrayList<Point>();
        String[] parser = splitTokens(str[i], " ");
        while(!parser[0].equals("end")){
          if(parser[0].equals("vertex")){
            float[] currVertex = {Float.parseFloat(parser[1]), Float.parseFloat(parser[2]), Float.parseFloat(parser[3]), 1};
            currVerticies.add(new Point(currentScene.getMatrixStack().getCTM().vectorMultiply(currVertex)));
          }
          i += 1;
          parser = splitTokens(str[i], " ");
        }
        if(parser[0].equals("end") && currVerticies.size()==3){
          currentScene.addShape(new Triangle(currVerticies.get(0), currVerticies.get(1), currVerticies.get(2), currSurface));
        }
        
      }
      
      else if(token[0].equals("begin_list")){
        currentScene.setListStartIndex(currentScene.numberOfObjects());
      }
      
      else if(token[0].equals("end_list")){
        ArrayList<Shape> shapeListObjects = new ArrayList<Shape>();
        ArrayList<Shape> allObjects = currentScene.getAllObjects();
        // List<Shape> shapeListObjects = currentScene.getAllObjects().subList(currentScene.getListStartIndex(), currentScene.numberOfObjects());
        int begin_list_index = currentScene.getListStartIndex();
        int end_list_index = currentScene.numberOfObjects();
        // Box box = new Box(allObjects.get(begin_list_index).minPoint());
        Box box = new Box(allObjects.get(begin_list_index).minPoint(), allObjects.get(begin_list_index).maxPoint());
        for(int currShapeIndex = begin_list_index; currShapeIndex < end_list_index; currShapeIndex++){
          box.includePoint(allObjects.get(begin_list_index).minPoint(), allObjects.get(begin_list_index).maxPoint());
          shapeListObjects.add(allObjects.get(begin_list_index));
          allObjects.remove(begin_list_index);
        }
        //currentScene.addShape(new ShapeList(shapeListObjects, new Box(-1.0,-0.988085,-3.776713, 1.0,0.988085,-2.223287)));
        currentScene.addShape(new ShapeList(shapeListObjects, box));
      }
      
      else if(token[0].equals("end_accel")){
        ArrayList<Shape> shapeListObjects = new ArrayList<Shape>();
        ArrayList<Shape> allObjects = currentScene.getAllObjects();
        int begin_list_index = currentScene.getListStartIndex();
        int end_list_index = currentScene.numberOfObjects();
        Box box = new Box(allObjects.get(begin_list_index).minPoint(), allObjects.get(begin_list_index).maxPoint(), currSurface);
        BVH bvh = new BVH(shapeListObjects, allObjects.get(begin_list_index).minPoint(), allObjects.get(begin_list_index).maxPoint());
        for(int currShapeIndex = begin_list_index; currShapeIndex < end_list_index; currShapeIndex++){
          box.includePoint(allObjects.get(begin_list_index).minPoint(), allObjects.get(begin_list_index).maxPoint());
          bvh.includePoint(allObjects.get(begin_list_index).minPoint(), allObjects.get(begin_list_index).maxPoint());
          shapeListObjects.add(allObjects.get(begin_list_index));
          allObjects.remove(begin_list_index);
        }
        //Grids grid = new Grids(shapeListObjects, box);
        
        bvh.balance(0);
        currentScene.addShape(bvh);
        
        //currentScene.addShape(grid);
        //println("add accel structure");
        /**
        bvh.balance();
        currentScene.addShape(bvh);
        
        
        **/
        println("yay?");
        int counter = 0;
        ArrayList<Shape> bfq = new ArrayList<Shape>();
        //BVH what = null;
        bfq.add(bvh);
        while(bfq.size() > 0){
          Shape temp = bfq.remove(0);
          //println(temp.getSize());
          if(!temp.getClass().equals(BVH.class)){
            counter += 1;
          }
          else{
            if(temp.getLeft()!=null){
              bfq.add(temp.getLeft());
            }
            if(temp.getRight()!=null){
              bfq.add(temp.getRight());
            }
          }
        }
        println("COUNTER: " + counter);
        
        //if(what != null){
        //  println("FOUND TRIANGLE");
        //  println(what.getBox().debug());
        //  while(what.getParentBVH()!=null){
        //    what = what.getParentBVH();
        //    println("PARENT TRIANGLE");
        //    println(what.getBox().debug());
        //  }
        //}
        
      }
      
      else if(token[0].equals("noise")){
        currSurface.setNoise(Integer.parseInt(token[1]));
        currSurface.setTexture(ProceduralTexture.NOISE);
      }
      
      else if(token[0].equals("wood")){
        currSurface.setTexture(ProceduralTexture.WOOD);
      }
      
      else if(token[0].equals("marble")){
        currSurface.setTexture(ProceduralTexture.MARBLE);
      }
      
      else if (token[0].equals("rays_per_pixel")){
        currentScene.setRaysPerPixel(Integer.parseInt(token[1]));
      }
      
      else if (token[0].equals("read")) {  // reads input from another file
        interpreter (token[1]);
      }
      else if (token[0].equals("reset_timer")) {
        timer = millis();
      }
      else if (token[0].equals("print_timer")) {
        int new_timer = millis();
        int diff = new_timer - timer;
        float seconds = diff / 1000.0;
        println ("timer = " + seconds);
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
        rayTrace();
        if(refine > 1 && refineBoolean){
          refine = refine/2;
        }
        save(token[1]);  
      }
    }
  }
}
public Color recursive(Ray ray, Shape lastHit, int x, int y){
  
  Color totalColor = new Color();
  
  ArrayList<Shape> allObjects = currentScene.getAllObjects();
  Point origin = ray.getOrigin();
  float minTime = MAX_FLOAT;
  
  IntersectionObject intersectionInfo = null;

  for(Shape a : allObjects){
    if(lastHit != a){
      IntersectionObject currIntersectionInfo = a.intersects(ray);
      if(currIntersectionInfo.getTime() >= 0 && currIntersectionInfo.getTime() <minTime){
        minTime = currIntersectionInfo.getTime();
        intersectionInfo = currIntersectionInfo;
      }
    }
  }
  printer = false;
  Shape firstShape;
  
  if(intersectionInfo!=null){
    if(x==151 && y==181){
      //println(intersectionInfo.getShape().getClass());
      //println(intersectionInfo.getShape().debug());
      //println(intersectionInfo.getIntersectionPoint().toString());
    }
    firstShape = intersectionInfo.getShape();
    Surface currentShapeSurface = firstShape.getSurface();
    Color diffuseColor = currentShapeSurface.getDiffuseColor();
    Color ambientColor = currentShapeSurface.getAmbientColor();
    Color tempSpecularColor = currentShapeSurface.getSpecularColor();
    if(lastHit == null){
      totalColor.add(ambientColor);
    }
    Point intersectionPoint = intersectionInfo.getIntersectionPoint();
    
    // Point intersectionPoint = ray.hitPoint(minTime);
    PVector firstShapeSurfaceNormal = intersectionInfo.getSurfaceNormal();
    firstShapeSurfaceNormal.div(firstShapeSurfaceNormal.mag());
    
    // if reflective then recurse
    if(firstShape.getSurface().getReflectiveCoefficient() > 0){
     PVector babyRay = intersectionPoint.subtract(origin);
     babyRay.div(babyRay.mag());
     babyRay.sub(PVector.mult(firstShapeSurfaceNormal,(2*(babyRay.dot(firstShapeSurfaceNormal)))));
     babyRay.div(babyRay.mag());
      
     Point newOrigin = new Point(intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ());
     newOrigin.movePoint(babyRay, 0.000001);
     Ray newRecurseRay = new Ray(newOrigin, babyRay);
     Color returnColor = recursive(newRecurseRay, firstShape, x, y);
     returnColor.multiply(firstShape.getSurface().getReflectiveCoefficient());
     totalColor.add(returnColor);
    }
      
    ArrayList<Light> lights = currentScene.getLights();
    // assuming no refraction for now
    for(Light light : lights){
      Ray lightRay = new Ray();
      Point lightLocation = light.getPoint();
      PVector shapeToLight = lightLocation.subtract(intersectionPoint);
      shapeToLight.div(shapeToLight.mag());
        
      PVector firstIntersectionToOrigin = origin.subtract(intersectionPoint);
      firstIntersectionToOrigin.div(firstIntersectionToOrigin.mag());
      
      float lightAndShapeNormalAlignment = firstShapeSurfaceNormal.dot(shapeToLight);
      if(lightAndShapeNormalAlignment < 0 && firstShape.getClass().equals(Triangle.class)){
        firstShapeSurfaceNormal = firstShapeSurfaceNormal.mult(-1);
        lightAndShapeNormalAlignment = firstShapeSurfaceNormal.dot(shapeToLight);
      }
      float diffuse = max(0, lightAndShapeNormalAlignment);
      Color diffuseSurfaceColor = new Color(diffuseColor.getR()*diffuse, diffuseColor.getG()*diffuse, diffuseColor.getB()*diffuse);
      
      if(firstShape.getSurface().getTexture() == ProceduralTexture.NOISE){
        float scalarNoise = firstShape.getSurface().getNoise();
        float noise = (1.0 + noise_3d(intersectionPoint.getX()*scalarNoise, intersectionPoint.getY()*scalarNoise, intersectionPoint.getZ()*scalarNoise))/2.0;
        diffuseSurfaceColor = new Color(diffuseSurfaceColor.getR()*noise, diffuseSurfaceColor.getG()*noise, diffuseSurfaceColor.getB()*noise);
      }
      else if(firstShape.getSurface().getTexture() == ProceduralTexture.WOOD){
        float _x = intersectionPoint.getX()*1.5*2;
        float _y = intersectionPoint.getY()*1.5*2;
        float _z = intersectionPoint.getZ()*1.5*2;

        float turbPow = 3.0;
        float turbSize = 8.0;
        
        float distVal = sqrt(_x*_x + _y*_y) + turbPow*turbulence(_x, _y, _z, turbSize)/256.0;
        float sinVal = 128.0*abs(sin(1.3*distVal*PI));
        diffuseSurfaceColor = new Color(diffuseSurfaceColor.getR()*(80 + sinVal)/255.0, diffuseSurfaceColor.getG()*(30 + sinVal)/255.0, diffuseSurfaceColor.getB()*(30)/255.0);
      }
      
      else if(firstShape.getSurface().getTexture() == ProceduralTexture.MARBLE){
        float _x = intersectionPoint.getX()*1.5*2;
        float _y = intersectionPoint.getY()*1.5*2;
        float _z = intersectionPoint.getZ()*1.5*2;
        
        float turb = 15.0; //makes twists
        float xyValue = x / 255.0 + y / 255.0 + (turb * turbulence(_x, _y, _z, 8.0)) / 255.0;
        float c = 90.0*abs(sin(xyValue*PI/2.0));
        //float c = 180.0*abs(sin(_x+turbulence(_x,_y,_z,30.0)));
        diffuseSurfaceColor = new Color(diffuseSurfaceColor.getR()*(100 + c)/255.0, diffuseSurfaceColor.getG()*(100 + c)/255.0, diffuseSurfaceColor.getB()*(100 + c)/255.0);
                
      }
      
      else if(firstShape.getSurface().getTexture() == ProceduralTexture.STONE){
      
      }
      
      // shading stuff below
      float distLightToBlocker = 0;
      float shadeTime = MAX_FLOAT;
      Shape shadeShapeIntersect = null;
      IntersectionObject shadeIntersection = null;
      lightRay.setDirection(shapeToLight);
      lightRay.setOrigin(intersectionPoint);
      lightRay.setOrigin(lightRay.hitPoint(0.0001));

      for(Shape b : allObjects){
        IntersectionObject currIntersectionInfo = b.intersects(lightRay);
        if(currIntersectionInfo.getTime() > 0 && currIntersectionInfo.getTime() < shadeTime && currIntersectionInfo.getShape()!=firstShape && currIntersectionInfo.getShape()!=null){
          shadeShapeIntersect = b;
          shadeTime = currIntersectionInfo.getTime();
          shadeIntersection = currIntersectionInfo;
        }
      }

      if(shadeIntersection != null){
        shadeShapeIntersect = shadeIntersection.getShape();
        if(shadeIntersection.getIntersectionPoint() != null){
          distLightToBlocker = shadeIntersection.getIntersectionPoint().euclideanDistance(lightLocation);
        }
      }
      if(tempSpecularColor!=null){
        Color specularColor = new Color(tempSpecularColor.getR(), tempSpecularColor.getG(), tempSpecularColor.getB());
        //println(currentShapeSurface.getSpecularHighlightExponent());
        PVector reflectedLightVector = new PVector(firstShapeSurfaceNormal.x, firstShapeSurfaceNormal.y, firstShapeSurfaceNormal.z);
        reflectedLightVector.mult(2.0*lightAndShapeNormalAlignment).sub(shapeToLight);
        float specular = max(0, firstIntersectionToOrigin.dot(reflectedLightVector));
        float specularPower = pow(specular, currentShapeSurface.getSpecularHighlightExponent());
        specularColor.multiply(specularPower);
        diffuseSurfaceColor.add(specularColor);
      }
      Color tempToAdd = diffuseSurfaceColor.product(light.getColor());
      
      if(intersectionPoint.euclideanDistance(lightLocation) < distLightToBlocker || shadeShapeIntersect == null){
         totalColor.add(tempToAdd);
       }
    }
    return totalColor;
    
  }
  else{
    return new Color(currentScene.getBackground().getR(), currentScene.getBackground().getG(), currentScene.getBackground().getB());
  }
  
}

void rayTrace(){
  loadPixels();
  Ray ray = new Ray();
  float k = tan(radians(currentScene.getFOV()/2.0));
  float half_x = k/width;
  float half_y = k/height;
  
  //for(int x = 50; x < 51; x+=refine){
    //println("PRE FOR LOOP: \t" + millis());
  for(int x = 0; x < width; x+=refine){
    float xPrime = ((2.0*k/width)*x)-k;
    for(int y = 0; y < height; y+=refine){
    //for(int y = 205; y < 206; y+=refine){
      Color totalColor = new Color();
      float yPrime = ((-2.0*k/height)*y)+k;
      
      Point origin = ray.getOrigin();
      float xlocation = xPrime + half_x;
      float ylocation = yPrime + half_y;
      Lens currLens = currentScene.getLens();
      
      if(currentScene.getRaysPerPixel() == 1){
        float rayMag = sqrt(sq(xlocation-origin.getX()) + sq(ylocation-origin.getY()) + 1);
        ray.setDirection((xlocation-origin.getX())/rayMag, (ylocation-origin.getY())/rayMag, -1/rayMag);
        // shoot from center
        // if lens do the following
        if(currLens != null){
          totalColor.add(recursive(currLens.randomRayOnLens(ray), null, x, y));
        }
        else{
          totalColor.add(recursive(ray, null, x, y));
        }
      }
      
      else{
        for(int multi_ray=0; multi_ray < currentScene.getRaysPerPixel(); multi_ray++){
          float randX = random(-1*half_x, half_x);
          float randY = random(-1*half_y, half_y);
          float rayMag = sqrt(sq(xlocation+randX-origin.getX()) + sq(ylocation+randY-origin.getY()) + 1);
          ray.setDirection((xlocation+randX-origin.getX())/rayMag, (ylocation+randY-origin.getY())/rayMag, -1/rayMag);
          if(currLens!=null){
            totalColor.add(recursive(currLens.randomRayOnLens(ray), null, x, y));
          }
          else{
            totalColor.add(recursive(ray, null, x, y));
          }
        }
      }
      
      totalColor.divide(currentScene.getRaysPerPixel());
      for(int i = x; i < x + refine; i++){
        for(int j = y; j< y + refine; j++){
          if(j*width+i < width*height){
            pixels[j*width+i] = color(totalColor.getR(), totalColor.getG(), totalColor.getB());
          }
        }
      }

    }
  }
  updatePixels();

}

void draw() {
}

// when mouse is pressed, print the cursor location
void mousePressed() {
  println ("mouse: " + mouseX + " " + mouseY);
}