public class Box extends Shape{

  private float xmin;
  private float ymin;
  private float zmin;
  private float xmax;
  private float ymax;
  private float zmax;
  
  // private Point box_center;
  
  public Box(float xmin, float ymin, float zmin, float xmax, float ymax, float zmax, Surface surface){
    // closest_point = new Point(xmin, ymin, zmin);
    // furthest_point = new Point(xmax, ymax, zmax);
    
    this.xmin = xmin;
    this.ymin = ymin;
    this.zmin = zmin;
    this.xmax = xmax;
    this.ymax = ymax;
    this.zmax = zmax;

    // box_center = new Point((xmin+xmax)/2.0, (ymin+ymax)/2.0, (zmin+zmax)/2.0);
    addSurface(surface);
  }
  
  public Box(float xmin, float ymin, float zmin, float xmax, float ymax, float zmax){
    this.xmin = xmin;
    this.ymin = ymin;
    this.zmin = zmin;
    this.xmax = xmax;
    this.ymax = ymax;
    this.zmax = zmax;
  }
  
  
  public IntersectionObject intersects(Ray tempRay){
    PVector direction = tempRay.getDirection();
    Point origin = tempRay.getOrigin();
    
    float xmint = (xmin-origin.getX())/direction.x;
    float xmaxt = (xmax-origin.getX())/direction.x;
    float x_time = min(xmint, xmaxt);
    
    float ymint = (ymin-origin.getY())/direction.y;
    float ymaxt = (ymax-origin.getY())/direction.y;
    float y_time = min(ymint, ymaxt);
    
    float zmint = (zmin-origin.getZ())/direction.z;
    float zmaxt = (zmax-origin.getZ())/direction.z;
    float z_time = min(zmint, zmaxt);
    
    // ideally this tmin will be the time for example if it hits xmin first, it could his y or z later, but then the min of y will give a negative time
    float tmin = max(x_time, y_time, z_time);
    float tmax = min(max(xmint, xmaxt), max(ymint, ymaxt), max(zmint, zmaxt));
    
    if(tmax < 0 || tmin > tmax){
      return new IntersectionObject(-1, null);
    }
    Point intersection_point = tempRay.hitPoint(tmin);
    return new IntersectionObject(tmin, shapeNormal(intersection_point), intersection_point);
  }
  
  public PVector shapeNormal(Point hitPoint){
    // check all the sides?
    if(StaticUtility.almost_equal(hitPoint.getX(), xmin)){
      return new PVector(-1, 0, 0);
    }
    else if(StaticUtility.almost_equal(hitPoint.getX(), xmax)){
      return new PVector(1, 0, 0);
    }
    
    else if(StaticUtility.almost_equal(hitPoint.getY(), ymin)){
      return new PVector(0, -1, 0);
    }
    else if(StaticUtility.almost_equal(hitPoint.getY(), ymax)){
      return new PVector(0, 1, 0);
    }
    
    else if(StaticUtility.almost_equal(hitPoint.getZ(), zmin)){
      return new PVector(0, 0, 1);
    }
    println("Uh you probably messed up, how do you hit this side of a box?");
    return new PVector(0, 0, -1);
  }
  
  public String debug(){
    return "I AM A BOX.";
  }
  
  public void includePoint(Point point){
    float x = point.getX();
    float y = point.getY();
    float z = point.getZ();
    
    // REMEMBER Z IS WEIRD AND BACKWARDS
    
    if(!(xmin <= x && x <= xmax)){
      // bigger than the curr max
      if(x > xmax){
        xmax = x;
      }
      // smaller than the curr min
      else{
        xmin = x;
      }
    }
    
    if(!(ymin <= y && y <= ymax)){
      // bigger than the curr max
      if(y > ymax){
        ymax = y;
      }
      // smaller than the curr min
      else{
        ymin = y;
      }
    }
    
    if(!(zmin <= z && z <= zmax)){
      // bigger than the curr max
      if(z > zmax){
        zmax = z;
      }
      // smaller than the curr min
      else{
        zmin = z;
      }
    }
    
  }

}