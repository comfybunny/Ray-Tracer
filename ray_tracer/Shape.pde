public abstract class Shape{
  
  private Surface surface;
  //private Box box;
  
  abstract IntersectionObject intersects(Ray tempRay);
    
  abstract PVector shapeNormal(Point hitPoint);
  
  abstract String debug();
  
  public void addSurface(Surface surface){
    this.surface = surface;
  }
  
  public Surface getSurface(){
    return surface;
  }
  
  public Point minPoint(){
    return new Point();
  }
  
  public Point maxPoint(){
    return new Point();
  }
  
  public Point getCentroid(){
    return null;
  }
  
  public IntersectionObject intersectPrint(Ray ray){
    return null;
  }
  
  public float P0X(){
    return -100;
  }
  public float P1X(){
    return -100;
  }
  
}