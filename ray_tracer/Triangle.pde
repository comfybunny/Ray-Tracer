public class Triangle extends Shape {
  
  private Point P0;
  private Point P1;
  private Point P2;
  
  public Triangle(Point P0, Point P1, Point P2, Surface surface){
    this.P0 = P0;
    this.P1 = P1;
    this.P2 = P2;
    addSurface(surface);
  }
  
  public IntersectionObject intersects(Ray tempRay){
    // intersect ray w/ plane of polygon
    PVector E1 = P1.subtract(P0);
    PVector E2 = P2.subtract(P0);
    PVector planeNormal = new PVector();
    planeNormal = E1.cross(E2);
    planeNormal.div(planeNormal.mag());
    float parallelTest = tempRay.getDirection().dot(planeNormal);
    if(parallelTest == 0){
      return new IntersectionObject(-1, null);
    }
    float planeDval = -planeNormal.dot(P0.getPVector());
    float intersectionTime = -(planeNormal.dot(tempRay.getOrigin().getPVector()) + planeDval)/(parallelTest);
    
    Point intersection = tempRay.hitPoint(intersectionTime);

    PVector P0inter = intersection.subtract(P0);
    PVector P1inter = intersection.subtract(P1);
    PVector P2inter = intersection.subtract(P2);
    
    PVector P0P1 = P1.subtract(P0);
    PVector P1P2 = P2.subtract(P1);
    PVector P2P0 = P0.subtract(P2);
    
    if(P0P1.cross(P0inter).dot(planeNormal)<0){
     return new IntersectionObject(-1, null);
    }
    if(P1P2.cross(P1inter).dot(planeNormal)<0){
     return new IntersectionObject(-1, null);
    }
    if(P2P0.cross(P2inter).dot(planeNormal)<0){
     return new IntersectionObject(-1, null);
    }
    Point intersectionPoint = tempRay.hitPoint(intersectionTime);
    return new IntersectionObject(intersectionTime, shapeNormal(intersectionPoint), intersectionPoint, this);
  }

  public PVector shapeNormal(Point hitPoint){
    PVector E1 = P1.subtract(P0);
    PVector E2 = P2.subtract(P0);
    PVector planeNormal = new PVector();
    planeNormal = E1.cross(E2);
    planeNormal.div(planeNormal.mag());
    
    return planeNormal;
  }

  public String debug(){
    return "P0: " + P0.toString() + "\nP1: " + P1.toString() + "\nP2: " + P2.toString();
  }
  
  public Point minPoint(){
    float xmin = min(P0.getX(), P1.getX(), P2.getX());
    float ymin = min(P0.getY(), P1.getY(), P2.getY());
    float zmin = min(P0.getZ(), P1.getZ(), P2.getZ());
    return new Point(xmin, ymin, zmin);
  }
  
  public Point maxPoint(){
    float xmax = max(P0.getX(), P1.getX(), P2.getX());
    float ymax = max(P0.getY(), P1.getY(), P2.getY());
    float zmax = max(P0.getZ(), P1.getZ(), P2.getZ());
    return new Point(xmax, ymax, zmax);
  }
  
  public Point getCentroid(){
    return new Point((P0.getX() + P1.getX() + P2.getX())/3.0, (P0.getY() + P1.getY() + P2.getY())/3.0, (P0.getZ() + P1.getZ() + P2.getZ())/3.0);
  }
}