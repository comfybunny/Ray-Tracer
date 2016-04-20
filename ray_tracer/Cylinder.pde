public class Cylinder extends Shape{
  
  private float radius;
  private Point location;
  private float ymax;
  
  public Cylinder(float radius, Point location, float ymax, Surface surface){
    this.radius = radius;
    this.location = location;
    this.ymax = ymax;
    addSurface(surface);
  }
  
  public float getRadius(){
    return radius;
  }
  
  public Point getLocation(){
    return location;
  }
  
  public float getYmax(){
    return ymax;
  }
  
  
  public IntersectionObject intersects(Ray tempRay){
    
    // equation for infinite cylinder along y axis is : (x-a)^2 + (z-b)^2 = r^2
    Point origin = tempRay.getOrigin();
    PVector direction = tempRay.getDirection();
    PVector centerToOrigin = origin.subtract(location);
    float a = sq(direction.x) + sq(direction.z);
    float b = 2*direction.x*(centerToOrigin.x) + 2*direction.z*(centerToOrigin.z);
    float c = sq(centerToOrigin.x) + sq(centerToOrigin.z) - sq(radius);
    float discriminant = sq(b) - (4.0*a*c);
        
    if(discriminant < 0){
      // if it doesnt hit infinite length cylinder it won't hit a finite length cylinder
      return new IntersectionObject(-1, null);
    }
    
    // retValPlus and retValMinus are the two times it hits the body
    float retValPlus = (-1.0*b+sqrt(discriminant))/(2.0*a);
    float retValMinus = (-1.0*b-sqrt(discriminant))/(2.0*a);
    
    float y1 = origin.getY() + retValMinus*direction.y;
    float y2 = origin.getY() + retValPlus*direction.y;
    
    float ymin = location.getY();
    
    float tMin = -1;
    
    
    // minimum time to hit body of cylinder
    if(ymin <= y1 && y1 <= ymax && ymin <= y2 && y2 <= ymax){
      // if both past test, return smallest nonnegative time
      tMin = StaticUtility.smallestPositive(retValMinus, retValPlus);
    }
    else if(ymin <= y1 && y1 <= ymax){
      tMin = retValMinus;
    }
    else if(ymin <= y2 && y2 <= ymax){
      tMin = retValPlus;
    }
    // else it doesn't hit body of cylinder
    
    // check minimum time of hitting end caps
    if( (y1 <= ymin && y2 >= ymax) || (y2 <= ymin && y1 >= ymax) ){
      float tempTime1 = (ymin - origin.getY())/direction.y;
      float tempTime2 = (ymax - origin.getY())/direction.y;
      tMin = StaticUtility.smallestPositive(tempTime1, tempTime2);
    }
    else if ( (y1 <= ymin && y2 >= ymin) || (y2 <= ymin && y1 >= ymin) ) {
     float tempTime = (ymin - origin.getY())/direction.y;
     tMin = StaticUtility.smallestPositive(tempTime, tMin);
    }
    else if ( (y1 <= ymax && y2 >= ymax) || (y2 <= ymax && y1 >= ymax) ) {
     float tempTime = (ymax - origin.getY())/direction.y;
     tMin = StaticUtility.smallestPositive(tempTime, tMin);
    }
    
    if(tMin == -1){
      return new IntersectionObject(tMin, null);
    }
    Point intersection_point = tempRay.hitPoint(tMin);
    return new IntersectionObject(tMin, shapeNormal(intersection_point), intersection_point, this);
  }
  
  
  public PVector shapeNormal(Point hitPoint){
    // if it hits the bottom of the cylinder
    if(StaticUtility.almost_equal(hitPoint.getY(), location.getY())){
     return new PVector(0,-1,0);
    }
    // if it hits the top of the cylinder
    else if(StaticUtility.almost_equal(hitPoint.getY(), ymax)){
     return new PVector(0,1,0);
    }
    // if it hits the body of the cylinder
    PVector cylinderNormal = hitPoint.subtract(new Point(location.getX(), hitPoint.getY(), location.getZ()));
    return cylinderNormal.div(cylinderNormal.mag());
  }
  
  public String debug(){
    return "Cylinder\t\tradius: " + radius + "\tlocation: " + location.toString() + "\tymax: " + ymax;
  }
  
}


public class Hollow_Cylinder extends Shape{
  
  private float radius;
  private Point location;
  private float ymax;
  
  public Hollow_Cylinder(float radius, Point location, float ymax, Surface surface){
    this.radius = radius;
    this.location = location;
    this.ymax = ymax;
    addSurface(surface);
  }
  
  public float getRadius(){
    return radius;
  }
  
  public Point getLocation(){
    return location;
  }
  
  public float getYmax(){
    return ymax;
  }
  
  
  public IntersectionObject intersects(Ray tempRay){
    
    // equation for infinite cylinder along y axis is : (x-a)^2 + (z-b)^2 = r^2
    Point origin = tempRay.getOrigin();
    PVector direction = tempRay.getDirection();
    PVector centerToOrigin = origin.subtract(location);
    float a = sq(direction.x) + sq(direction.z);
    float b = 2*direction.x*(centerToOrigin.x) + 2*direction.z*(centerToOrigin.z);
    float c = sq(centerToOrigin.x) + sq(centerToOrigin.z) - sq(radius);
    float discriminant = sq(b) - (4.0*a*c);
        
    if(discriminant < 0){
      // if it doesnt hit infinite length cylinder it won't hit a finite length cylinder
      return new IntersectionObject(-1, null);
    }
    
    // retValPlus and retValMinus are the two times it hits the body
    float retValPlus = (-1.0*b+sqrt(discriminant))/(2.0*a);
    float retValMinus = (-1.0*b-sqrt(discriminant))/(2.0*a);
    
    float y1 = origin.getY() + retValMinus*direction.y;
    float y2 = origin.getY() + retValPlus*direction.y;
    
    float ymin = location.getY();
    
    float tMin = -1;
    
    
    // minimum time to hit body of cylinder
    if(ymin <= y1 && y1 <= ymax && ymin <= y2 && y2 <= ymax){
      // if both past test, return smallest nonnegative time
      tMin = StaticUtility.smallestPositive(retValMinus, retValPlus);
    }
    else if(ymin <= y1 && y1 <= ymax){
     tMin = retValMinus;
    }
    else if(ymin <= y2 && y2 <= ymax){
     tMin = retValPlus;
    }
    
    if(tMin == -1){
      return new IntersectionObject(tMin, null);
    }
    Point intersection_point = tempRay.hitPoint(tMin);
    return new IntersectionObject(tMin, shapeNormal(intersection_point), intersection_point, this);
  }
  
  
  public PVector shapeNormal(Point hitPoint){
    // if it hits the body of the cylinder
    PVector cylinderNormal = hitPoint.subtract(new Point(location.getX(), hitPoint.getY(), location.getZ()));
    return cylinderNormal.div(cylinderNormal.mag());
  }
  
  public String debug(){
    return "Cylinder\t\tradius: " + radius + "\tlocation: " + location.toString() + "\tymax: " + ymax;
  }
  
}