public class Box extends Shape{

  private Point closest_point;
  private Point furthest_point;
  // private Point box_center;
  
  public Box(float xmin, float ymin, float zmin, float xmax, float ymax, float zmax, Surface surface){
    closest_point = new Point(xmin, ymin, zmin);
    furthest_point = new Point(xmax, ymax, zmax);
    // box_center = new Point((xmin+xmax)/2.0, (ymin+ymax)/2.0, (zmin+zmax)/2.0);
    addSurface(surface);
  }
  
  public IntersectionObject intersects(Ray tempRay){
    PVector direction = tempRay.getDirection();
    Point origin = tempRay.getOrigin();
    
    float xmint = (closest_point.getX()-origin.getX())/direction.x;
    float xmaxt = (furthest_point.getX()-origin.getX())/direction.x;
    float x_time = min(xmint, xmaxt);
    
    float ymint = (closest_point.getY()-origin.getY())/direction.y;
    float ymaxt = (furthest_point.getY()-origin.getY())/direction.y;
    float y_time = min(ymint, ymaxt);
    
    float zmint = (closest_point.getZ()-origin.getZ())/direction.z;
    float zmaxt = (furthest_point.getZ()-origin.getZ())/direction.z;
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
    if(StaticUtility.almost_equal(hitPoint.getX(), closest_point.getX())){
      return new PVector(-1, 0, 0);
    }
    else if(StaticUtility.almost_equal(hitPoint.getX(), furthest_point.getX())){
      return new PVector(1, 0, 0);
    }
    
    else if(StaticUtility.almost_equal(hitPoint.getY(), closest_point.getY())){
      return new PVector(0, -1, 0);
    }
    else if(StaticUtility.almost_equal(hitPoint.getY(), furthest_point.getY())){
      return new PVector(0, 1, 0);
    }
    
    else if(StaticUtility.almost_equal(hitPoint.getZ(), closest_point.getZ())){
      return new PVector(0, 0, 1);
    }
    println("Uh you probably messed up, how do you hit this side of a box?");
    return new PVector(0, 0, -1);
  }
  public String debug(){
    return "Box\\tclosest point: " + closest_point.toString() + "\furthest point: " + furthest_point.toString();
  }

}