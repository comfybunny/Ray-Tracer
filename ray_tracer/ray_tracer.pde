import java.util.List;

///////////////////////////////////////////////////////////////////////
//
//  Ray Tracing Shell
//
///////////////////////////////////////////////////////////////////////
Color diffuseSurfaceColor;
float[] distribution = new float[10];

PrintWriter output = createWriter("C:\\Users\\comfybunny\\Documents\\Ray Tracer\\ray_tracer\\debugger.txt");
boolean printer = false;
int debug_x = 190;
int debug_y = 149;


int timer = 0;
int refine = 1;
boolean refineBoolean = false;

int screen_width = 850;
int screen_height = 850;

// debug drawing stuff
//int num_photons = 8000;    // number of photons to draw (small number)
//float photon_radius = 8;   // drawing of photons

int num_photons = 400000;   // number of photons to draw (large number)
float photon_radius = 2;    // drawing of photons

float old_mouseX,old_mouseY;
boolean first_draw = true;

kd_tree photons;


// Some initializations for the scene.
Scene currentScene;
Surface currSurface;

void setup(){
  size (600, 600);  // use P3D environment so that matrix commands work properly
  noStroke();
  colorMode (RGB, 1.0);
  background (0, 0, 0);
  currentScene = new Scene();
  randomSeed(1234);
  interpreter("t10.cli");
    
  // initialize kd-tree
  photons = new kd_tree();

  
  int i;
  
  // initialize kd-tree
  photons = new kd_tree();
  
  // create random list of "photons"
  //for (i = 0; i < num_photons; i++) {
  //  float x,y;
  //  // pick random positions, with variable density in x
  //  do {
  //    x = random (0.0, screen_width);
  //    y = random (0.0, screen_height);
  //  } while (x > random (0.0, screen_width));
  //  float z = 0.0;
  //  Photon p = new Photon (x, y, z);
  //  photons.add_photon (p);
  //}
  
  //// build the kd-tree
  //photons.build_tree();
  //println ("finished building tree");
  
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
      else if(token[0].equals("reflective")){
        currSurface = new Surface(new Color(Float.parseFloat(token[1]), Float.parseFloat(token[2]), Float.parseFloat(token[3])), 
                                  new Color(Float.parseFloat(token[4]), Float.parseFloat(token[5]), Float.parseFloat(token[6])), Float.parseFloat(token[7]));
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
      
      else if(token[0].equals("hollow_cylinder")){
        Hollow_Cylinder newShape = new Hollow_Cylinder(Float.parseFloat(token[1]), new Point(Float.parseFloat(token[2]), Float.parseFloat(token[4]), Float.parseFloat(token[3])), Float.parseFloat(token[5]), currSurface);
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
      
      else if(token[0].equals("stone")){
        currSurface.setTexture(ProceduralTexture.STONE);

      }
      
      else if (token[0].equals("rays_per_pixel")){
        currentScene.setRaysPerPixel(Integer.parseInt(token[1]));
      }
      
      else if(token[0].equals("caustic_photons")){
        currentScene.causticTrue(Integer.parseInt(token[1]), Integer.parseInt(token[2]), Float.parseFloat(token[3]));
      }
      else if(token[0].equals("diffuse_photons")){
        currentScene.diffuseTrue(Integer.parseInt(token[1]), Integer.parseInt(token[2]), Float.parseFloat(token[3]));
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
        if(currentScene.caustic){
          photons = new kd_tree();
          float rand_x;
          float rand_y;
          float rand_z;
          Point lightLocation = currentScene.getLights().get(0).getPoint();
          Color lightColor = currentScene.getLights().get(0).getColor();
          Ray ray = new Ray(lightLocation);
          for(int emitted=0; emitted < currentScene.num_cast; emitted++){
            rand_x = random(2)-1.0;
            rand_y = random(2)-1.0;
            rand_z = random(2)-1.0;
            while((rand_x*rand_x + rand_y*rand_y + rand_z*rand_z) > 1){
              rand_x = random(2)-1.0;
              rand_y = random(2)-1.0;
              rand_z = random(2)-1.0;
            }
            ray.setDirection(rand_x, rand_y, rand_z);
            shootPhoton(false, ray, lightColor.getR()*10, lightColor.getG()*10, lightColor.getB()*10);
          }
          photons.build_tree();
          println("caustic tree built");
          println(currentScene.num_cast);
        }
        else if(currentScene.diffuse){
          photons = new kd_tree();
          float rand_x;
          float rand_y;
          float rand_z;
          Point lightLocation = currentScene.getLights().get(0).getPoint();
          Color lightColor = currentScene.getLights().get(0).getColor();
          Ray ray = new Ray(lightLocation);
          for(int emitted=0; emitted < currentScene.num_cast; emitted++){
            //println("emitted photon number:\t" + emitted);
            rand_x = random(2)-1.0;
            rand_y = random(2)-1.0;
            rand_z = random(2)-1.0;
            while((rand_x*rand_x + rand_y*rand_y + rand_z*rand_z) > 1){
              rand_x = random(2)-1.0;
              rand_y = random(2)-1.0;
              rand_z = random(2)-1.0;
            }
            ray.setDirection(rand_x, rand_y, rand_z);
            try{
            shootDiffusePhoton(0, ray, lightColor.getR()*4, lightColor.getG()*4, lightColor.getB()*4);
            }
            catch(StackOverflowError e){
            }
          }
          photons.build_tree();
          println("diffuse tree built");
          println(currentScene.num_cast);
        }
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
    
    firstShape = intersectionInfo.getShape();
    Surface currentShapeSurface = firstShape.getSurface();
    Color diffuseColor = currentShapeSurface.getDiffuseColor();
    Color ambientColor = currentShapeSurface.getAmbientColor();
    Color tempSpecularColor = currentShapeSurface.getSpecularColor();
    if(firstShape.getSurface().getReflectiveCoefficient()==0){
      
    }
    totalColor.add(ambientColor);
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
      float eyenormal = firstShapeSurfaceNormal.dot(ray.getDirection());
      if(eyenormal > 0 && firstShape.getClass().equals(Triangle.class)){
        firstShapeSurfaceNormal = firstShapeSurfaceNormal.mult(-1);
        lightAndShapeNormalAlignment = firstShapeSurfaceNormal.dot(shapeToLight);
      }
      if(eyenormal > 0 && firstShape.getClass().equals(Hollow_Cylinder.class)){
        firstShapeSurfaceNormal = firstShapeSurfaceNormal.mult(-1);
        lightAndShapeNormalAlignment = firstShapeSurfaceNormal.dot(shapeToLight);
      }
      float diffuse = max(0, lightAndShapeNormalAlignment);
      diffuseSurfaceColor = new Color(diffuseColor.getR()*diffuse, diffuseColor.getG()*diffuse, diffuseColor.getB()*diffuse);
      
      if(firstShape.getSurface().getTexture() == ProceduralTexture.NOISE){
        float scalarNoise = firstShape.getSurface().getNoise();
        float noise = (1.0 + noise_3d(intersectionPoint.getX()*scalarNoise, intersectionPoint.getY()*scalarNoise, intersectionPoint.getZ()*scalarNoise))/2.0;
        diffuseSurfaceColor = new Color(diffuseSurfaceColor.getR()*noise, diffuseSurfaceColor.getG()*noise, diffuseSurfaceColor.getB()*noise);
      }
      else if(firstShape.getSurface().getTexture() == ProceduralTexture.WOOD){
        float _x = intersectionPoint.getX()*1.5*2;
        float _y = intersectionPoint.getY()*1.5*2;
        float _z = intersectionPoint.getZ()*1.5*2;

        float distVal = sqrt(_x*_x + _y*_y) + 3.0*wood(_x, _y, _z, 8.0)/256.0;
        float sinVal = 128.0*abs(sin(1.3*distVal*PI));
        diffuseSurfaceColor = new Color(diffuseSurfaceColor.getR()*(80 + sinVal)/255.0, diffuseSurfaceColor.getG()*(30 + sinVal)/255.0, diffuseSurfaceColor.getB()*(30)/255.0);
      }
      
      else if(firstShape.getSurface().getTexture() == ProceduralTexture.MARBLE){
        float _x = intersectionPoint.getX()*1.5*2;
        float _y = intersectionPoint.getY()*1.5*2;
        float _z = intersectionPoint.getZ()*1.5*2;
        
        float c = abs(sin(_x + turbulence(_x, _y, _z, 32.0)))*255;
        diffuseSurfaceColor = new Color(diffuseSurfaceColor.getR()*(50 + c)/255.0, diffuseSurfaceColor.getG()*(50 + c)/255.0, diffuseSurfaceColor.getB()*(50 + c)/255.0);
      }
      
      else if(firstShape.getSurface().getTexture() == ProceduralTexture.STONE){
        float _x = intersectionPoint.getX();
        float _y = intersectionPoint.getY();
        float _z = intersectionPoint.getZ();
        
        int floor_x = floor(_x);
        int floor_y = floor(_y);
        int floor_z = floor(_z);
        
        float k = 4; // average number features per cell
        
        // Find the feature point closest to the evaluation point
        float closest_distance = Float.POSITIVE_INFINITY;
        float f2 = Float.POSITIVE_INFINITY;
        Color closest_color = new Color();
        // check all neighboring cells
        for (int xx = -1; xx <= 1; xx++){
          for (int yy = -1; yy <=1; yy++){
            for (int zz = -1; zz <=1; zz++){
              int poor_hash = 541*(floor_x+xx) + 79*(floor_y+yy) + 31*(floor_z+zz);
              randomSeed(poor_hash);
              int feature_count = 0;
              float cumulative_prob = 0;
              float feature_probability = random(1);
              while(feature_probability > cumulative_prob){
                cumulative_prob+=pow(k,feature_count)/(float)((pow((float)Math.E,k)*factorial(feature_count)));
                feature_count += 1;
              }
              for(int aa=0; aa<=feature_count; aa++){
                Color temp_color = new Color(random(.3), random(.3), random(.3));
                temp_color = new Color(random(.3), random(.3), random(.3));
                Point currPoint = new Point(floor_x + xx + random(1), floor_y + yy + random(1), floor_z + zz + random(1));
                
                float currDist = pow((currPoint.getX()-(_x)),2) + pow((currPoint.getY()-(_y)),2) + pow((currPoint.getZ()-(_z)),2);
                if(currDist < closest_distance){
                  f2 = closest_distance;
                  closest_distance = currDist;
                  closest_color = temp_color;
                }
              }
            }
          }
        }
        float scalarNoise = 5;
        float noise = (((1.0 + noise_3d(intersectionPoint.getX()*scalarNoise, intersectionPoint.getY()*scalarNoise, intersectionPoint.getZ()*scalarNoise))/2.0)*0.2);
        
        float crack_noise_scalar = 50;
        float crack_noise = (((1.0 + noise_3d(intersectionPoint.getX()*crack_noise_scalar, intersectionPoint.getY()*crack_noise_scalar, intersectionPoint.getZ()*crack_noise_scalar))/2.0)*0.2);
        
        if(abs(f2-closest_distance) < 0.05){
          diffuseSurfaceColor = new Color(diffuseSurfaceColor.getR()*(0.5+crack_noise),diffuseSurfaceColor.getG()*(0.5+crack_noise),diffuseSurfaceColor.getB()*(0.5+crack_noise));
        }
        else{
          diffuseSurfaceColor = new Color(diffuseSurfaceColor.getR()*(.7+closest_color.getR()+noise), diffuseSurfaceColor.getG()*(.4+closest_color.getG()+noise), diffuseSurfaceColor.getB()*(.4+closest_color.getB()+noise));
        }
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
        if(currIntersectionInfo.getTime() > 0 && currIntersectionInfo.getTime() < shadeTime && currIntersectionInfo.getShape()!=null && currIntersectionInfo.getShape()!=firstShape){
          shadeShapeIntersect = b;
          shadeTime = currIntersectionInfo.getTime();
          shadeIntersection = currIntersectionInfo;
        }
      }

      if(shadeIntersection != null){
        shadeShapeIntersect = shadeIntersection.getShape();
        if(shadeIntersection.getIntersectionPoint() != null){
          distLightToBlocker = shadeIntersection.getIntersectionPoint().euclideanDistance(intersectionPoint);
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
   
    if(currentScene.caustic){
     ArrayList<Photon> plist = photons.find_near(intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ(), currentScene.num_near, currentScene.max_near_dist);
     float max_r = 0;
     float flux = 0;
     if(plist != null){
       for(Photon p : plist){
         if(p!=null){
           flux+=abs(p.power_r);
           float curr_dist = sqrt((pow(intersectionPoint.getX()-p.pos[0],2))+(pow(intersectionPoint.getY()-p.pos[1],2))+(pow(intersectionPoint.getZ()-p.pos[2],2)));
           if(curr_dist > max_r){
             max_r = curr_dist;
           }
         }
       }
       float irradiance = flux/(2*(float)Math.PI*max_r*max_r);
       if(max_r!=0){
         totalColor.add(new Color(irradiance*10, irradiance*10, irradiance*10));
       }
     }
    }
    else if(currentScene.diffuse){
     ArrayList<Photon> plist = photons.find_near(intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ(), currentScene.num_near, currentScene.max_near_dist);
     float max_r = 0;
     float flux_r = 0;
     float flux_g = 0;
     float flux_b = 0;
     if(plist != null){
       for(Photon p : plist){
         if(p!=null){
           flux_r+=abs(p.power_r);
           flux_g+=abs(p.power_g);
           flux_b+=abs(p.power_b);
           float curr_dist = sqrt((pow(intersectionPoint.getX()-p.pos[0],2))+(pow(intersectionPoint.getY()-p.pos[1],2))+(pow(intersectionPoint.getZ()-p.pos[2],2)));
           if(curr_dist > max_r){
             max_r = curr_dist;
           }
         }
       }
       float irradiance_r = flux_r/(2*(float)Math.PI*max_r*max_r);
       float irradiance_g = flux_g/(2*(float)Math.PI*max_r*max_r);
       float irradiance_b = flux_b/(2*(float)Math.PI*max_r*max_r);
       if(max_r!=0){
         //Color tempColor = new Color(irradiance_r*diffuseSurfaceColor.getR(), irradiance_g*diffuseSurfaceColor.getG(), irradiance_b*diffuseSurfaceColor.getB());
         Color tempColor = new Color(irradiance_r*3, irradiance_g*3, irradiance_b*3);
         //println(flux_r + "\t" + flux_g + "\t" + flux_b + "\t" + max_r);
         //println("adding color:\t" + tempColor.toString());
         totalColor.add(tempColor);
       }
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
 //int num_near = 40;
 //boolean fast = false;
  
 //// draw all the "photons" in black only once
 //if (first_draw) {
 //  // get ready to draw
 //  background (255, 255, 255);
 //  noStroke();
 //  fill (0, 0, 0);
  
 //  // draw the initial photons
 //  photons.draw(photons.root);
    
 //  first_draw = false;
 //}
  
 //noStroke();
  
 //ArrayList<Photon> plist;
  
 //// re-draw the last frame's photons in black
 //fill (0, 0, 0);
 //plist = photons.find_near ((float) old_mouseX, (float) old_mouseY, 0.0, num_near, 200.0);
 //draw_photon_list (plist);
   
 //// draw the new near photons in red
 //fill (255, 0, 0);
 //plist = photons.find_near ((float) mouseX, (float) mouseY, 0.0, num_near, 200.0);
 //draw_photon_list (plist);

 //// save these mouse positions for next frame
 //old_mouseX = mouseX;
 //old_mouseY = mouseY;
}

// when mouse is pressed, print the cursor location
void mousePressed() {
  println ("mouse: " + mouseX + " " + mouseY);
}

// draw a list of photons
void draw_photon_list(ArrayList<Photon> plist)
{
  for (int i = 0; i < plist.size(); i++) {
    Photon photon = plist.get(i);
    ellipse (photon.pos[0], photon.pos[1], photon_radius, photon_radius);
  }
}


boolean shootPhoton(boolean fromReflective, Ray ray, float photon_r, float photon_g, float photon_b){
  //println(ray.getOrigin().toString());
  //println(ray.getDirection());
  ArrayList<Shape> allObjects = currentScene.getAllObjects();
  float minTime = MAX_FLOAT;
  IntersectionObject intersectionInfo = null;
  for(Shape a : allObjects){
    IntersectionObject currIntersectionInfo = a.intersects(ray);
    if(currIntersectionInfo.getTime() > 0 && currIntersectionInfo.getTime() < minTime){
      minTime = currIntersectionInfo.getTime();
      intersectionInfo = currIntersectionInfo;
    }
  }
  
  if(intersectionInfo != null){
    float reflective_coeff = intersectionInfo.getShape().getSurface().getReflectiveCoefficient();
    // if it is reflective then bounce it
    Point intersectionPoint = intersectionInfo.getIntersectionPoint();
    if(reflective_coeff > 0){
       PVector babyRay = intersectionPoint.subtract(ray.getOrigin());
       babyRay.div(babyRay.mag());
       babyRay.sub(PVector.mult(intersectionInfo.getSurfaceNormal(),(2*(babyRay.dot(intersectionInfo.getSurfaceNormal())))));
       babyRay.div(babyRay.mag());
       Point newOrigin = new Point(intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ());
       newOrigin.movePoint(babyRay, 0.00001);
       Ray newRecurseRay = new Ray(newOrigin, babyRay);
       // TODO Math here to see if we will shoot this new recurse ray
       return shootPhoton(true, newRecurseRay, photon_r*reflective_coeff, photon_g*reflective_coeff, photon_b*reflective_coeff);
    }
    // if it came from a reflective surface and current is diffuse, then store it
    else if(fromReflective && reflective_coeff == 0){
      photons.add_photon(new Photon (intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ(), photon_r/currentScene.num_cast, photon_g/currentScene.num_cast, photon_b/currentScene.num_cast));
      return true;
    }
    // else it came from eye and hit the diffuse surface first
    else{
      return false;
    }
  }
  return false;
}

void shootDiffusePhoton(int bounces, Ray ray, float photon_r, float photon_g, float photon_b){
  if(bounces < 10){
  ArrayList<Shape> allObjects = currentScene.getAllObjects();
  float minTime = MAX_FLOAT;
  IntersectionObject intersectionInfo = null;
  for(Shape a : allObjects){
    IntersectionObject currIntersectionInfo = a.intersects(ray);
    if(currIntersectionInfo.getTime() > 0 && currIntersectionInfo.getTime() < minTime){
      minTime = currIntersectionInfo.getTime();
      intersectionInfo = currIntersectionInfo;
    }
  }
  
  if(intersectionInfo != null){
    float reflective_coeff = intersectionInfo.getShape().getSurface().getReflectiveCoefficient();
    
    Point intersectionPoint = intersectionInfo.getIntersectionPoint();
    PVector currSurfaceNorm = intersectionInfo.getShape().shapeNormal(intersectionPoint);
    
    //println("hit something");
    //println(intersectionPoint.toString());
    //println("reflective_coeff\t" + reflective_coeff);
    //println("diffuse color\t" + intersectionInfo.getShape().getSurface().getDiffuseColor().toString());
    // if it is reflective just "reflect it" and do not increase bounces
    if(reflective_coeff > 0){
      //println("reflects");
     PVector babyRay = intersectionPoint.subtract(ray.getOrigin());
     babyRay.div(babyRay.mag());
     babyRay.sub(PVector.mult(intersectionInfo.getSurfaceNormal(),(2*(babyRay.dot(intersectionInfo.getSurfaceNormal())))));
     babyRay.div(babyRay.mag());
     Point newOrigin = new Point(intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ());
     newOrigin.movePoint(babyRay, 0.00001);
     Ray newRecurseRay = new Ray(newOrigin, babyRay);
     // TODO Math here to see if we will shoot this new recurse ray
     shootDiffusePhoton(bounces, newRecurseRay, photon_r*reflective_coeff, photon_g*reflective_coeff, photon_b*reflective_coeff);
    }
    
    // diffuse stuff and russian roulette
    else if(reflective_coeff == 0){
      // if already bounced then store the photon
      if(bounces > 0){
        //println("storing a photon:\t" + photon_r/currentScene.num_cast + "\t" + photon_g/currentScene.num_cast + "\t" + photon_b/currentScene.num_cast);
        photons.add_photon(new Photon (intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ(), photon_r/currentScene.num_cast, photon_g/currentScene.num_cast, photon_b/currentScene.num_cast));
        //photons.add_photon(new Photon (intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ(), 1,1,1));
      }
      Color diffColor = intersectionInfo.getShape().getSurface().getDiffuseColor();
      float avg = (diffColor.getR() + diffColor.getG() + diffColor.getB())/3.0;
      //float avg = (photon_r + photon_g + photon_b)/3.0;
      if(random(1) < avg){
        //println("diffuse bounce");
        // create bounced photon direction
        // pick random point in unit disk
        float currX = random(2)-1;
        float currY = random(2)-1;
        while(sqrt(currX*currX + currY*currY) > 1){
          currX = random(2) -1;
          currY = random(2) -1;
        }
        // project up
        float currZ = sqrt(1 - currX*currX - currY*currY);
        PVector p = new PVector(1.0, 0, 0);
        if(abs(currSurfaceNorm.x) > abs(currSurfaceNorm.y) && abs(currSurfaceNorm.x) > abs(currSurfaceNorm.z)){
          p = new PVector(0, 1.0, 0);
        }
        PVector Q = currSurfaceNorm.cross(p);
        Q = Q.div(Q.mag());
        PVector P = currSurfaceNorm.cross(Q);
        P = P.div(P.mag());
        PVector newDir = P.mult(currX).add(Q.mult(currY)).add(currSurfaceNorm.mult(currZ));
        Point newOrigin = new Point(intersectionPoint.getX(), intersectionPoint.getY(), intersectionPoint.getZ());
        newOrigin.movePoint(newDir, 0.00001);
        Ray newDiffRay = new Ray(newOrigin, newDir);
        shootDiffusePhoton(bounces+1, newDiffRay, photon_r*(diffColor.getR()/avg), photon_g*(diffColor.getG()/avg), photon_b*(diffColor.getB()/avg));
      }
    }
  }
  }
}