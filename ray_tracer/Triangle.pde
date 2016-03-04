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
    return new IntersectionObject(intersectionTime, shapeNormal(tempRay.hitPoint(intersectionTime)));
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
}