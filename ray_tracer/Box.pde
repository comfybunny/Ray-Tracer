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
  
  // constructor for bounding box boxes
  public Box(Point min, Point max){
    xmin = min.getX();
    xmax = max.getX();
    ymin = min.getY();
    ymax = max.getY();
    zmin = min.getZ();
    zmax = max.getZ();
  }
  /**
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
    return new IntersectionObject(tmin, shapeNormal(intersection_point), intersection_point, this);
  }**/
  
  public IntersectionObject intersects(Ray tempRay){
    float tmin = Float.NEGATIVE_INFINITY;
    float tmax = Float.POSITIVE_INFINITY;
    PVector direction = tempRay.getDirection();
    Point origin = tempRay.getOrigin();
    if(direction.x != 0.0){
      float xmint = (xmin-origin.getX())/direction.x;
      float xmaxt = (xmax-origin.getX())/direction.x;
      tmin = max(tmin, min(xmint, xmaxt));
      tmax = min(tmax, max(xmint, xmaxt));
    }
    if(direction.y != 0.0){
      float ymint = (ymin-origin.getY())/direction.y;
      float ymaxt = (ymax-origin.getY())/direction.y;
      tmin = max(tmin, min(ymint, ymaxt));
      tmax = min(tmax, max(ymint, ymaxt));
    }
    if(direction.z != 0.0){
      float zmint = (zmin-origin.getZ())/direction.z;
      float zmaxt = (zmax-origin.getZ())/direction.z;
      tmin = max(tmin, min(zmint, zmaxt));
      tmax = min(tmax, max(zmint, zmaxt));
    }
    if(tmax > 0 || tmax >= tmin){
      return new IntersectionObject(tmax, shapeNormal(tempRay.hitPoint(tmax)), tempRay.hitPoint(tmax), this);
    }
    return new IntersectionObject(-1, null);
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
    // println("Uh you probably messed up, how do you hit this side of a box?");
    return new PVector(0, 0, -1);
  }
  
  public String debug(){
    return "xmin: " + xmin + "\t\tymin: " + ymin + "\t\tzmin: " + zmin + "\t\txmax: " + xmax + "\t\tymax: " + ymax + "\t\tzmax: " + zmax;
  }
  
  public void includePoint(Point minPoint, Point maxPoint){
    float minx = minPoint.getX();
    float miny = minPoint.getY();
    float minz = minPoint.getZ();
    
    float maxx = maxPoint.getX();
    float maxy = maxPoint.getY();
    float maxz = maxPoint.getZ();
    
   if(minx < xmin){
     xmin = minx;
   }
   if(maxx > xmax){
     xmax = maxx;
   }
   if(miny < ymin){
     ymin = miny;
   }
   if(maxy > ymax){
     ymax = maxy;
   }
   if(minz < zmin){
     zmin = minz;
   }
   if(maxz > zmax){
     zmax = maxz;
   }
  }

}