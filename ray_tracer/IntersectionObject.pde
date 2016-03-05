public class IntersectionObject{
  
  float time;
  PVector surfaceNormal;
  Point intersectionPoint;
  
  public IntersectionObject(float time, PVector surfaceNormal){
    this.time = time;
    this.surfaceNormal = surfaceNormal;
    intersectionPoint = null;
  }
  
  public IntersectionObject(float time, PVector surfaceNormal, Point intersectionPoint){
    this.time = time;
    this.surfaceNormal = surfaceNormal;
    this.intersectionPoint = intersectionPoint;
  }
  
  public float getTime(){
    return time;
  }
  public PVector getSurfaceNormal(){
    return surfaceNormal;
  }
  public void setSurfaceNormal(PVector newNormal){
    surfaceNormal = newNormal;
  }
  
  public Point getIntersectionPoint(){
    return intersectionPoint;
  }
  
  public void setIntersectionPoint(Point point){
    intersectionPoint = point;
  }
}